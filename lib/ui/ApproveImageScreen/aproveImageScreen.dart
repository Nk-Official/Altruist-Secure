import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/apis/apis.dart';
import 'package:altruist_secure_flutter/blocs/saveUpdateUserDeviceInfo/save_update_user_device_info_bloc.dart';
import 'package:altruist_secure_flutter/blocs/saveUpdateUserDeviceInfo/save_update_user_device_info_event.dart';
import 'package:altruist_secure_flutter/blocs/saveUpdateUserDeviceInfo/save_update_user_device_info_state.dart';
import 'package:altruist_secure_flutter/ui/ApproveImageScreen/aproveImageScreenXml.dart';
import 'package:altruist_secure_flutter/ui/UserConfirmationScreen/userConfirmationScereen.dart';
import 'package:altruist_secure_flutter/utils/StringConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:io' show Platform;
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
class AproveImageScreen extends StatefulWidget {


  @override
  AproveImageScreenState createState() => AproveImageScreenState();
}

class AproveImageScreenState extends State<AproveImageScreen> {
  bool isLoadingProgress = false;
  SaveUpdateUserDeviceInfoBloc _bloc;
  bool visibleInvoiceUploadStatus_ =  false;
  bool visiblityImageStatus_ =  false;

  @override
  void initState() {
    super.initState();
    PreferenceUtils.init();
    _bloc = SaveUpdateUserDeviceInfoBloc(apisRepository: ApisRepository());

    _bloc.add(ImageInfoEvent(url: Utils.ImageApprovalUrl +PreferenceUtils.getString(Utils.USER_ID)));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: BlocListener(
          bloc: _bloc,
          listener:
              (BuildContext context, SaveUpdateUserDeviceInfoState state) {
                if (state is InitialImageInfotState ) {
                  print("Portal Image Status  Called ====  ");
                  if (state.isLoading == false && !state.isSuccess) {
                    mToast(state.message);
                  } else if (state.isLoading == false && state.isSuccess) {
                    var response = state.imageApprovalResponse.toString();
                    print("Portal Image Status ====  $response");
                    if(state.imageApprovalResponse.imageStatus == "Approve"){

                      showAlertDialog(context,"Dear, Customer, your invoice has been approved.");

                      Future.delayed(const Duration(seconds: 3), () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserConfirmationScereen(),
                              settings: RouteSettings(name: 'UserConfirmationScereen')),
                        );

                      });

                    }else if(state.imageApprovalResponse.imageStatus == "Pending"){
                      visibleInvoiceUploadStatus_ = false;
                      visiblityImageStatus_ = true;

                      showAlertDialog(context,"Dear, Customer, your invoice is still not approved please wait & check status in sometime");
                    }else{
                      mToast(state.imageApprovalResponse.imageStatus);

                      showAlertDialog(context,"Dear, Customer, your invoice has been rejected by Altruist Secure team, Please re-upload clear picture again");
                      visibleInvoiceUploadStatus_ = true;
                      visiblityImageStatus_ = false;
                    }


                    setState(() {

                    });
                  }
                }
                else if (state is InitialuploadDamageScreenState) {
                  if (state.isLoading == false && !state.isSuccess) {
                    //  AppUtils.showSnackBar(context, state.message);
                  } else if (state.isLoading == false && state.isSuccess) {
                    print("DamageScreen Status ${state.deviceDetailsUploads.statusDescription.errorCode}");
                    if (state.deviceDetailsUploads.statusDescription.errorCode ==
                        200) {
                      mToast("Invoice uploaded successfully");
                      EventTracker.logEvent("INVOICE_UPLOAD_SUCCESS");
                      mCallCheckStatusApi();
                    }else{
                      mToast(state.deviceDetailsUploads.statusDescription.errorMessage);
                      setState(() {
                        visibleInvoiceUploadStatus_ = true;
                        visiblityImageStatus_ = false;
                      });
                    }
                  }
                }
          },
          child: BlocBuilder(
            bloc: _bloc,
            builder: (context, SaveUpdateUserDeviceInfoState state) {
               if (state is InitialImageInfotState) {
                if (state.isLoading) {
                  isLoadingProgress = state.isLoading;
                } else {
                  isLoadingProgress = false;
                }
              } if (state is InitialuploadDamageScreenState) {
                if (state.isLoading) {
                  isLoadingProgress = state.isLoading;
                } else {
                  isLoadingProgress = false;
                }
              }
              return ModalProgressHUD(
                color: Colors.black,
                inAsyncCall: isLoadingProgress,
                child: ApproveImageScreen(
                  visibleInvoiceUploadStatus:visibleInvoiceUploadStatus_  ,
                  visiblityImageStatus:visiblityImageStatus_ ,
                  clickCheckStatus: (){
                    mCallCheckStatusApi();
                  },
                  clickUplaodInvoice: (){
                    visibleInvoiceUploadStatus_ = false;
                    visiblityImageStatus_ = false;
                    setState(() {
                    });

                    _pickImage();
                  },

                ),
              );
            },
          ),
        ));
  }

  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }


  void _pickImage() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Select Camera"),
          actions: <Widget>[
            MaterialButton(
              child: Text("Camera"),
              onPressed: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ));

    if (imageSource != null) {
      final file = await ImagePicker.pickImage(source: imageSource);
      if (file != null) {
        File image = file;

        if (image != null) {
          print("Damage Image Upload ===  $image");
          _bloc.add(UploadDamageScreenEvent(
              userId: PreferenceUtils.getString(Utils.USER_ID),
              source: StringConstants.SOURCE,
              damagedScreen: image == null ? null : image));
        }
      }
    }
  }

  void mCallCheckStatusApi(){
    _bloc.add(ImageInfoEvent(url: Utils.ImageApprovalUrl +PreferenceUtils.getString(Utils.USER_ID)));
  }


  showAlertDialog(BuildContext context,String message) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
