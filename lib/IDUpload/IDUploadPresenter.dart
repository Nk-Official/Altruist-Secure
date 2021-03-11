import 'dart:io';
import 'dart:math';
import 'package:altruist_secure_flutter/IDUpload/IDUploadView.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/apis/apis.dart';
import 'package:altruist_secure_flutter/blocs/customerInfo/custome_info_bloc.dart';
import 'package:altruist_secure_flutter/blocs/customerInfo/custome_info_event.dart';
import 'package:altruist_secure_flutter/blocs/customerInfo/custome_info_state.dart';
import 'package:altruist_secure_flutter/utils/StringConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:sweetalert/sweetalert.dart';

class IDUploadPresenter extends StatefulWidget {
  @override
  IDUploadPresenterState createState() => IDUploadPresenterState();
}

class IDUploadPresenterState extends State<IDUploadPresenter> {
  CustomeInfoBloc _bloc;
  bool isLoadingProgress = false;
  File _frontIDImage;
  File _backIDImage;
  var idproofScanCopyHttpURL;
  var idproofScanCopyBackHttpUrl;
  bool buttonVisibilty_ = false;
  bool imageVisible_ = false;
  bool editImage_ = false;
  bool buttonbackVisibilty_ = false;
  bool imageVisibleback_ = false;
  bool editImageback_ = false;
  String FrontImage_ = "";
  String BackImage_ = "";
  GlobalKey<FormState> _formKey;

  void _pickIdProofs(String tag) async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Select the image source"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Camera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Gallery"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));

    if (imageSource != null) {
      final file = await ImagePicker.pickImage(source: imageSource);
      if (file != null) {
        setState(() {
          if (tag == "FrontImage") {
            _frontIDImage = file;
            if (_frontIDImage != null) {
              print("FrontImage ===  $_frontIDImage");
              _bloc.add(UploadIDProofsEvent(
                  userId: PreferenceUtils.getString(Utils.USER_ID),
                  source: StringConstants.SOURCE,
                  idProof: _frontIDImage == null ? null : _frontIDImage,
                  idProofBack: _backIDImage == null ? null : _backIDImage));
            }
          } else {
            _backIDImage = file;
            if (_backIDImage != null) {
              print("BackImage ===  $_backIDImage");
              _bloc.add(UploadBackIDProofsEvent(
                  userId: PreferenceUtils.getString(Utils.USER_ID),
                  source: StringConstants.SOURCE,
                  idProofBack: _backIDImage == null ? null : _backIDImage));
            }
          }
          print(file.path);
        });
      }
    }
  }

  @override
  void initState() {
    PreferenceUtils.init();
    _bloc = CustomeInfoBloc(apisRepository: ApisRepository());
    mforntImage();
    mBackImage();
    super.initState();
  }

  void mforntImage() {
    if (PreferenceUtils.getString(Utils.FrontIDProof) == null ||
        PreferenceUtils.getString(Utils.FrontIDProof).isEmpty) {
      setState(() {
        buttonVisibilty_ = true;
        imageVisible_ = false;
        editImage_ = false;
      });
    } else {
      setState(() {
        FrontImage_ = PreferenceUtils.getString(Utils.FrontIDProof);
        buttonVisibilty_ = false;
        imageVisible_ = true;
        editImage_ = true;
        print("FrontImage_ $FrontImage_");
      });
    }
  }

  void mBackImage() {
    if (PreferenceUtils.getString(Utils.BackIDProof) == null ||
        PreferenceUtils.getString(Utils.BackIDProof).isEmpty) {
      setState(() {
        buttonbackVisibilty_ = true;
        imageVisibleback_ = false;
        editImageback_ = false;
      });
    } else {
      setState(() {
        BackImage_ = PreferenceUtils.getString(Utils.BackIDProof);
        buttonbackVisibilty_ = false;
        imageVisibleback_ = true;
        editImageback_ = true;
        print("BackImage_ $BackImage_");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: BlocListener(
        bloc: _bloc,
        listener: (BuildContext context, CustomeInfoState state) {
          if (state is InitialuploadIDProofState) {
            if (state.isLoading == false && !state.isSuccess) {
              //  AppUtils.showSnackBar(context, state.message);
            } else if (state.isLoading == false && state.isSuccess) {
//                    _frontIDImage = null;
//                    _backIDImage = null;
//                    //  AppUtils.showSnackBar(context, state.message);
//                    deviceDetailsIDProofs = state.deviceDetails;
              if (state.deviceDetails.idproofScanCopyHttpUrl != null) {
                FrontImage_ = state.deviceDetails.idproofScanCopyHttpUrl;
                PreferenceUtils.setString(Utils.FrontIDProof, FrontImage_);
              } else {
                FrontImage_ = "";
              }
              print("idproofScanCopyHttpURL in api $FrontImage_");
              mDialogSuccess("", "ID proof uploaded successfully");
              EventTracker.logEvent("UPLOAD_ID_PROOF_SUCCESS");
              Future.delayed(Duration(seconds: 2), () async {
                if (FrontImage_ != null) {
                  mforntImage();
                }
              });
            }
          }
          if (state is InitialuploadIDBackProofState) {
            if (state.isLoading == false && !state.isSuccess) {
              //  AppUtils.showSnackBar(context, state.message);
            } else if (state.isLoading == false && state.isSuccess) {
              if (state.deviceDetails.idproofScanCopyBackHttpUrl != null) {
                BackImage_ = state.deviceDetails.idproofScanCopyBackHttpUrl;
                PreferenceUtils.setString(Utils.BackIDProof, BackImage_);
              } else {
                BackImage_ = "";
              }
              print("idproofScanCopyBackHttpUrl in api $BackImage_");
              mDialogSuccess("", "ID proof uploaded successfully");
              EventTracker.logEvent("UPLOAD_ID_PROOF_SUCCESS");
              if (BackImage_ != null) {
                Future.delayed(Duration(seconds: 2), () async {
                  mBackImage();
                });
              }
            }
          }
        },
        child: BlocBuilder(
          bloc: _bloc,
          builder: (context, CustomeInfoState state) {
            if (state is InitialuploadIDProofState) {
              if (state.isLoading) {
                isLoadingProgress = state.isLoading;
              } else {
                isLoadingProgress = false;
              }
            }
            if (state is InitialuploadIDBackProofState) {
              if (state.isLoading) {
                isLoadingProgress = state.isLoading;
              } else {
                isLoadingProgress = false;
              }
            }
            return ModalProgressHUD(
              color: Colors.black,
              inAsyncCall: isLoadingProgress,
              child: IDProofView(
                key: _formKey,
                FrontImage: FrontImage_,
                BackImage: BackImage_,
                buttonVisibilty: buttonVisibilty_,
                buttonbackVisibilty: buttonbackVisibilty_,
                editImage: editImage_,
                editImageback: editImageback_,
                imageVisible: imageVisible_,
                imageVisibleback: imageVisibleback_,
                buttonUploadFrontID: () {
                  _pickIdProofs("FrontImage");
                },
                buttonUploadBackID: () {
                  _pickIdProofs("BackImage");
                },
                buttonUploadFrontIDEdit: () {
                  _pickIdProofs("FrontImage");
                },
                buttonUploadBackIDEdit: () {
                  _pickIdProofs("BackImage");
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void mDialogSuccess(String title, String Discription) {
    SweetAlert.show(context,
        title: title, subtitle: Discription, style: SweetAlertStyle.success);
  }
}
