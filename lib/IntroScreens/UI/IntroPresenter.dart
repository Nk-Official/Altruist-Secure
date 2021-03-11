import 'dart:io';
import 'package:altruist_secure_flutter/SubScriptionWebPage/UI/subscriptionWePage.dart';
import 'package:altruist_secure_flutter/TestList/UI/TaskList.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/blocs/splash/bloc.dart';
import 'package:altruist_secure_flutter/ui/homeNewScreen/NewHomeDashboard.dart';
import 'package:altruist_secure_flutter/ui/registrationProcess/RegistrationProcess.dart';
import 'package:altruist_secure_flutter/utils/HashCalculator.dart';
import 'package:altruist_secure_flutter/utils/StringConstants.dart';
import 'package:altruist_secure_flutter/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/apis/apis.dart';
import 'package:altruist_secure_flutter/models/requests/register/RegisterRequestModel.dart';
import 'package:altruist_secure_flutter/ui/EnterOtpProcess/EnterOtpProcess.dart';
import 'package:intro_slider/slide_object.dart';

import 'IntroScreen.dart';

class IntroPresenter extends StatefulWidget {
  @override
  _IntroPresenterState createState() => _IntroPresenterState();
}

class _IntroPresenterState extends State<IntroPresenter> {
  _IntroPresenterState();

  SplashBlocBloc _bloc;
  TextEditingController _nameTextController;
  List<Slide> slides = new List();
  final _formKey = GlobalKey<FormState>();
  bool mSponserText;

  @override
  void initState() {
    PreferenceUtils.init();
    super.initState();
    _bloc = SplashBlocBloc(apisRepository: ApisRepository());
    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      mSponserText = false;
      slides.add(
        new Slide(
          title: "Secure your Mobile Phone",
          styleTitle: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans-SemiBoldItalic'),
          description:
              //todo country wise//////
              "Share your mobile phone purchase details and secure it from any Screen damage.",
          //  "Share your mobile phone purchase details and secure it from any physical damage/water damage/theft.",
          styleDescription: TextStyle(
              color: Colors.black87,
              fontSize: 18.0,
              fontFamily: 'OpenSans-SemiBoldItalic'),
          pathImage: "assets/moble_secure.jpg",
        ),
      );
    }
    else if(PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.altruists_secure_bangla" ||PreferenceUtils.getString(Utils.appPackageName) == "com.app.altruists-secure-bangla") {
      mSponserText = true;
      slides.add(
        new Slide(
          title: "Secure your Mobile Phone",
          styleTitle: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans-SemiBoldItalic'),
          description:
              //  "Share your mobile phone purchase details and secure it from any physical damage/water damage/theft.",
              "Share your mobile phone purchase details and secure it from any physical damage/liquid damage/theft/lost.",
          styleDescription: TextStyle(
              color: Colors.black87,
              fontSize: 18.0,
              fontFamily: 'OpenSans-SemiBoldItalic'),
          pathImage: "assets/moble_secure.jpg",
        ),
      );
      slides.add(
        new Slide(
          title: "Super-Simple claims",
          styleTitle: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans-SemiBoldItalic'),
          description:
              "Hasslefree claim process with free pickup & drop facilities",
          // "Cashless claim process with free pickup & drop facilities",
          styleDescription: TextStyle(
              color: Colors.black87,
              fontSize: 18.0,
              fontFamily: 'OpenSans-SemiBoldItalic'),
          pathImage: "assets/content_secure.jpg",
        ),
      );
      slides.add(
        new Slide(
          title: "Select a plan and make payment",
          styleTitle: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans-SemiBoldItalic'),
          description:
              "Choose a payment plan of your choice and make the payment",
          styleDescription: TextStyle(
              color: Colors.black87,
              fontSize: 18.0,
              fontFamily: 'OpenSans-SemiBoldItalic'),
          pathImage: "assets/plan_and_make_payment.jpg",
        ),
      );
    }
    else {
      mSponserText = true;
      slides.add(
        new Slide(
          title: "Secure your Mobile Phone",
          styleTitle: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans-SemiBoldItalic'),
          description:
              //  "Share your mobile phone purchase details and secure it from any physical damage/water damage/theft.",
              "Share your mobile phone purchase details and secure it from any physical damage/water damage.",
          styleDescription: TextStyle(
              color: Colors.black87,
              fontSize: 18.0,
              fontFamily: 'OpenSans-SemiBoldItalic'),
          pathImage: "assets/moble_secure.jpg",
        ),
      );
      slides.add(
        new Slide(
          title: "Super-Simple claims",
          styleTitle: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans-SemiBoldItalic'),
          description:
              "Hasslefree claim process with free pickup & drop facilities",
          // "Cashless claim process with free pickup & drop facilities",
          styleDescription: TextStyle(
              color: Colors.black87,
              fontSize: 18.0,
              fontFamily: 'OpenSans-SemiBoldItalic'),
          pathImage: "assets/content_secure.jpg",
        ),
      );
      slides.add(
        new Slide(
          title: "Select a plan and make payment",
          styleTitle: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans-SemiBoldItalic'),
          description:
              "Choose a payment plan of your choice and make the payment",
          styleDescription: TextStyle(
              color: Colors.black87,
              fontSize: 18.0,
              fontFamily: 'OpenSans-SemiBoldItalic'),
          pathImage: "assets/plan_and_make_payment.jpg",
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
//        bottomNavigationBar: BottomAppBar(
//          child: Visibility(
//            visible: mSponserText,
//            child: Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: _mPoweredWidget()
//            ),
//          ),
//        ),

        body: BlocListener(
          bloc: _bloc,
          listener: (BuildContext context, SplashBlocState state) {
            if (state is InitialOtpLoginProcessState) {
              if (state.isLoading == false && !state.isSuccess) {
                AppUtils.showSnackBar(context, state.message);
              } else if (state.isLoading == false && state.isSuccess) {
                if (state.transactionId != null &&
                    state.transactionId.isNotEmpty) {
                } else {
//                PreferenceUtils.setString(
//                    Utils.UserNumber, mobileCountryCode);
                  PreferenceUtils.setString(Utils.ISLOGIN, "true");
                  mToast(Utils.OtpVerficationToast);
                  _bloc.add(FetchCustomerInfoEvent());
                }
              }
            }
            if (state is InitialSplashBlocState) {
              print("Api  InitialSplashBlocState message called }");
              EventTracker.logEvent("SPLASH_EVENT");
              //   initPlatformStateForNavigate("ListTest");
              // initPlatformStateForNavigate("IMEICaptureScreen");
              print(
                  'User ISLOGIN  === ${PreferenceUtils.getString(Utils.ISLOGIN)}');
              if (PreferenceUtils.getString(Utils.ISLOGIN) != null &&
                  PreferenceUtils.getString(Utils.ISLOGIN) == "true") {
//                  try {
//                    if (splashApiHitCount == 0) {
//                      splashApiHitCount++;
////                        if (_fcmToken != null && _fcmToken.length > 0) {
//                      _bloc.add(UpdateSplashInfoEvent(
//                          fcmToken: _fcmToken, appVersion: _versionCode));
////                        }
//                    }
//                  } on Exception {
//                    mToast("Exception on Update Splash info");
//                    print("Exception on Update Splash info");
//                  }

                if (state.isLoading == false && !state.isSuccess) {
                  //  mToast("Api Fail");
                } else if (state.isLoading == false && state.isSuccess) {
                  print("User info Api message ${state.SatusCode}");
                  //    mToast("Api Success");
                  if (state.SatusCode != null && state.SatusCode == "401") {
                    PreferenceUtils.mClearPre();
                    Future.delayed(Duration(seconds: 1), () async {
                      initPlatformStateForNavigate("EnterOtpProcess");
                    });
                  } else {
                    Future.delayed(Duration(seconds: 1), () async {
                      if (state.isLoading == false && state.isSuccess) {
                        if (state.user != null) {
                          print("User Number ====  ${state.user.msisdn}");
                        }
                        if (state.deviceDetails == null ||
                            (state.deviceDetails.status != null &&
                                state.deviceDetails.status == "2")) {
                          if (state.deviceDetails == null ||
                              state.deviceDetails.status == "1") {
                            initPlatformStateForNavigate("RegistrationProcess");
                            return;
                          }

                          initPlatformStateForNavigateForRegistration(
                              state.deviceDetails.customerFirstName,
                              state.deviceDetails.customerLastName,
                              state.user.msisdn,
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
                      } else {}
                    });
                  }
                }
              } else {
                //mToast('Prefrence is null ');
                initPlatformStateForNavigate("IntroScreen");
              }
            }
          },
          child: BlocBuilder(
            bloc: _bloc,
            builder: (context, SplashBlocState state) {
              return ModalProgressHUD(
                color: Colors.black,
                inAsyncCall: false,
                child: IntroScreen(
                  key: _formKey,
                  slideList: slides,
                  listWid: renderListCustomTabs(),
                  onDoneClick: () {
                    onDonePress();
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

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = new List();
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                  child: Image.asset(
                currentSlide.pathImage,
                width: 360.0,
                height: 360.0,
                fit: BoxFit.contain,
              )),
              Container(
                child: Text(
                  currentSlide.title,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
              Container(
                child: Text(
                  currentSlide.description,
                  style: currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),

              SizedBox(height: 20,),
              Visibility(
                visible: mSponserText,
                  child: Container(
                child: _mPoweredWidget(),
                margin: EdgeInsets.only(top: 5.0),
              )),
            ],
          ),
        ),
      ));
    }
    return tabs;
  }




  Widget _mPoweredWidget() {
    if (PreferenceUtils.getString(Utils.appPackageName) == "com.insurance.atpl.altruist_secure_flutter" || PreferenceUtils.getString(Utils.appPackageName) == "com.insurance.altruistSecureFlutter"){
      return Container(
        height: 35,
        width: double.infinity,
        child: Image.asset(
          'powered_by_image.png',
        ),
      );
    }else{
      return Container(
      );
    }

  }





  void onDonePress() {
    EventTracker.logEvent("INTRO_DONE_CLICKED");
    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      initPlatformStateForNavigate("EnterOtpProcess");
      return;
    }
    if (PreferenceUtils.getString(Utils.TECCODE) != null &&
        PreferenceUtils.getString(Utils.TECCODE) != "") {
      var mobileNumber = PreferenceUtils.getString(Utils.MSISDN);
      var mobileCountryCode = PreferenceUtils.getString(Utils.COUNTRY_ID);
      var source = StringConstants.SOURCE;
      var operatorCode = PreferenceUtils.getString(Utils.OPERATORCODE);
      var transactionId = DateTime.now().millisecondsSinceEpoch.toString();
      print("transactionid $transactionId");
      var hashToken = HashCalculator.hashCompose(mobileNumber +
          "|" +
          transactionId +
          "|" +
          source +
          "|" +
          mobileCountryCode +
          "|" +
          operatorCode);

      var registerRequestModel = RegisterRequestModel(
          source: source,
          countryId: mobileCountryCode,
          msisdn: mobileNumber,
          operatorCode: operatorCode,
          transactionId: transactionId,
          hashToken: hashToken);
      _bloc.add(RegisterUserEvent(
          otp: "000000", registerRequestModel: registerRequestModel));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => EnterOtpProcess(),
              settings: RouteSettings(name: 'OtpEnterScreen')));
    }
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
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                // builder: (context) => NewHomeDashBoard(""),
                builder: (context) => Subscription(),
                settings: RouteSettings(name: 'Subscription')));
      }

      if (mScreeName.trim() == "ListTest") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ListTest(),
                settings: RouteSettings(name: 'ListTest')));
      }

      if (mScreeName.trim() == "IntroScreen") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => IntroPresenter(),
                settings: RouteSettings(name: 'IntroScreen')));
      }

      if (mScreeName.trim() == "EnterOtpProcess") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => EnterOtpProcess(),
                settings: RouteSettings(name: 'EnterOtpProcess')));
      }

//      if (mScreeName.trim() == "IMEICaptureScreen") {
//        Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(
//                builder: (context) => IMEICaptureScreen(),
//                settings: RouteSettings(name: 'IMEICaptureScreen')));
//      }
    });
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
}
