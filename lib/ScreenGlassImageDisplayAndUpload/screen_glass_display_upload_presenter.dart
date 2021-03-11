import 'dart:io';
import 'package:altruist_secure_flutter/CameraCaptureScreen/DeviceDetailsCode.dart';
import 'package:altruist_secure_flutter/DisplayTest/UI/display_test.dart';
import 'package:altruist_secure_flutter/ScreenGlassImageDisplayAndUpload/screen_glass_display_upload.dart';
import 'package:altruist_secure_flutter/ScreenGlassTest/screenglasstest.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/apis/apis.dart';
import 'package:altruist_secure_flutter/blocs/customerInfo/custome_info_bloc.dart';
import 'package:altruist_secure_flutter/blocs/customerInfo/custome_info_state.dart';
import 'package:altruist_secure_flutter/blocs/customerInfo/custome_info_event.dart';
import 'package:altruist_secure_flutter/ui/finalResultList/ResultListMain.dart';
import 'package:altruist_secure_flutter/utils/StringConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ScreenGlassDisplayAndUpload extends StatefulWidget {
  String filePath;

  ScreenGlassDisplayAndUpload(this.filePath);

//  File image;
//  ScreenGlassDisplayAndUpload(this.image)
  @override
  ScreenGlassDisplayAndUploadState createState() =>
      ScreenGlassDisplayAndUploadState(filePath);
}

class ScreenGlassDisplayAndUploadState
    extends State<ScreenGlassDisplayAndUpload> {
  CustomeInfoBloc _bloc;
  bool isLoadingProgress = false;
  bool imageVisible_ = true;
  String Imageshow_;
  bool buttonVisibilty_ = true;
  bool textVisible1_ = false;
  bool true_status_ = false;
  bool false_status_ = false;
  bool resultText_status_ = false;
  bool checkStatusClick_ = false;
  bool buttonvisibleSkip_ = false;

  var mTextStatus_ = TextEditingController();
  GlobalKey<FormState> _formKey;
  String filePath;
  ProgressDialog pr;

  ScreenGlassDisplayAndUploadState(this.filePath);

  int counter = 0;

  @override
  void initState() {
    PreferenceUtils.init();
    _bloc = CustomeInfoBloc(apisRepository: ApisRepository());
    mTextStatus_ = TextEditingController();
    print("filePath in ScreenGlassDisplayAndUploadState ====  $filePath");
    PreferenceUtils.setString(Utils.JWT_TOKEN_QRCODE, "1");
    Imageshow_ = filePath;
    pr = ProgressDialog(
      context,
      isDismissible: false,
    );
    pr.update(
      progress: 50.0,
      message: Utils.dailog_message,
      progressWidget: Container(
          padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    //   mforntImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: BlocListener(
        bloc: _bloc,
        listener: (BuildContext context, CustomeInfoState state) {
          if (state is InitialuploadDamageScreenState) {
            if (state.isLoading == false && !state.isSuccess) {
              //  AppUtils.showSnackBar(context, state.message);
            } else if (state.isLoading == false && state.isSuccess) {
              print(
                  "DamageScreen Status ${state.deviceDetailsUploads.statusDescription.errorCode}");
              if (state.deviceDetailsUploads.statusDescription.errorCode ==
                  200) {
                setState(() {
                  imageVisible_ = false;
                  buttonVisibilty_ = false;
                  textVisible1_ = true;
                });

                setState(() {
                  imageVisible_ = false;
                  buttonVisibilty_ = false;
                  textVisible1_ = false;
                });
                counter++;
                _onLoading(0);
                Future.delayed(Duration(seconds: 5), () async {
                  _bloc.add(DamageStatusEvent());
                });
              }
            }
          }
          if (state is InitialDamageStatusScreenState) {
            if (state.isLoading == false && !state.isSuccess) {
              //  AppUtils.showSnackBar(context, state.message);
            } else if (state.isLoading == false && state.isSuccess) {
              print(
                  "DamageScreen Status ${state.deviceDetailsUploads.statusDescription.errorCode}");
              if (state.deviceDetailsUploads.statusDescription.errorCode ==
                  200) {
                Future.delayed(Duration(seconds: 1), () async {
                  if (state.deviceDetailsUploads.deviceDetailsUploads.status ==
                      "0") {
                    counter++;
                    print("Counter=== $counter");
                    if (counter <= 9) {
                      Future.delayed(Duration(seconds: 5), () async {
                        _bloc.add(DamageStatusEvent());
                      });
                    } else {
                      mInprocessImageSatus(true);
                    }
                  } else if (state
                          .deviceDetailsUploads.deviceDetailsUploads.status ==
                      "1") {
                    setState(() {
                      imageVisible_ = false;
                      buttonVisibilty_ = false;
                      textVisible1_ = false;
                    });
                    loadProgress(true);
                  } else if (state
                          .deviceDetailsUploads.deviceDetailsUploads.status ==
                      "2") {
                    setState(() {
                      imageVisible_ = false;
                      buttonVisibilty_ = false;
                      textVisible1_ = false;
                    });
                    loadProgress(false);
                  }
                });
              }
            }
          }
        },
        child: BlocBuilder(
          bloc: _bloc,
          builder: (context, CustomeInfoState state) {
            if (state is InitialuploadDamageScreenState) {
              if (state.isLoading) {
                isLoadingProgress = state.isLoading;
              } else {
                isLoadingProgress = false;
              }
            }

            if (state is InitialDamageStatusScreenState) {
//              if (state.isLoading) {
//                isLoadingProgress = state.isLoading;
//              } else {
//                isLoadingProgress = false;
//              }
            }

            return ModalProgressHUD(
              color: Colors.black,
              inAsyncCall: isLoadingProgress,
              child: ScreenGlassDisplay(
                key: _formKey,
                imageVisible: imageVisible_,
                Imageshow: Imageshow_,
                UploadImage: () {
                  File image = File(Imageshow_);
                  if (image != null) {
                    print("Damage Image Upload ===  $image");
                    _bloc.add(UploadDamageScreenEvent(
                        userId: PreferenceUtils.getString(Utils.USER_ID),
                        source: StringConstants.SOURCE,
                        damagedScreen: image == null ? null : image));
                  }
                },
                ReclickImage: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CameraScreen(),
                        settings: RouteSettings(name: 'Vibration')),
                  );
                },
                buttonVisibilty: buttonVisibilty_,
                textVisible1: textVisible1_,
                true_status: true_status_,
                false_status: false_status_,
                resultText_status: resultText_status_,
                mTextStatus: mTextStatus_,
                buttonvisibleCheckStatus: checkStatusClick_,
                checkStatusClick: () {
                  setState(() {
                    resultText_status_ = false;
                    true_status_ = false;
                    false_status_ = false;
                    checkStatusClick_ = false;
                    buttonvisibleSkip_ = false;
                  });
                  _onLoading(0);
                  _bloc.add(DamageStatusEvent());
                },
                buttonvisibleSkip: buttonvisibleSkip_,
                mSkip: () {
                  PreferenceUtils.setString(Utils.ScreenDamageSatatus, "false");
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResultListMain(),
                          settings: RouteSettings(name: 'ResultListMain')),
                    );
                  });

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

  void _onLoading(int flag) async {
    if (flag == 0) {
      await pr.show();
    }
    if (flag == 1) {
      await pr.hide();
    }
  }

  loadProgress(bool status) {
    _onLoading(1);
    setState(() {
      if (status == true) {
        resultText_status_ = true;
        true_status_ = true;
        false_status_ = false;
        checkStatusClick_ = false;
        buttonvisibleSkip_ = false;
        mTextStatus_.text = Utils.TestSuccessfull;
        PreferenceUtils.setString(Utils.ScreenDamageSatatus, "true");
      } else {
        resultText_status_ = true;
        true_status_ = false;
        false_status_ = true;
        checkStatusClick_ = false;
        buttonvisibleSkip_ = false;
        mTextStatus_.text = Utils.Testfailed;
        PreferenceUtils.setString(Utils.ScreenDamageSatatus, "false");
      }
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => DisplayTest(),
              settings: RouteSettings(name: 'DisplayTest')),
        );
      });
    });

//    if (visible == true) {
//      setState(() {
//        visible = false;
//        if (true_status == true) {
//          resultText_status = true;
//          true_status = true;
//          false_status = false;
//          mTextStatus.text = Utils.TestSuccessfull;
//        } else {
//          resultText_status = true;
//          false_status = true;
//          true_status = false;
//          mTextStatus.text = Utils.Testfailed;
//        }
//        Future.delayed(const Duration(milliseconds: 2000), () {
//          Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(
//                builder: (context) => DisplayTest(),
//                settings: RouteSettings(name: 'headPhoneTest')),
//          );
//        });
//        //  false_status = false;
//      });
//    } else {
//      setState(() {
//        visible = true;
//      });
//    }

  }

  void mInprocessImageSatus(bool status) {
    _onLoading(1);
    counter = 0;
    setState(() {
      if (status == true) {
        resultText_status_ = false;
        true_status_ = false;
        false_status_ = false;
        checkStatusClick_ = true;
        buttonvisibleSkip_ = true;
      } else {}
    });
  }
}
