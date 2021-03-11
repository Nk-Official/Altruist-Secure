import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:altruist_secure_flutter/ChatHead/ChatHead.dart';
import 'package:altruist_secure_flutter/DisplayTest/UI/display_test.dart';
import 'package:altruist_secure_flutter/ScreenGlass&IMEIInstructionPage/ScreenGlassImeiInstructionPage.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/apis/apis.dart';
import 'package:altruist_secure_flutter/blocs/customerInfo/custome_info_bloc.dart';
import 'package:altruist_secure_flutter/blocs/customerInfo/custome_info_event.dart';
import 'package:altruist_secure_flutter/blocs/customerInfo/custome_info_state.dart';
import 'package:altruist_secure_flutter/models/requests/qr_code_request/QRCodeRequest.dart';
import 'package:altruist_secure_flutter/models/requests/qrcode_scan_request/qrcodescan_status.dart';
import 'package:altruist_secure_flutter/ui/finalResultList/ResultListMain.dart';
import 'package:altruist_secure_flutter/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:need_resume/need_resume.dart';

class ChatHeadProcess extends StatefulWidget {
  @override
  ChatHeadProcessState createState() => ChatHeadProcessState();
}

class ChatHeadProcessState extends ResumableState<ChatHeadProcess> {
  CustomeInfoBloc _bloc;
  bool isLoadingProgress = false;
  bool mTextVisibility_;
  bool mButtonVisibility_;
  bool ORCodeVisibilty_;
  String ImageQRCode_;
  bool isResendEnabled_ = false;
  bool true_status_;
  bool false_status_;
  bool resultText_status_;
  var mTextStatus_ = TextEditingController();
  bool mStatusInfo;
  bool mimeitestStatus_;
  bool buttonvisibleSkip_;
  bool skiptest_;
  bool inprocessText_;
  bool buttonvisibleCheckStatus_;
  bool textVisibilityNotUploadAnything_;
  bool ApiBasedTextStatus = false;
  static const platform =
      const MethodChannel('samples.flutter.dev/battery/vibration_test');
  Timer _timer;
  Timer timer;
  int counterForApi = 0;
  int start = 10;
  int StartTimer = 5;
  ProgressDialog pr;
  String qrToken;
  String FalseCaseFlag;
  String qr_token;
  var ResponseFromOutSide;

  @override
  void onReady() {
    // Implement your code inside here

    print('ChatHeadScreen is ready!');
  }

  @override
  void onResume() {
    print('ChatHeadScreen is resumed!');
//    print(
//        'ChatHeadScreen  resumed ResponseFromOutSide value $ResponseFromOutSide');
//    //  startTimerForScanQrCodeStatus(0);
//
//    if(timer !=null || _timer !=null) {
//      if (timer.isActive) {
//        timer.cancel();
//      }
//
//      if(_timer !=null) {
//        if (_timer.isActive) {
//          _timer.cancel();
//        }
//      }
//    }
//
//    if (ResponseFromOutSide == null && ImageQRCode_ != null) {
//      mWeightsVisibiltyForonResume();
//     setState(() {
//       buttonvisibleCheckStatus_ = true;
//     });
//    } else {
//      print('ChatHeadScreen else called ');
//      if (ResponseFromOutSide == "true") {
//        loadProgress(true);
//      } else if (ResponseFromOutSide == "false") {
//        loadProgressOnFalseCase();
//      } else if (ResponseFromOutSide == "not_found") {
//        mResultNotFound();
//      } else if (ResponseFromOutSide == "in_process") {
//        _onLoading(0);
//        startTimer(1);
//      }
//    }
  }

  @override
  void onPause() {
    // Implement your code inside here
    print('ChatHeadScreen is paused!');
  }

  @override
  void initState() {
    super.initState();
    PreferenceUtils.init();
    _bloc = CustomeInfoBloc(apisRepository: ApisRepository());
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
    setState(() {
      mTextVisibility_ = true;
      mButtonVisibility_ = false;
      ORCodeVisibilty_ = false;
      isResendEnabled_ = false;
      true_status_ = false;
      false_status_ = false;
      resultText_status_ = false;
      mimeitestStatus_ = false;
      mStatusInfo = false;
      skiptest_ = false;
      buttonvisibleSkip_ = false;
      inprocessText_ = false;
      buttonvisibleCheckStatus_ = false;
      textVisibilityNotUploadAnything_ = false;
    });

//    if (PreferenceUtils.getString(Utils.USER_ID) != null) {
//      var userId = int.parse(PreferenceUtils.getString(Utils.USER_ID));
//      var qrCodeRequest = QRCodeRequest(userId: userId);
//      _bloc.add(QRCodeEvent(qrCodeRequest: qrCodeRequest));
//    }

//    Timer(Duration(seconds: 60), () {
//      ApiBasedTextStatus = true;
//      print("ApiBasedTextStatus First Time ===  $ApiBasedTextStatus");
//      _bloc.add(DamageStatusEvent());
//    });

    if (PreferenceUtils.getString(Utils.USER_ID) != null) {
      var userId = int.parse(PreferenceUtils.getString(Utils.USER_ID));
      var qrCodeRequest = QRCodeRequest(userId: userId);
      _bloc.add(QRCodeEvent(qrCodeRequest: qrCodeRequest));
    }
  }

  void startTimerForScanQrCodeStatus(int timerState) {
    const oneSec = const Duration(seconds: 1);
    if (timerState == 1) {
      timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(
          () {
            StartTimer = StartTimer - 1;
            print("startTimerForScanQrCodeStatus Timer  ${StartTimer}");
            if (StartTimer == 0) {
              QRCodeScanStatus();
              StartTimer = 5;
            }
          },
        ),
      );
    } else {
      timer.cancel();
      _getChatHeadTest();
    }
  }

  void startTimer(int flag) {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (flag == 0) {
            timer.cancel();
          } else {
            if (start < 1) {
              timer.cancel();
            } else {
              start = start - 1;
              print("Timer  ${start}");
              if (start == 0) {
                print("Api Counter Count Before $counterForApi");
                counterForApi++;
                print("Api Counter Count After $counterForApi");
                if (counterForApi == 3) {
                  _timer.cancel();
//                loadProgressOnFalseCase(false);
                } else {
                  start = 10;
                }
                _bloc.add(DamageStatusEvent());
              }
            }
          }
        },
      ),
    );
  }

  Future<void> _getChatHeadTest() async {
    try {
      var userNumber = PreferenceUtils.getString(Utils.UserNumber);
      var userID = PreferenceUtils.getString(Utils.USER_ID);
      var userName = PreferenceUtils.getString(Utils.USER_ID);
      var userToken = PreferenceUtils.getString(Utils.JWT_TOKEN);

      print("userNumber ============ ${userNumber.toString()}");
      print("userID ============ ${userID.toString()}");
      print("userName ============ ${userName.toString()}");
      print("userToken ============ ${userToken.toString()}");
      print("qr_token when chathead test called ============ $qr_token}");

      platform.setMethodCallHandler(_handleCallback);
      final bool result = await platform.invokeMethod('chathead_test', {
        "user_number": userNumber.toString(),
        "user_id": userID.toString(),
        "user_name": userName.toString(),
        "user_token": userToken.toString(),
        "qr_token": qr_token,
      });

//      ReturnValue = await platform.invokeMethod('speaker_test', {"text": value_});

      print("Chat Head Result ${result}");
    } on PlatformException catch (e) {}
  }

  Future<dynamic> _handleCallback(MethodCall call) async {
    //  PreferenceUtils.init();
    switch (call.method) {
      case "chathead_test":
        var mVal = call.arguments;
        ResponseFromOutSide = mVal.toString();
        print("chathead_test Result ====== $ResponseFromOutSide ");
        if (mVal == "true") {
          loadProgress(true);
        } else if (mVal == "false") {
          loadProgressOnFalseCase();
        } else if (mVal == "not_found") {
          mResultNotFound();
        } else if (mVal == "in_process") {
          _onLoading(0);
          startTimer(1);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: BlocListener(
          bloc: _bloc,
          listener: (BuildContext context, CustomeInfoState state) {
            if (state is OrCodeScreenState) {
              if (state.isLoading == false && !state.isSuccess) {
                AppUtils.showSnackBar(context, state.message);
              } else if (state.isLoading == false && state.isSuccess) {
                print(
                    "QR Code Response ${state.qrCodeResponse.qrCode.qrCodeImagePath}");
                setState(() {
                  ORCodeVisibilty_ = true;
                  isResendEnabled_ = false;
                  ImageQRCode_ = state.qrCodeResponse.qrCode.qrCodeImagePath;
                  qr_token = state.qrCodeResponse.qrCode.qrCodeToken;
                  print("QR qr_token $qr_token");
                  PreferenceUtils.setString(Utils.JWT_TOKEN_QRCODE, qr_token);
                  //startTimer();
                });

                qrToken = state.qrCodeResponse.qrCode.qrCodeToken;

                if (qr_token != null) {
                  startTimerForScanQrCodeStatus(1);
                }

                if (FalseCaseFlag != null && FalseCaseFlag == "false") {
                } else {}
              }
            }

            if (state is InitialDamageStatusScreenState) {
              if (state.isLoading == false && !state.isSuccess) {
                //  AppUtils.showSnackBar(context, state.message);
              } else if (state.isLoading == false && state.isSuccess) {
                //  print("DamageScreen Status ${state.message}");
                print("ApiBasedTextStatus in api  ===  $ApiBasedTextStatus");
                if (state.errorCode != null && state.errorCode == "201") {
//                  if (_timer.isActive) {
//                    _timer.cancel();
//                  }
                  _onLoading(1);
                  mWeightsVisibilty();
                  mResultNotFound();
                } else {
                  if (state.deviceDetailsUploads.statusDescription.errorCode !=
                          null &&
                      state.deviceDetailsUploads.statusDescription.errorCode ==
                          200) {
                    if (state
                            .deviceDetailsUploads.statusDescription.errorCode ==
                        200) {
                      Future.delayed(Duration(seconds: 1), () async {
                        if (state.deviceDetailsUploads.deviceDetailsUploads
                                .status ==
                            "0") {
                          if (counterForApi == 3) {
                            _onLoading(1);
                            mWeightsVisibilty();
                            mResultInprocess();
                          }
                        } else if (state.deviceDetailsUploads
                                .deviceDetailsUploads.status ==
                            "1") {
                          if (_timer.isActive) {
                            _timer.cancel();
                          }

                          _onLoading(1);
                          mWeightsVisibilty();
                          loadProgress(true);
                        } else if (state.deviceDetailsUploads
                                .deviceDetailsUploads.status ==
                            "2") {
                          if (_timer.isActive) {
                            _timer.cancel();
                          }
                          _onLoading(1);
                          mWeightsVisibilty();
                          loadProgressOnFalseCase();
                        }
                      });
                    }
                  }
                }
              }
            }

            if (state is OrCodeSccanStatusState) {
              if (state.isLoading == false && !state.isSuccess) {
                //  AppUtils.showSnackBar(context, state.message);
              } else if (state.isLoading == false && state.isSuccess) {
                //  print("DamageScreen Status ${state.message}");
              //  print("OrCodeSccanStatusState in api  ===  ${state.qrCodeScanStatusResponse.errorCode}");
                print(
                    "OrCodeSccanStatusState qrCodeStatus  ===  ${state.qrCodeScanStatusResponse.qrCode.qrCodeStatus}");
                if (state.qrCodeScanStatusResponse.errorCode != null &&
                    state.qrCodeScanStatusResponse.errorCode == 200) {
                  if (state.qrCodeScanStatusResponse.qrCode.qrCodeStatus ==
                      true) {
                    inprocessText_ = false;
                    buttonvisibleCheckStatus_ = false;
                    buttonvisibleSkip_ = false;
                    mButtonVisibility_ = false;
                    mButtonVisibility_ = false;
                    resultText_status_ = false;
                    true_status_ = false;
                    false_status_ = false;
                    ORCodeVisibilty_ = false;
                    mTextVisibility_ = false;
                    skiptest_ = false;
                    isResendEnabled_ = false;
                    textVisibilityNotUploadAnything_ = false;
                    startTimerForScanQrCodeStatus(0);
                    // startTimerForScanQrCodeStatus();
                  }
                }
              }
            }
          },
          child: BlocBuilder(
            bloc: _bloc,
            builder: (context, CustomeInfoState state) {
              if (state is OrCodeScreenState) {
                if (state.isLoading) {
                  isLoadingProgress = state.isLoading;
                } else {
                  isLoadingProgress = false;
                }
              }

//              if (state is OrCodeScreenState) {
//                if (state.isLoading) {
//                  isLoadingProgress = state.isLoading;
//                } else {
//                  isLoadingProgress = false;
//                }
//              }
//              else if (state is InitialDamageStatusScreenState) {
//                if (state.isLoading) {
//                  isLoadingProgress = state.isLoading;
//                } else {
//                  isLoadingProgress = false;
//                }
//              }
              return ModalProgressHUD(
                color: Colors.black,
                inAsyncCall: isLoadingProgress,
                child: ChatBoxTest(
                    buttonvisible: mButtonVisibility_,
                    text1: mTextVisibility_,
                    ImageQRCode: ImageQRCode_,
                    ORCodeVisibilty: ORCodeVisibilty_,
                    isResendEnabled: isResendEnabled_,
                    counterVal: start,
                    true_status: true_status_,
                    false_status: false_status_,
                    mTextStatus: mTextStatus_,
                    resultText_status: resultText_status_,
                    buttonvisibleSkip: buttonvisibleSkip_,
                    skiptesText: skiptest_,
                    inprocessText: inprocessText_,
                    buttonvisibleCheckStatus: buttonvisibleCheckStatus_,
                    textVisibilityNotUploadAnything:
                        textVisibilityNotUploadAnything_,
                    checkStatusClick: () {
                      counterForApi = 0;
                      start = 10;
                      _onLoading(0);
                      startTimer(1);
                    },
                    mSkip: () {
                      //print("Timer isActive on Skip  ${_timer.isActive}");
//                      _timer.cancel()
//                      if(_timer.isActive){
//
//                      }
                      timer.cancel();
                      startTimer(0);
                      PreferenceUtils.setString(
                          Utils.ScreenDamageSatatus, "false");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResultListMain(),
                            settings: RouteSettings(name: 'ResultListMain')),
                      );
                    },
                    startClick: () {
                      setState(() {
                        mButtonVisibility_ = false;
                        isResendEnabled_ = false;
                        ORCodeVisibilty_ = false;
                        mTextVisibility_ = false;
                        buttonvisibleSkip_ = false;
                        skiptest_ = false;
                      });
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ScreenGlassImeiInstructionPage(),
                            settings: RouteSettings(
                                name: 'ScreenGlassImeiInstructionPage')),
                      );
                    }
//                    _onLoading(0);
//                    _getChatHeadTest();

                    ),
              );
            },
          ),
        ),
    );
  }

//  @override
//  void didChangeAppLifecycleState(AppLifecycleState state) {
//    super.didChangeAppLifecycleState(state);
//    if (state == AppLifecycleState.paused) {
//      // went to Background
//    }
//    if (state == AppLifecycleState.resumed) {
//      // came back to Foreground
//    }
//  }

  void _onLoading(int flag) async {
    if (flag == 0) {
      await pr.show();
    }
    if (flag == 1) {
      if (await pr.isShowing()) {
        await pr.hide();
      }
    }
  }

  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

  void QRCodeScanStatus() {
    if (PreferenceUtils.getString(Utils.USER_ID) != null && qrToken != null) {
      var userId = int.parse(PreferenceUtils.getString(Utils.USER_ID));
      var qrCodeScanRequest =
          QrCodeScanRequest(userId: userId, qrCodeToken: qrToken);
      _bloc.add(QRCodeStatusEvent(qrCodeScanRequest: qrCodeScanRequest));
    }
  }

  loadProgress(bool status) {
    setState(() {
      if (status == true) {
        resultText_status_ = true;
        true_status_ = true;
        false_status_ = false;
        ORCodeVisibilty_ = false;
        buttonvisibleSkip_ = false;
        mButtonVisibility_ = false;
        mTextVisibility_ = false;
        skiptest_ = false;
        isResendEnabled_ = false;
        textVisibilityNotUploadAnything_ = false;
        mTextStatus_.text = Utils.TestSuccessfull;
        PreferenceUtils.setString(Utils.ScreenDamageSatatus, "true");
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DisplayTest(),
                settings: RouteSettings(name: 'DisplayTest')),
          );
        });
      }
    });
  }

  loadProgressOnFalseCase() {
    setState(() {
      resultText_status_ = false;
      true_status_ = false;
      false_status_ = false;
      ORCodeVisibilty_ = false;
      buttonvisibleSkip_ = true;
      mButtonVisibility_ = true;
      mTextVisibility_ = false;
      skiptest_ = false;
      isResendEnabled_ = false;
      textVisibilityNotUploadAnything_ = false;
      mTextStatus_.text = Utils.Testfailed;
      PreferenceUtils.setString(Utils.ScreenDamageSatatus, "false");
      if (PreferenceUtils.getString(Utils.USER_ID) != null) {
        var userId = int.parse(PreferenceUtils.getString(Utils.USER_ID));
        var qrCodeRequest = QRCodeRequest(userId: userId);
        _bloc.add(QRCodeEvent(qrCodeRequest: qrCodeRequest));
      }
    });
  }

//  loadProgressFalseCase201() {
//    setState(() {
//      FalseCaseFlag = "true";
//      buttonvisibleSkip_ = false;
//      resultText_status_ = false;
//      true_status_ = false;
//      false_status_ = false;
//      ORCodeVisibilty_ = false;
//      mButtonVisibility_ = true;
//      mTextVisibility_ = false;
//      skiptest_ = false;
//      isResendEnabled_ = false;
//      mTextStatus_.text = Utils.Testfailed;
//      PreferenceUtils.setString(Utils.ScreenDamageSatatus, "false");
//      if (PreferenceUtils.getString(Utils.USER_ID) != null) {
//        var userId = int.parse(PreferenceUtils.getString(Utils.USER_ID));
//        var qrCodeRequest = QRCodeRequest(userId: userId);
//        _bloc.add(QRCodeEvent(qrCodeRequest: qrCodeRequest));
//      }
//    });
//  }

  mResultNotFound() {
    setState(() {
      FalseCaseFlag = "true";
      buttonvisibleSkip_ = true;
      mButtonVisibility_ = false;
      skiptest_ = false;
      textVisibilityNotUploadAnything_ = true;
      resultText_status_ = false;
      true_status_ = false;
      false_status_ = false;
      ORCodeVisibilty_ = false;
      mTextVisibility_ = false;
      isResendEnabled_ = false;
      PreferenceUtils.setString(Utils.ScreenDamageSatatus, "false");
      if (PreferenceUtils.getString(Utils.USER_ID) != null) {
        var userId = int.parse(PreferenceUtils.getString(Utils.USER_ID));
        var qrCodeRequest = QRCodeRequest(userId: userId);
        _bloc.add(QRCodeEvent(qrCodeRequest: qrCodeRequest));
      }
    });
  }

  mResultInprocess() {
    setState(() {
      inprocessText_ = true;
      buttonvisibleCheckStatus_ = true;
      buttonvisibleSkip_ = false;
      mButtonVisibility_ = false;
      mButtonVisibility_ = false;
      resultText_status_ = false;
      true_status_ = false;
      false_status_ = false;
      ORCodeVisibilty_ = false;
      mTextVisibility_ = false;
      skiptest_ = false;
      isResendEnabled_ = false;
      textVisibilityNotUploadAnything_ = false;
    });
  }

  void mWeightsVisibilty() {
    mTextVisibility_ = true;
    mButtonVisibility_ = false;
    ORCodeVisibilty_ = false;
    isResendEnabled_ = false;
    true_status_ = false;
    false_status_ = false;
    resultText_status_ = false;
    mimeitestStatus_ = false;
    mStatusInfo = false;
    skiptest_ = false;
    buttonvisibleSkip_ = false;
    inprocessText_ = false;
    buttonvisibleCheckStatus_ = false;
    textVisibilityNotUploadAnything_ = false;
  }

  void mWeightsVisibiltyForonResume() {
    mTextVisibility_ = false;
    mButtonVisibility_ = false;
    ORCodeVisibilty_ = false;
    isResendEnabled_ = false;
    true_status_ = false;
    false_status_ = false;
    resultText_status_ = false;
    mimeitestStatus_ = false;
    mStatusInfo = false;
    skiptest_ = false;
    buttonvisibleSkip_ = false;
    inprocessText_ = false;
    buttonvisibleCheckStatus_ = true;
    textVisibilityNotUploadAnything_ = false;
  }
}
