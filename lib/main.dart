import 'dart:io';
import 'package:altruist_secure_flutter/MainClass/mainPresenterClass.dart';
import 'package:altruist_secure_flutter/TestList/UI/TaskList.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/ui/ApproveImageScreen/aproveImageScreen.dart';
import 'package:altruist_secure_flutter/ui/EnterOtpProcess/EnterOtpProcess.dart';
import 'package:altruist_secure_flutter/ui/homeNewScreen/NewHomeDashboard.dart';
import 'package:altruist_secure_flutter/utils/StringConstants.dart';
import 'package:altruist_secure_flutter/utils/app_utils.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'CoupenPageScreen/VoucherScreenPresenter.dart';
import 'IntroScreens/UI/IntroPresenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:async';
import 'RegistrationForm/UI/Registration.dart';
import 'apis/apis.dart';
import 'blocs/splash/splash_bloc_bloc.dart';
import 'blocs/splash/splash_bloc_event.dart';
import 'package:altruist_secure_flutter/SubScriptionWebPage/UI/subscriptionWePage.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:altruist_secure_flutter/ui/registrationProcess/RegistrationProcess.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:sim_info/sim_info.dart';
import 'package:connectivity/connectivity.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'blocs/splash/splash_bloc_state.dart';
import 'package:toast/toast.dart';

void main() {
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.

  Crashlytics.instance.enableInDevMode = true;
  // Pass all uncaught errors to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
//  PreferenceUtils.init();
  runApp(MyApp());

  // runApp(HomeDashBoardForm());

//  runZoned(() {
//    runApp(MyApp());
//  }, onError: Crashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyAppSplash()); // define it once at root level.
  }
}

class MyAppSplash extends StatefulWidget {
  @override
  _MyAppSplashState createState() => _MyAppSplashState();
}

class _MyAppSplashState extends State<MyAppSplash> {
  SplashBlocBloc _bloc;
  String uniqueId = "Unknown";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _versionCode = "";
  int splashApiHitCount = 0;
  static const platform =
      const MethodChannel('samples.flutter.dev/battery/vibration_test');
  String packageName;
  String appName;
  int result;
  bool SimState;
  var UrlHe;
  String mobileCountryCode;
  AlertDialog alert;
  bool isLoadingProgress = false;

  @override
  void initState() {
    super.initState();
    PreferenceUtils.init();
    print("============Start===========");
    _initPackageInfo();
    _bloc = SplashBlocBloc(apisRepository: ApisRepository());
    _userInfo();

//    //   PreferenceUtils.getString(Utils.USER_ID)
//    try {
//// Required for notification enabling
////      _firebaseMessaging.requestNotificationPermissions(
////          const IosNotificationSettings(
////              sound: true, badge: true, alert: true, provisional: true));
////      _firebaseMessaging.onIosSettingsRegistered
////          .listen((IosNotificationSettings settings) {
////        print("Settings registered: $settings");
////      });
////      _firebaseMessaging.getToken().then((String token) {
////        assert(token != null);
////        setState(() {
////          _fcmToken = token;
////        });
////        print(_fcmToken);
////      });
//    } on Exception {
//      print("Exception in fetching firebase token");
//    }
  }

  Future<void> _userInfo() async {
    Future.delayed(Duration(seconds: 2), () async {
      print('User ID in starting === ${PreferenceUtils.getString(Utils.USER_ID)}');
      print(
          'User JWT_TOKEN  === ${PreferenceUtils.getString(Utils.JWT_TOKEN)}');
      print('User MobileID  === ${PreferenceUtils.getString(Utils.MobileID)}');
      WidgetsFlutterBinding.ensureInitialized();
      FlutterDownloader.initialize(debug: true);
      if (PreferenceUtils.getString(Utils.ISLOGIN) != null &&
          PreferenceUtils.getString(Utils.ISLOGIN) == "true") {
        print('Call api- fetch user status');
        _bloc.add(FetchCustomerInfoEvent());
      } else {
        print('Start intro pages');
        if (Platform.isAndroid) {
          cameraPermissionCheck();
        } else {
          getSimInfo();
        }
      }
      // FlutterDownloader.registerCallback(downloadCallback);
      getCountryCode();
      if (Platform.isAndroid) {
        print("Android");
        getDeviceinfo();
      } else {
        print("Ios");
        getIOSDeviceinfo();
      }
      //initPlatformState();
    });
  }

  checkInterNetType(String Url) async {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
      //mToast(errorMessage);
      print(errorMessage);
      showAlertDialog(context, "internet_required", Utils.appPackageName,
          errorMessage, Utils.Ok);
    } else {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        print("connectivityResult=========== Mobile data");
        if (Url != null && Url != "") {
          _bloc.add(CustomerHEUrlEvent(url: Url));
        } else {
          mToast("Something went wrong please in HE URL");
        }
      } else if (connectivityResult == ConnectivityResult.wifi) {
        print("connectivityResult=========== Wifi data");
//        if (Url != null && Url != "") {
//          _bloc.add(CustomerHEUrlEvent(url: Url));
//        } else {
//          mToast("Something went wrong please try again");
//        }
        showAlertDialog(
            context,
            "mobiledata",
            "",
            "Dear Customer, please use mobile data to avail the service.",
            Utils.Ok);
      }
    }
  }

  /////////// Sim Operator Info for HE/////////////////
  Future<void> getSimInfo() async {
    _getSimtest();

  }

  Future _unSuccessPop(String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {},
          child: Dialog(
            backgroundColor: Colors.white,
            insetAnimationDuration: const Duration(milliseconds: 100),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              // use container to change width and height
              height: 250,
              width: 200,
              child: Column(
                children: <Widget>[
                  FlatButton(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        message,
                        style: TextStyle(
                          color: ColorConstant.SponserTextColor,
                          fontFamily: 'OpenSans',
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _getSimtest() async {
    try {
      platform.setMethodCallHandler(_handleCallback);
      result = await platform.invokeMethod('sim_test');
      print(result);
      print("Sim State result ==  $result");
      mToast("Sim State result ==  $result");
      setState(() {
        Future.delayed(const Duration(seconds: 1), () {
          if (result == 5) {
            SimState = true;
          } else if (result == 1) {
            SimState = false;
          } else {
            SimState = false;
          }
        });
      });


      Future.delayed(const Duration(seconds: 2), () async {
        print("SimState ===  $SimState");
        if (SimState == true) {
          String allowsVOIP = await SimInfo.getAllowsVOIP;
          // String carrierName = await SimInfo.getCarrierName;
          String isoCountryCode = await SimInfo.getIsoCountryCode;
          mobileCountryCode = await SimInfo.getMobileCountryCode;
          String mobileNetworkCode = await SimInfo.getMobileNetworkCode;
          var operaterCode = mobileCountryCode + mobileNetworkCode;

          print("allowsVOIP ===  $allowsVOIP");
          print("isoCountryCode ===  $isoCountryCode");
          print("mobileCountryCode ===  $mobileCountryCode");
          print("mobileNetworkCode ===  $mobileNetworkCode");
          print("OperaterCode ===  {$operaterCode}");

          PreferenceUtils.setString(Utils.OPERATORCODE, operaterCode);

          mobileCountryCode = await getHECountryCode(isoCountryCode);

          PreferenceUtils.setString(Utils.COUNTRY_ID, mobileCountryCode);
          print("mobileCountryCode ===  $mobileCountryCode");

          if (packageName != null &&
              packageName == "com.app.mansardecure_secure" ||  packageName == "com.app.mansardecure-secure") {
            initPlatformStateForNavigate("IntroScreen");
          } else if (packageName ==
              "com.insurance.atpl.altruist_secure_flutter") {
            if (operaterCode == "62001") {
              var value = await AppUtils.checkInternetConectivity();
              print("internet Status  ======  $value");
              if (value == true) {
                _bloc.add(CustomerHERequestEvent(
                    heFlag: true,
                    mCountryCode: mobileCountryCode,
                    mCountryOperatorCode: operaterCode));
              } else {
                _unSuccessPop(Utils.wifiMessage);
              }
            } else {
              //  initPlatformStateForNavigate("ListTest");
              PreferenceUtils.mClearPre();
              _unSuccessPop(Utils.operatorCodeNotFound);
            }


          } else if(packageName == "com.app.altruists_secure_bangla" || packageName == "com.app.altruists-secure-bangla"){
            bool isNetworkAvailable = await AppUtils.isInternetAvailable();
            if(!isNetworkAvailable){
              mToast(Utils.internetRequiredTitle);
            }else{
              _bloc.add(CustomerHERequestEvent(
                  heFlag: true,
                  mCountryCode: mobileCountryCode,
                  mCountryOperatorCode: operaterCode));
            }


          }else {
            _bloc.add(CustomerHERequestEvent(
                heFlag: true,
                mCountryCode: mobileCountryCode,
                mCountryOperatorCode: operaterCode));
          }
        }
        else {
          _unSuccessPop(Utils.SimMessage);
        }
      });
    } on PlatformException catch (e) {}
  }

  Future<dynamic> _handleCallback(MethodCall call) async {
    switch (call.method) {
      case "message":
        print(call.arguments);
        setState(() {});
    }
  }

  Future<String> getHECountryCode(String SimCountryCode) async {
    print("SimCountryCode ===  $SimCountryCode");
    String countryCode = null;
    if (SimCountryCode == "in") {
      countryCode = "91";
    } else if (SimCountryCode == "ng") {
      countryCode = "234";
    } else if (SimCountryCode == "ke") {
      countryCode = "254";
    } else if (SimCountryCode == "gh") {
      countryCode = "233";
    } else if (SimCountryCode == "id") {
      countryCode = "62";
    } else if (SimCountryCode == "bd") {
      countryCode = "88";
    } else if (SimCountryCode == "ae") {
      countryCode = "971";
    } else if (SimCountryCode == "lk") {
      countryCode = "94";
    } else if (SimCountryCode == "om") {
      countryCode = "91";
    }
    return countryCode;
  }

  void getPermissionStatus() async {
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    if (permission == PermissionStatus.granted) {
      print("Camera Permission Granted");
      videoPermission();
    } // ideally you should specify another condition if permissions is denied
    else if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.restricted) {
      //   await PermissionHandler().requestPermissions([PermissionGroup.camera]);
      print(
          "Camera Permission disabled ${PermissionStatus.disabled.toString()}");
      print("Camera Permission granted ${PermissionStatus.granted.toString()}");
      print("Camera Permission denied ${PermissionStatus.denied.toString()}");
      print(
          "Camera Permission restricted ${PermissionStatus.restricted.toString()}");
      // getPermissionStatus();
      //showAlertDialogForPermission(context,"camera");
    }
  }

  void videoPermission() async {
    PermissionStatus permission_ =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.phone);
    if (permission_ == PermissionStatus.granted) {
      print("Video Permission Granted");
      Future.delayed(const Duration(seconds: 2), () {
        getSimInfo();
      });
    } // ideally you should specify another condition if permissions is denied
    else if (permission_ == PermissionStatus.disabled ||
        permission_ == PermissionStatus.restricted) {
      print("Video Permission Denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: <NavigatorObserver>[EventTracker.observer],
        home: Scaffold(
          body: BlocListener(
            bloc: _bloc,
            listener: (BuildContext context, SplashBlocState state) {
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
                              state.deviceDetails.status != null &&
                                  state.deviceDetails.status == "2") {
                            if (state.deviceDetails == null ||
                                state.deviceDetails.status == "1") {
                              initPlatformStateForNavigate(
                                  "RegistrationProcess");
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
                            if (state.deviceDiagnosResults == null ||
                                state.deviceDiagnosResults.isEmpty) {
                              initPlatformStateForNavigate("ListTest");
                              return;
                            }
                            if (state.deviceDiagnosResults != null &&
                                state.deviceDiagnosResults[0].status == 2) {
                              initPlatformStateForNavigate("ListTest");
                              return;
                            }

                            if (packageName ==
                                    "com.app.altruists_secure_bangla".trim() ||
                                packageName ==
                                    "com.app.altruists-secure-bangla".trim()) {
                              if (state.deviceDiagnosResults != null &&
                                  state.deviceDiagnosResults[0].status == "0") {
                                initPlatformStateForNavigate(
                                    "AproveImageScreen");
                                return;
                              }
                              initPlatformStateForNavigate("AproveImageScreen");
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

              /////// check he according to country/////////
              if (state is InitialHEStatusScreenState) {
                print("Api InitialHEStatusScreenState Called");
                print("Api state.isLoading ${state.isLoading}");
                print("Api heStatus ${state.heStatus}");
                print("Api isSuccess ${state.isSuccess}");
                EventTracker.logEvent("HE_EVENT");
                if (state.isLoading == false && !state.isSuccess) {
                } else if (state.isLoading == false && state.isSuccess) {
                  print("Api message ${state.heStatus}");
                  if (state.heStatus == true && state.url != null) {
                    UrlHe = state.url;
                    checkInterNetType(UrlHe);
                  } else {
                    if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "233") {
                      _showDialog();
                    } else {
                      initPlatformStateForNavigate("IntroScreen");
                    }
                    //
                  }
                }
              }

              //////// He Info////////////////
              if (state is InitialHEInfoScreenState) {
                print("Api InitialHEInfoScreenState Called");
                print("Api state.isLoading ${state.isLoading}");
                print("Api heInfoStatus ${state.heInfoResponse.toString()}");
                print("Api isSuccess ${state.isSuccess}");
                EventTracker.logEvent("HE_EVENT");
                if (state.isLoading == false && !state.isSuccess) {
                } else if (state.isLoading == false && state.isSuccess) {
                  print("Api message ${state.heInfoResponse.toString()}");
                }
              }

              //////// He  URL info////////////////
              if (state is InitialHEUrlcreenState) {
                print(
                    "Api heUrlResponseRe ${state.heUrlResponseRe.toString()}");
                if (state.isLoading == false && !state.isSuccess) {
                } else if (state.isLoading == false && state.isSuccess) {
                  PreferenceUtils.setString(
                      Utils.MSISDN, state.heUrlResponseRe.msisdn);
                  PreferenceUtils.setString(
                      Utils.IMEI, state.heUrlResponseRe.imei);
                  String techCode = state.heUrlResponseRe.imei.substring(0, 8);
                  print("Api heUrlResponseRe techCode ${techCode}");
                  print("He Mobile Number Lenth  ${state.heUrlResponseRe.msisdn.length}");
                  PreferenceUtils.setString(Utils.TECCODE, techCode);
                  PreferenceUtils.setString(Utils.MOBILE_NUMBER_LENTH,
                      state.heUrlResponseRe.msisdn.length.toString());
                  if (techCode != null) {
                    initPlatformStateForNavigate("IntroScreen");
                  } else {
                    mToast("Tech Code Not found");
                  }

//                  var mobileNumber = state.heUrlResponseRe.msisdn;
//                  var source = StringConstants.SOURCE;
//                  var operatorCode = PreferenceUtils.getString(Utils.OPERATORCODE);
//                  var transactionId =
//                      DateTime.now().millisecondsSinceEpoch.toString();
//                  print("transactionid $transactionId");
//                  var hashToken = HashCalculator.hashCompose(mobileNumber +
//                      "|" +
//                      transactionId +
//                      "|" +
//                      source +
//                      "|" +
//                      mobileCountryCode +
//                      "|" +
//                      operatorCode);
//
//                  var registerRequestModel = RegisterRequestModel(
//                      source: source,
//                      countryId: mobileCountryCode,
//                      msisdn: mobileNumber,
//                      operatorCode: operatorCode,
//                      transactionId: transactionId,
//                      hashToken: hashToken);
//                  _bloc.add(RegisterUserEvent(
//                      otp: "000000",
//                      registerRequestModel: registerRequestModel));
                }
              }

              if (state is InitialOtpLoginProcessState) {
                if (state.isLoading == false && !state.isSuccess) {
                  AppUtils.showSnackBar(context, state.message);
                } else if (state.isLoading == false && state.isSuccess) {
                  if (state.transactionId != null &&
                      state.transactionId.isNotEmpty) {
                  } else {
                    PreferenceUtils.setString(
                        Utils.UserNumber, mobileCountryCode);
                    PreferenceUtils.setString(Utils.ISLOGIN, "true");
                    mToast(Utils.OtpVerficationToast);
                    _bloc.add(FetchCustomerInfoEvent());
                  }
                }
              }
            },
            child: BlocBuilder(
              bloc: _bloc,
              builder: (context, SplashBlocState state) {
                if (state is InitialHEStatusScreenState) {
                  if (state.isLoading) {
                    isLoadingProgress = state.isLoading;
                  } else {
                    isLoadingProgress = false;
                  }
                } else if (state is InitialHEUrlcreenState) {
                  if (state.isLoading) {
                    isLoadingProgress = state.isLoading;
                  } else {
                    isLoadingProgress = false;
                  }
                } else if (state is InitialOtpLoginProcessState) {
                  if (state.isLoading) {
                    isLoadingProgress = state.isLoading;
                  } else {
                    isLoadingProgress = false;
                  }
                }
                return ModalProgressHUD(
                  color: Colors.black,
                  inAsyncCall: isLoadingProgress,
                  child: MainClass(),
                );
              },
            ),
          ),
        ));
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    appName = info.appName;
    packageName = info.packageName;
    PreferenceUtils.setString(Utils.appPackageName, packageName);
    setState(() {
      /// The build number. `CFBundleVersion` on iOS, `versionCode` on Android.
      _versionCode = info.buildNumber;
    });
    print(_versionCode);
  }

  showAlertDialog(BuildContext context, String type, String mTitle,
      String mDescription, String buttonText) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(buttonText),
      onPressed: () async {
        if (type == "internet_required") {
          bool isNetworkAvailable = await AppUtils.isInternetAvailable();
          String errorMessage = "";
          if (!isNetworkAvailable) {
            errorMessage = StringConstants.INTERNET_ERROR;
            //mToast(errorMessage);
            print(errorMessage);
            showAlertDialog(context, "internet_required", "Internet Required",
                "Please enable Internet", Utils.Ok);
            //  AppUtils.showAlertDialog(context,"internet_required",Utils.internetRequiredTitle,errorMessage,Utils.Ok);
          } else {
            checkInterNetType(UrlHe);
          }
        } else if (type == "mobiledata") {
          bool isNetworkAvailable = await AppUtils.isInternetAvailable();
          String errorMessage = "";
          if (!isNetworkAvailable) {
            errorMessage = StringConstants.INTERNET_ERROR;
            print(errorMessage);
            showAlertDialog(context, "mobiledata", Utils.appPackageName,
                errorMessage, Utils.Ok);
            //  AppUtils.showAlertDialog(context,"internet_required",Utils.internetRequiredTitle,errorMessage,Utils.Ok);
          } else {
            checkInterNetType(UrlHe);
          }
        }
      },
    );
    alert = AlertDialog(
      title: Text(mTitle),
      content: Text(mDescription),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(""),
          content: new Text(
              "Dear Customer, you are not eligible for this service. Only MTN user can use Altruist Secure Service."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                exit(0);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> initPlatformState() async {
    String platformImei;
    String idunique;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      idunique = await ImeiPlugin.getImei();
      print('idunique ====  $idunique');
    } on PlatformException {
      platformImei = 'Failed to get platform version.';
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    uniqueId = idunique;
  }

  Future<void> initPlatformStateForNavigate(String mScreeName) async {
    print('Redirect Screen Name is $mScreeName');
    Future.delayed(Duration(seconds: 1), () async {
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
//                //builder: (context) => VoucherScreenPresenter(),
//              //   builder: (context) => NewHomeDashBoard(""),
//               //  builder: (context) => RegistrationProcess("", "", "", ""),
//                 builder: (context) =>  ResultListMain(),
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
      if (mScreeName.trim() == "AproveImageScreen") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AproveImageScreen(),
                settings: RouteSettings(name: 'AproveImageScreen')));
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
    Future.delayed(Duration(seconds: 1), () async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                RegistrationProcess(firstName, lastName, mobileNumber, email),
            settings: RouteSettings(name: 'RegistrationProcess')),
      );
    });
  }

  void mToast(String message) {
    Toast.show(message, context, duration: 2, gravity: Toast.CENTER);
  }

  void getDeviceinfo() async {
    print("Funcation - getDeviceinfo");
    if (Platform.isAndroid) {
      androidDeviceInfo = await deviceInfo
          .androidInfo; // instantiate Android Device Infoformation
      if (androidDeviceInfo != null) {
        print("Funcation - getDeviceinfo androidDeviceInfo is not null ");
        brand = androidDeviceInfo.manufacturer;
        manufacture = androidDeviceInfo.manufacturer;
        model = androidDeviceInfo.model;
        release = androidDeviceInfo.version.release;
        sdkInt = androidDeviceInfo.version.sdkInt;
        id = androidDeviceInfo.androidId;
        var device = androidDeviceInfo.device;
        var brand_ = androidDeviceInfo.brand;
        var product = androidDeviceInfo.product;

        print('brand  : $brand');
        print('manufacture  : $manufacture');
        print('model  : $model');
        print('release  : $release');
        print('sdkInt  : $sdkInt');
        print('id  : $id');
        print('device  : $device');
        print('brand_  : $brand_');
        print('product  : $product');

        PreferenceUtils.setInteger(Utils.AndroidSDK, sdkInt);
        if (brand != null) {
          PreferenceUtils.setString(Utils.MobileBrand, brand);
        } else {
          PreferenceUtils.setString(Utils.MobileBrand, manufacture);
        }
        if (model != null) {
          PreferenceUtils.setString(Utils.MobileModel, model);
        }
        if (id != null) {
          PreferenceUtils.setString(Utils.MobileID, id);
        }
        if (release != null) {
          PreferenceUtils.setString(Utils.MobileOS, release);
        }
        if (brand_ != null) {
          PreferenceUtils.setString(Utils.MobileTec, model);
        }
        PreferenceUtils.setString(Utils.DeviceType, "Android");
      } else {
        print("Funcation - getDeviceinfo androidDeviceInfo is  null ");
      }
      //  print('sdkInt  : $sdkInt');
    }
  }

  Future<void> getCountryCode() async {
    String platformVersion;
    try {
      platformVersion = await FlutterSimCountryCode.simCountryCode;
      print("Sim country code is  $platformVersion ");
      PreferenceUtils.setString(Utils.SimCountryCode, platformVersion);
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;
  }

  Future<void> getIOSDeviceinfo() async {
    PreferenceUtils.setString(Utils.DeviceType, "Ios");
    try {
      model = await platform.invokeMethod('ios_device_model');

     // mToast(model);
      print("Model Name of IOS Device  =====  $model");


      if (model != null) {
        PreferenceUtils.setString(Utils.MobileModel, model);
        PreferenceUtils.setString(Utils.MobileTec, model);
        getIOSDeviceBrand();
      }
    } on PlatformException catch (e) {}
  }

  Future<void> getIOSDeviceBrand() async {
    try {
      brand = await platform.invokeMethod('ios_device_brand');
      if (brand != null) {
        PreferenceUtils.setString(Utils.MobileBrand, brand);
      } else {
        PreferenceUtils.setString(Utils.MobileBrand, "iPhone");
      }
    } on PlatformException catch (e) {}
  }

  void cameraPermissionCheck() async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var resultCamera =
        await _permissionHandler.requestPermissions([PermissionGroup.camera]);
    if (resultCamera[PermissionGroup.camera] == PermissionStatus.granted) {
      phonePermissionCheck();
    } else if (resultCamera[PermissionGroup.camera] ==
            PermissionStatus.denied ||
        resultCamera[PermissionGroup.camera] == PermissionStatus.disabled ||
        resultCamera[PermissionGroup.camera] == PermissionStatus.restricted) {
      print("Camera Permission Denied");
      _showDialogPermissionCamera();
    }
  }

  void phonePermissionCheck() async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var resultPhone =
        await _permissionHandler.requestPermissions([PermissionGroup.phone]);
    if (resultPhone[PermissionGroup.phone] == PermissionStatus.granted) {
      print("Phone Permission Granted");
      Future.delayed(const Duration(seconds: 1), () {
        getSimInfo();
      });
    } else if (resultPhone[PermissionGroup.phone] == PermissionStatus.denied ||
        resultPhone[PermissionGroup.phone] == PermissionStatus.disabled ||
        resultPhone[PermissionGroup.phone] == PermissionStatus.restricted) {
      print("Phone Permission Denied");
      _showDialogPermissionPhone();
    }
  }

  void _showDialogPermissionCamera() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Permission Required"),
          content: new Text(
              "Allow permission this is mandatory to move further in App"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
// getPermissionStatus();
                cameraPermissionCheck();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogPermissionPhone() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Permission Required"),
          content: new Text(
              "Allow permission this is mandatory to move further in App"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
// videoPermission();
                phonePermissionCheck();
              },
            ),
          ],
        );
      },
    );
  }

//
//  showAlertDialogForPermission(BuildContext context,String type) {
//    // Create button
//    Widget okButton = FlatButton(
//      child: Text("OK"),
//      onPressed: () {
//        Navigator.of(context).pop();
//        if(type == "camera"){
//          getPermissionStatus();
//        }else{
//          videoPermission();
//        }
//
//      },
//    );
//
//    // Create AlertDialog
//    AlertDialog alert = AlertDialog(
//      title: Text("Permission Required"),
//      content: Text("Please Allow Permissions, These Permissions are mandatory without these permissions you cannot enter in the app"),
//      actions: [
//        okButton,
//      ],
//    );
//
//    // show the dialog
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        return alert;
//      },
//    );
//  }

}
