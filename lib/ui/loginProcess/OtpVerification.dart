import 'dart:async';
import 'dart:math';
import 'package:altruist_secure_flutter/CoupenPageScreen/VoucherScreenPresenter.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/apis/apis.dart';
import 'package:altruist_secure_flutter/blocs/login_process/bloc.dart';
import 'package:altruist_secure_flutter/blocs/login_process/otp_login_process_bloc.dart';
import 'package:altruist_secure_flutter/models/requests/register/RegisterRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/send_otp/SendOtpRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/verify_otp/VerifyOtpRequestModel.dart';
import 'package:altruist_secure_flutter/ui/EnterOtpProcess/EnterOtpProcess.dart';
import 'package:altruist_secure_flutter/ui/finalResultList/ResultListMain.dart';
import 'package:altruist_secure_flutter/ui/homeNewScreen/NewHomeDashboard.dart';
import 'package:altruist_secure_flutter/ui/loginProcess/OtpVerificationForm.dart';
import 'package:altruist_secure_flutter/ui/registrationProcess/RegistrationProcess.dart';
import 'package:altruist_secure_flutter/utils/HashCalculator.dart';
import 'package:altruist_secure_flutter/utils/StringConstants.dart';
import 'package:altruist_secure_flutter/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:altruist_secure_flutter/SubScriptionWebPage/UI/subscriptionWePage.dart';
import 'package:altruist_secure_flutter/TestList/UI/TaskList.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class OtpVerification extends StatefulWidget {
  String mNumber;
  String mCountryId;
  String number;

  OtpVerification(this.mNumber, this.mCountryId, this.number);

  @override
  _OtpVerificationState createState() =>
      _OtpVerificationState(mNumber, mCountryId, number);
}

class _OtpVerificationState extends State<OtpVerification> {
  OtpLoginProcessBloc _bloc;
  TextEditingController _otptextEditController;
  String mobileNumber;
  String mobileNumberSave;
  String selectedCountryId;
  String verificationId;
  String otpTransactionId;
  String Usernumber;
  AuthCredential phoneAuthCredential;
  bool isResendEnabled = false;
  bool mOptVerifybuttonVisible = false;
  bool isOtpVerifyEnabled = false;
  Timer _timer;
  int start = 5;
  FirebaseAuth auth;

  _OtpVerificationState(String mNumber, String countryId, String number) {
    mobileNumber = mNumber;
    selectedCountryId = countryId;
    Usernumber = number;
    print(mobileNumber);
  }

  @override
  void initState() {
    PreferenceUtils.init();
    super.initState();
    auth = FirebaseAuth.instance;
    _bloc = OtpLoginProcessBloc(apisRepository: ApisRepository());
    _otptextEditController = TextEditingController();
    var mobile;
    if (Platform.isAndroid) {
      // Android-specific code

      Future.delayed(Duration(milliseconds: 1000), () {
        if (mobileNumber != null) {
          var code = PreferenceUtils.getString(Utils.COUNTRY_ID);
          //   print('User number on first ${mobile = Usernumber[0]}');
          //  print('User number on second ${mobile = Usernumber[1]}');

          mobile = Usernumber[0] + Usernumber[1];
          // print('User number for Otp  ${mobile}');
          if (mobile == "11") {
            hitResendApi();
            setState(() {
              isOtpVerifyEnabled = true;
            });
          } else {
            // _submitPhoneNumber("+" + mobileNumber);
            if (PreferenceUtils.getString(Utils.appPackageName) == "com.app.mansardecure_secure") {
              _submitPhoneNumber("+" + mobileNumber);
            }else{
              hitResendApi();
            }

          }
          //print('PreferenceUtils.getString(Utils.COUNTRY_ID) ==== $code');

        }
      });
     //startTimer();

      setState(() {
        isResendEnabled = true;
        isOtpVerifyEnabled = true;
      });
    } else if (Platform.isIOS) {
      // iOS-specific code
      hitResendApi();
      setState(() {
        isResendEnabled = false;
        isOtpVerifyEnabled = true;
      });
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (start < 2) {
            isResendEnabled = true;
            timer.cancel();
            start = 5;
          } else {
//            isResendEnabled = false;
            start = start - 1;
          }
        },
      ),
    );
  }

  void hitResendApi() {
    EventTracker.logEvent("ON_RESEND_OTP_CLICKED");
    try {
      verificationId = null;
    } catch (e) {
      print(e);
    }
    var sendOtpRequestModel = SendOtpRequestModel(
        msisdn: mobileNumber,
        operatorCode: PreferenceUtils.getString(Utils.OPERATORCODE),
        countryId: PreferenceUtils.getString(Utils.COUNTRY_ID).toString(),
        source: StringConstants.SOURCE);
    _bloc.add(SendOtpEvent(sendOtpRequestModel: sendOtpRequestModel));
//                  }
  }

  Future<bool> onBackPressed() {
    return GestureDetector(
          onTap: () => Navigator.of(context).pop(false),
        ) ??
        false;
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomPadding: false,
      body: BlocListener(
        bloc: _bloc,
        listener: (BuildContext context, OtpLoginProcessState state) {
          if (state is InitialOtpLoginProcessState) {
            if (state.isLoading == false && !state.isSuccess) {
              setState(() {
                isOtpVerifyEnabled = true;
              });
              AppUtils.showSnackBar(context, state.message);
            } else if (state.isLoading == false && state.isSuccess) {
              setState(() {
                isOtpVerifyEnabled = true;
              });
              if (state.transactionId != null &&
                  state.transactionId.isNotEmpty) {
                otpTransactionId = state.transactionId;
                start = 5;
              //  startTimer();
              } else {
                mobileNumberSave = mobileNumber;
                PreferenceUtils.setString(Utils.UserNumber, mobileNumberSave);
                PreferenceUtils.setString(Utils.ISLOGIN, "true");
                mToast(Utils.OtpVerficationToast);
                _bloc.add(FetchCustomerInfoEvent());
              }
            }
          }
          if (state is InitialUserLoginlocState) {
            if (state.isLoading == false && !state.isSuccess) {
              AppUtils.showSnackBar(context, state.message);
            } else if (state.isLoading == false && state.isSuccess) {
//                  AppUtils.showSnackBar(context, state.message);
              Future.delayed(Duration(seconds: 1), () async {
                if (state.isLoading == false && state.isSuccess) {
                  EventTracker.logEvent("ON_OTP_VERIFICATION_DONE");

                  if (state.deviceDetails == null || (state.deviceDetails.status != null &&
                          state.deviceDetails.status == "2")) {
                    if (state.deviceDetails == null ||  state.deviceDetails.status == "1" ) {
                      initPlatformStateForNavigate("RegistrationProcess");
                      return;
                    }
                    initPlatformStateForNavigateForRegistration(
                        state.deviceDetails.customerFirstName,
                        state.deviceDetails.customerLastName,
                        state.deviceDetails.mobileNumber,
                        state.deviceDetails.email);
                    return;
                  }
                  if (state.subscriptions == null) {
                    if (state.deviceDiagnosResults == null) {
                      initPlatformStateForNavigate("ListTest");
                      return;
                    }
                    if (state.deviceDiagnosResults[0].status == 2) {
                      initPlatformStateForNavigate("ListTest");
                      return;
                    }
                    initPlatformStateForNavigate("Subscription");
                    return;
                  }
                  initPlatformStateForNavigate("HomeDashBoard");
                  return;
//                  if (state.subscriptions != null &&
//                      state.subscriptions.length > 0) {
//                    var statusSubscription = state.subscriptions[0].status;
//                    //   mToast('statusSubscription === $statusSubscription');
//                    if (statusSubscription.toString() == "1") {
//                      Navigator.pushReplacement(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) => NewHomeDashBoard(""),
//                              settings: RouteSettings(name: 'HomeDashBoard')));
//                    }
//                  }
//                  else {
//                    if (state.deviceDiagnosResults != null &&
//                        state.deviceDiagnosResults.length > 0) {
//                      var diagnoseStatus = state.deviceDiagnosResults[0].status;
//                      print('diagnoseStatus Result  $diagnoseStatus');
//                      if (diagnoseStatus.trim() == "1") {
//                        Navigator.pushReplacement(
//                            context,
//                            MaterialPageRoute(
////                                  builder: (context) => Registration(),
//                                builder: (context) => RegistrationProcess("","","",""),
//                                settings: RouteSettings(
//                                    name: 'RegistrationProcess')));
//                      } else if (diagnoseStatus.trim() == "0") {
//                        Navigator.pushReplacement(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) => Subscription(),
//                                settings: RouteSettings(name: 'Subscription')));
//                      } else {
//                        Navigator.pushReplacement(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) => ListTest(),
//                                settings: RouteSettings(name: 'ListTest')));
//                      }
//                    } else {
//                      if (state.deviceDetails != null || (state.deviceDetails.status!=null && state.deviceDetails.status == "2") ) {
//                        Navigator.pushReplacement(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) => ListTest(),
//                                settings: RouteSettings(name: 'ListTest')
////                                builder: (context) => Registration(),
//                                ));
//                      } else {
//                        if(state.deviceDetails.status == "2"){
//                          Navigator.pushReplacement(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => RegistrationProcess(state.deviceDetails.customerFirstName,state.deviceDetails.customerLastName,state.deviceDetails.mobileNumber,state.deviceDetails.email),
//                                  settings:
//                                  RouteSettings(name: 'RegistrationProcess')
////                                builder: (context) => Registration(),
//                              ));
//                        }
//
//                      }
//                    }
//                  }
                } else {
                  mToast('Check your Internet Connection and try again');
                }
              });
            }
          }
        },
        child: BlocBuilder(
          bloc: _bloc,
          builder: (context, OtpLoginProcessState state) {
            return ModalProgressHUD(
              color: Colors.black,
              inAsyncCall: state is InitialOtpLoginProcessState &&
                      state.isLoading != null
                  ? state.isLoading
                  : false,
              child: OtpVerificationForm(
                  mobileNumber: "+" + mobileNumber,
                  onChangeNumberClick: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EnterOtpProcess(),
                            settings: RouteSettings(name: 'OtpEnterScreen')));
                  },
                  onBackPress: () {
                    onBackPressed();
                  },
                  onRegisterClick: () {
                    EventTracker.logEvent("ON_VERIFY_OTP_CLICK");
                    if (Platform.isAndroid) {
                      // Android-specific code
                      if (_otptextEditController != null) {
                        if (_otptextEditController.text.toString().length < 6) {
                          mToast("Please enter otp first");
                        } else {
                          setState(() {
                            isOtpVerifyEnabled = false;
                          });
                          if (verificationId != null &&
                              verificationId.isNotEmpty) {
                            print(" verificationId  ===  $verificationId");

                            _submitOTP(_otptextEditController.text.toString());
                          } else {
                            var verifyOtpRequestModel = VerifyOtpRequestModel(
                                msisdn: mobileNumber,
                                countryId:
                                    PreferenceUtils.getString(Utils.COUNTRY_ID)
                                        .toString(),
                                otp: _otptextEditController.text.toString(),
                                operatorCode: PreferenceUtils.getString(Utils.OPERATORCODE) ,
                                transactionId: otpTransactionId,
                                source: StringConstants.SOURCE);
                            _bloc.add(VerifyOtpEvent(
                                otp: _otptextEditController.text.toString(),
                                verifyOtpRequestModel: verifyOtpRequestModel));
                          }
                        }
                      }
                    } else {
                      // iOS-specific code
                      if (_otptextEditController.text.toString().length < 6) {
                        mToast(
                            "Pleasae enter full OTP and OTP should be 6 digits");
                      } else {
                        print("Verify OTP iOS side called");
                        var verifyOtpRequestModel = VerifyOtpRequestModel(
                            msisdn: mobileNumber,
                            countryId:
                                PreferenceUtils.getString(Utils.COUNTRY_ID)
                                    .toString(),
                            otp: _otptextEditController.text.toString(),
                            operatorCode: PreferenceUtils.getString(Utils.OPERATORCODE) ,
                            transactionId: otpTransactionId,
                            source: StringConstants.SOURCE);
                        _bloc.add(VerifyOtpEvent(
                            otp: _otptextEditController.text.toString(),
                            verifyOtpRequestModel: verifyOtpRequestModel));
                      }
//                      else if (_otptextEditController.text.toString() !=
//                          "123456") {
//                        mToast("OTP is incorrect");
//                      } else {
//                        _submitOTPForIOS(
//                            _otptextEditController.text.toString());
//                      }
                    }
                  },
                  onResendClick: () {
//                  if (verificationId != null && verificationId.isNotEmpty) {
//                    if (mobileNumber != null) {
//                      _submitPhoneNumber("+" + mobileNumber);
//                    }
//                  } else {

                    setState(() {
                      mOptVerifybuttonVisible = true;
                    });
                    hitResendApi();
//                    EventTracker.logEvent("ON_RESEND_OTP_CLICKED");
//                    try {
//                      verificationId = null;
//                    } catch (e) {
//                      print(e);
//                    }
//                    var sendOtpRequestModel = SendOtpRequestModel(
//                        msisdn: mobileNumber,
//                        operatorCode: "0",
//                        countryId: PreferenceUtils.getString(Utils.COUNTRY_ID)
//                            .toString(),
//                        source: StringConstants.SOURCE);
//                    _bloc.add(
//                        SendOtpEvent(sendOtpRequestModel: sendOtpRequestModel));
////                  }
                  },
                  otpTextController: _otptextEditController,
                  isResendEnabled: isResendEnabled,
                  isOtpVerifyEnabled: isOtpVerifyEnabled,
                  counterVal: start,
                  mOptVerifybuttonVisible: mOptVerifybuttonVisible),
            );
          },
        ),
    ));
  }

  Future<void> initPlatformStateForNavigateForRegistration(String firstName,
      String lastName, String mobileNumber, String email) async {
    Future.delayed(Duration(seconds: 2), () async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                RegistrationProcess(firstName, lastName, mobileNumber, email),
            settings: RouteSettings(name: 'RegistrationProcess')),
      );
    });
  }

  Future<void> initPlatformStateForNavigate(String mScreeName) async {
    print('Redirect Screen Name is $mScreeName');
    Future.delayed(Duration(seconds: 2), () async {
      if (mScreeName.trim() == "HomeDashBoard") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NewHomeDashBoard(""),
              settings: RouteSettings(name: 'NewHomeDashBoard')),
        );
      }
      if (mScreeName.trim() == "RegistrationProcess") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => RegistrationProcess("", "", "", ""),
              settings: RouteSettings(name: 'RegistrationProcess')),
        );
      }

      if (mScreeName.trim() == "Subscription") {
        if (PreferenceUtils.getString(Utils.appPackageName) ==
            "com.app.mansardecure_secure") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => VoucherScreenPresenter(),
                  settings: RouteSettings(name: 'VoucherScreenPresenter')));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                // builder: (context) => NewHomeDashBoard(""),
                  builder: (context) => Subscription(),
                  settings: RouteSettings(name: 'Subscription')));
        }
      }

      if (mScreeName.trim() == "ListTest") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ListTest(),
                settings: RouteSettings(name: 'ListTest')));
      }
    });
  }

  Future<void> _submitPhoneNumber(mMobileNumber) async {
    String phoneNumber = mMobileNumber;
    print(phoneNumber);

    /// The below functions are the callbacks, separated so as to make code more redable
    void verificationCompleted(AuthCredential phoneAuthCredential) {
      print('verificationCompleted');
      this.phoneAuthCredential = phoneAuthCredential;
      print(phoneAuthCredential);
      setState(() {
        isResendEnabled = true;
        isOtpVerifyEnabled = true;
      });
    }

    void verificationFailed(AuthException error) {
      print(error);
      setState(() {
        isResendEnabled = true;
        if (_timer != null) _timer.cancel();
        start = 5;
      });
      mToast("Something went wrong. Please try again with resend OTP options.");

//      mToast("Something went wrong. Please check your number and try again.");
    }

    void codeSent(String verificationId, [int code]) {
      this.verificationId = verificationId;
      PreferenceUtils.setString(Utils.VerificationId, verificationId);
      setState(() {
        isOtpVerifyEnabled = true;
      });
      mToast("OTP Sent");
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      this.verificationId = verificationId;
      print('codeAutoRetrievalTimeout');
    }

    auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(milliseconds: 10000),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); // All the callbacks are above
  }

//  Future<void> _submitPhoneNumber(mMobileNumber) async {
//    //FirebaseAuth _auth = FirebaseAuth.instance;
//  //  await Firebase.initializeApp();
//    String phoneNumber = mMobileNumber;
//
//    print("Phone Number for otp ====== ${phoneNumber}");
//    /// The below functions are the callbacks, separated so as to make code more redable
//
//
//    void verificationCompleted(AuthCredential phoneAuthCredential) {
//      print('verificationCompleted');
//      this.phoneAuthCredential = phoneAuthCredential;
//      print(phoneAuthCredential);
//      setState(() {
//        isResendEnabled = true;
//        isOtpVerifyEnabled = true;
//      });
//    }
//
//    void verificationFailed(AuthException error) {
//      print("verificationFailed code  =====   ${error.code}");
//      print("verificationFailed message  =====   ${error.message}");
//      setState(() {
//        isResendEnabled = true;
//        if (_timer != null) _timer.cancel();
//        start = 45;
//      });
//      mToast("Something went wrong. Please try again with resend OTP options.");
//
//    }
//
//    void codeSent(String verificationId, [int code]) {
//      this.verificationId = verificationId;
//      PreferenceUtils.setString(Utils.VerificationId, verificationId);
//      setState(() {
//        isOtpVerifyEnabled = true;
//      });
//      mToast("OTP Sent");
//    }
//
//    void codeAutoRetrievalTimeout(String verificationId) {
//      this.verificationId = verificationId;
//      print('codeAutoRetrievalTimeout');
//    }
//
//    FireBase.verifyPhoneNumber(
//      phoneNumber: phoneNumber,
//      timeout: Duration(seconds: 60),
//      verificationCompleted: verificationCompleted,
//      verificationFailed: verificationFailed,
//      codeSent: codeSent,
//      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
//    ); // All the callbacks are above
//
//  }

  void _submitOTP(smsCode) {
    String smsCode_ = smsCode;
    print(smsCode_);
    this.phoneAuthCredential = PhoneAuthProvider.getCredential(
        verificationId: this.verificationId, smsCode: smsCode_);
    _OtpVerification(smsCode);
  }

//
//  Future<void> _OtpVerification(smsCode) async {
//    /// This method is used to login the user
//    /// `AuthCredential`(`phoneAuthCredential`) is needed for the signIn method
//    /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
//    try {
//      await FirebaseAuth.instance
//          .signInWithCredential(this.phoneAuthCredential)
//          .then((AuthResult authRes) {
//        var _firebaseUser = authRes.user;
//        try {
//          if (_firebaseUser != null) {
//            var source = StringConstants.SOURCE;
//            var countryId = selectedCountryId;
//            var operatorCode = "0";
//            var transactionId =
//                DateTime.now().millisecondsSinceEpoch.toString();
//            print("transactionid $transactionId");
//            var hashToken = HashCalculator.hashCompose(mobileNumber +
//                "|" +
//                transactionId +
//                "|" +
//                source +
//                "|" +
//                PreferenceUtils.getString(Utils.COUNTRY_ID).toString() +
//                "|" +
//                operatorCode);
//
//            var registerRequestModel = RegisterRequestModel(
//                source: source,
//                countryId:
//                    PreferenceUtils.getString(Utils.COUNTRY_ID).toString(),
//                msisdn: mobileNumber,
//                operatorCode: operatorCode,
//                transactionId: transactionId,
//                hashToken: hashToken);
//            _bloc.add(RegisterUserEvent(
//                otp: smsCode, registerRequestModel: registerRequestModel));
//          }
//        } catch (e) {
//          setState(() {
//            isOtpVerifyEnabled = true;
//          });
//          print(" FirebaseAuth Exception === ${e.toString()}");
//          // mToast(e.toString());
//        }
//
////        print(_firebaseUser.toString());
////        mToast(_firebaseUser.toString());
////        mToast(_firebaseUser.metadata.toString());
//      });
//    } catch (e) {
//      setState(() {
//        isOtpVerifyEnabled = true;
//      });
//      if (e.toString().contains("ERROR_INVALID_VERIFICATION_CODE")) {
//        mToast(Utils.WrongPassword);
//      } else if (e.toString().contains("ERROR_SESSION_EXPIRED")) {
//        mToast(Utils.SessionExpired);
//      } else {
//        mToast(e.toString());
//      }
//
//      print(e.toString());
//    }
//  }

  Future<void> _OtpVerification(smsCode) async {
    /// This method is used to login the user
    /// `AuthCredential`(`phoneAuthCredential`) is needed for the signIn method
    /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
    try {
      await FirebaseAuth.instance
          .signInWithCredential(this.phoneAuthCredential)
          .then((AuthResult authRes) {
        var _firebaseUser = authRes.user;
        try {
          if (_firebaseUser != null) {
            var source = StringConstants.SOURCE;
            var countryId = selectedCountryId;
            var operatorCode = "0";
            var transactionId =
                DateTime.now().millisecondsSinceEpoch.toString();
            print("transactionid $transactionId");
            var hashToken = HashCalculator.hashCompose(mobileNumber +
                "|" +
                transactionId +
                "|" +
                source +
                "|" +
                PreferenceUtils.getString(Utils.COUNTRY_ID).toString() +
                "|" +
                operatorCode);

            var registerRequestModel = RegisterRequestModel(
                source: source,
                countryId: PreferenceUtils.getString(Utils.COUNTRY_ID).toString(),
                msisdn: mobileNumber,
                operatorCode: operatorCode,
                transactionId: transactionId,
                hashToken: hashToken);
            _bloc.add(RegisterUserEvent(
                otp: smsCode, registerRequestModel: registerRequestModel));
          }
        } catch (e) {
          setState(() {
            isOtpVerifyEnabled = true;
          });
          print(e.toString());
          // mToast(e.toString());
        }

//        print(_firebaseUser.toString());
//        mToast(_firebaseUser.toString());
//        mToast(_firebaseUser.metadata.toString());
      });
    } catch (e) {
      setState(() {
        isOtpVerifyEnabled = true;
      });
      if (e.toString().contains("ERROR_INVALID_VERIFICATION_CODE")) {
        mToast(Utils.WrongPassword);
      } else if (e.toString().contains("ERROR_SESSION_EXPIRED")) {
        mToast(Utils.SessionExpired);
      } else {
        mToast(e.toString());
      }

      print(e.toString());
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        break;
      default:
        break;
    }
  }

  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

  void mIntent() {
    print(PreferenceUtils.getString(Utils.VerificationId));
  }

//
//  void _submitOTPForIOS(smsCode) {
//    String smsCode_ = smsCode;
//    print(smsCode_);
////    this.phoneAuthCredential = PhoneAuthProvider.getCredential(
////        verificationId: this.verificationId, smsCode: smsCode_);
//    _OtpVerificationForIOS(smsCode);
//  }
//
//  Future<void> _OtpVerificationForIOS(smsCode) async {
//    /// This method is used to login the user
//    /// `AuthCredential`(`phoneAuthCredential`) is needed for the signIn method
//    /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
//    try {
//      try {
//        if (smsCode != null) {
//          var source = StringConstants.SOURCE;
//          var countryId = selectedCountryId;
//          var operatorCode = "0";
//          var transactionId = DateTime.now().millisecondsSinceEpoch.toString();
//          print("transactionid $transactionId");
//          var hashToken = HashCalculator.hashCompose(mobileNumber +
//              "|" +
//              transactionId +
//              "|" +
//              source +
//              "|" +
//              PreferenceUtils.getString(Utils.COUNTRY_ID).toString() +
//              "|" +
//              operatorCode);
//
//          var registerRequestModel = RegisterRequestModel(
//              source: source,
//              countryId: PreferenceUtils.getString(Utils.COUNTRY_ID).toString(),
//              msisdn: mobileNumber,
//              operatorCode: operatorCode,
//              transactionId: transactionId,
//              hashToken: hashToken);
//          _bloc.add(RegisterUserEvent(
//              otp: smsCode, registerRequestModel: registerRequestModel));
//        }
//      } catch (e) {
//        setState(() {
//          isOtpVerifyEnabled = true;
//        });
//        print(e.toString());
//        mToast(e.toString());
//      }
//    } catch (e) {
//      setState(() {
//        isOtpVerifyEnabled = true;
//      });
//      mToast(e.toString());
//      print(e.toString());
//    }
//  }

}
