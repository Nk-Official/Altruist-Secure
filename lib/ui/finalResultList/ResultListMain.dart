import 'dart:io';
import 'package:altruist_secure_flutter/Camera/UI/camera_test.dart';
import 'package:altruist_secure_flutter/CoupenPageScreen/VoucherScreenPresenter.dart';
import 'package:altruist_secure_flutter/RepairNowTest/repairNowScreen.dart';
import 'package:altruist_secure_flutter/ResultList/Model/resultModel.dart';
import 'package:altruist_secure_flutter/SellNowTest/sellNowScreen.dart';
import 'package:altruist_secure_flutter/SubScriptionWebPage/UI/subscriptionWePage.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/Vibration/UI/vibration_test.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/apis/apis.dart';
import 'package:altruist_secure_flutter/blocs/saveDiagnose/save_diagnose_app_list_bloc.dart';
import 'package:altruist_secure_flutter/blocs/saveDiagnose/save_diagnose_app_list_event.dart';
import 'package:altruist_secure_flutter/blocs/saveDiagnose/save_diagnose_app_list_state.dart';
import 'package:altruist_secure_flutter/models/requests/diagnostic_list/DiagnosticListRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/save_diagnostics/SaveDiagnoseRequestModel.dart';
import 'package:altruist_secure_flutter/models/responses/diagnostic_list/DiagnosticListResponseModel.dart';
import 'package:altruist_secure_flutter/ui/ApproveImageScreen/aproveImageScreen.dart';
import 'package:altruist_secure_flutter/ui/ApproveImageScreen/aproveImageScreenXml.dart';
import 'package:altruist_secure_flutter/ui/UserConfirmationScreen/userConfirmationScereen.dart';
import 'package:altruist_secure_flutter/ui/finalResultList/ResultListMainForm.dart';
import 'package:altruist_secure_flutter/utils/StringConstants.dart';
import 'package:altruist_secure_flutter/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:device_info/device_info.dart';
import 'dart:io' show Platform;
import 'package:toast/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:sweetalert/sweetalert.dart';

class ResultListMain extends StatefulWidget {
  @override
  _ResultListMainState createState() => _ResultListMainState();
}

class _ResultListMainState extends State<ResultListMain> {
  List<resultBean> itemList;
  List<resultBean> itemListIOS;
  List<resultBean> assignLsit;
  List<Diagnostic> diagnosticsList;
  List<DiagnosResultDetail> diagnosResultDetailsList;
  SaveDiagnoseAppListBloc _bloc;
  SharedPrefs sharedPrefUtils;
  int finalScore = 0;
  int totalScore = 0;
  String deviceModel,
      deviceName,
      deviceID,
      deviceOS,
      deviceType; // instantiate device info plugin
  AndroidDeviceInfo androidDeviceInfo;
  IosDeviceInfo iosDeviceInfo;
  String brand, id, manufacture, model, release;
  var percentage;
  var FinalPercentage;
  bool mimeitestStatus_;
  bool buttonoptionvisible_;
  bool buttonContinueVisibility_;
  bool sellVisibilty_;
  bool repairVisibilty_;
  bool isLoadingProgress = false;

  @override
  void initState() {
    PreferenceUtils.init();
    //getDeviceinfo();
    itemListIOS = _itemListIOS();
    mimeitestStatus_ = false;
    buttonoptionvisible_ = false;
    buttonContinueVisibility_ = false;
    sellVisibilty_ = false;
    repairVisibilty_ = false;
    if (Platform.isAndroid) {
      itemList = _itemList();
      assignLsit = itemList;
      Future.delayed(const Duration(milliseconds: 1000), () async {
        if (PreferenceUtils.getString(Utils.appPackageName) ==
            "com.app.mansardecure_secure") {
          mMandSecureRating();
          return;
        }
        mRating();
      });
    } else {
      // iOS-specific code
      assignLsit = itemListIOS;
      Future.delayed(const Duration(milliseconds: 1000), () async {
        if (PreferenceUtils.getString(Utils.appPackageName) ==
            "com.app.mansardecure_secure") {
          mMandSecureRating();
          return;
        }
        mRating();
      });
    }
    _bloc = SaveDiagnoseAppListBloc(apisRepository: ApisRepository());
    var diagnosticListRequestModel = DiagnosticListRequestModel(
        source: StringConstants.SOURCE,
        operatorCode: PreferenceUtils.getString(Utils.OPERATORCODE),
        countryId: PreferenceUtils.getString(Utils.COUNTRY_ID),
        userId: PreferenceUtils.getString(Utils.USER_ID));
    _bloc.add(FetchDiagnosApplIstEvent(
        diagnosticListRequestModel: diagnosticListRequestModel));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: WillPopScope(
            onWillPop: _onWillPop,
            child: BlocListener(
              bloc: _bloc,
              listener: (BuildContext context, SaveDiagnoseAppListState state) {
                if (state is InitialSaveDiagnoseAppListState) {
                  if (state.isLoading == false && !state.isSuccess) {
                    //  AppUtils.showSnackBar(context, state.message);
                    mToast(state.message);
                  } else if (state.isLoading == false && state.isSuccess) {
                    print("App InitialSaveDiagnoseAppListState Called Api Called");

                    if (state.diagnostics != null &&
                        state.diagnostics.length > 0) {
                      //   mToast(state.message);
                      diagnosticsList = state.diagnostics;
                      for (var i = 0; i < assignLsit.length; i++) {
                        for (var j = 0; j < diagnosticsList.length; j++) {
                          if (diagnosticsList[j].diagnosTechName ==
                              assignLsit[i].displayName) {
                            if (assignLsit[i].status == "true") {
                              //  finalScore = finalScore + diagnosticsList[j].maxScore;
                            }
                          }
                        }
                      }
                    } else {

                      print("App  Called Api Called in the else");
                      // AppUtils.showSnackBar(context, state.message);
                      mToast(state.message);
                      EventTracker.logEvent("DIAGNOSE_TEST_LIST_SAVED");

                      if (PreferenceUtils.getString(Utils.appPackageName) ==
                          "com.app.mansardecure_secure") {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VoucherScreenPresenter(),
                              settings: RouteSettings(
                                  name: 'VoucherScreenPresenter')),
                        );
                      } else if (PreferenceUtils.getString(Utils.appPackageName) == "com.app.altruists_secure_bangla".trim() || PreferenceUtils.getString(Utils.appPackageName) == "com.app.altruists-secure-bangla") {
                        print("App Bangla Called Api Called");
                        String Request =  Utils.ImageApprovalUrl + PreferenceUtils.getString(Utils.USER_ID);

                        Future.delayed(const Duration(seconds: 2), () {

                          _bloc.add(ImageInfoEvent(url: Request));
                          print("Request ===  $Request");

                        });



                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Subscription(),
                              settings: RouteSettings(name: 'Subscription')),
                        );
                      }
                    }
                  }
                }
                if (state is InitialImageInfotState) {
                  if (state.isLoading == false && !state.isSuccess) {
                    mToast(state.message);
                  } else if (state.isLoading == false && state.isSuccess) {
                    var ImageStatus = state.imageApprovalResponse.toString();
                    print("ImageStatus ========   $ImageStatus  ");
                    if(state.imageApprovalResponse.imageStatus == "Approve"){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserConfirmationScereen(),
                            settings: RouteSettings(name: 'UserConfirmationScereen')),
                      );
                    }else{
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AproveImageScreen(),
                            settings: RouteSettings(name: 'AproveImageScreen')),
                      );
                    }
                  }
                }
              },
              child: BlocBuilder(
                bloc: _bloc,
                builder: (context, SaveDiagnoseAppListState state) {
                  if (state is InitialSaveDiagnoseAppListState) {
                    if (state.isLoading) {
                      isLoadingProgress = state.isLoading;
                    } else {
                      isLoadingProgress = false;
                    }
                  } else if (state is InitialImageInfotState) {
                    if (state.isLoading) {
                      isLoadingProgress = state.isLoading;
                    } else {
                      isLoadingProgress = false;
                    }
                  }

                  return ModalProgressHUD(
                    color: Colors.black,
                    inAsyncCall: isLoadingProgress,
                    child: ResultListMainForm(
                      assignLsit: assignLsit,
                      deviceName: PreferenceUtils.getString(Utils.MobileModel),
                      deviceBrand: PreferenceUtils.getString(Utils.MobileBrand),
                      // rating: " Rating " + PreferenceUtils.getString(Utils.RATINGScore) + "/" + PreferenceUtils.getString(Utils.TOTALScore),
                      rating: " Rating " + FinalPercentage.toString() + "%",
                      score: finalScore.toString(),
                      buttonContinueVisibility: buttonContinueVisibility_,
                      buttonoptionvisible: buttonoptionvisible_,
                      mimeitestStatus: mimeitestStatus_,
                      sellVisibilty: sellVisibilty_,
                      repairVisibilty: repairVisibilty_,
                      onContinueClick: () {
                        EventTracker.logEvent("DIAGNOSE_TEST_LIST_SAVE_CLICK");
                        mContinueClick();
                      },
                      onContinueClickTestAgin: () {
                        if (PreferenceUtils.getString(Utils.appPackageName) ==
                            "com.app.mansardecure_secure") {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TakePictureScreen__(),
                                settings:
                                    RouteSettings(name: 'TakePictureScreen__')),
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VibrationTest(),
                                settings: RouteSettings(name: 'Vibration')),
                          );
                        }
                      },

                      onSellNowClick: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SellNowScreen(),
                            ));

                        //_showDialog("", Utils.Option1);
                      },
                      onRepairNowClick: () {
                        //_showDialog("", Utils.Option2);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RepairNowScreen(),
                            ));
                      },
                    ),
                  );
                },
              ),
            )));
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  List<resultBean> _itemList() {
    print("Country ID === ${PreferenceUtils.getString(Utils.COUNTRY_ID)}");

    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      return [
        resultBean(
            id: 0,
            imageUrl: 'assets/camera_blue.png',
            testName: 'Back Camera ',
            status: PreferenceUtils.getString(Utils.Camera),
            displayName: "camera_test"),
        resultBean(
            id: 0,
            imageUrl: 'assets/camera_blue.png',
            testName: 'Front Camera ',
            status: PreferenceUtils.getString(Utils.Front_Camera),
            displayName: "front_camera_test"),
        resultBean(
            id: 0,
            imageUrl: 'assets/mobile_phone_vibrating_blue.png',
            testName: 'Screen Glass ',
            status: PreferenceUtils.getString(Utils.ScreenDamageSatatus),
            displayName: "screen_glass"),
        resultBean(
            id: 0,
            imageUrl: 'assets/mobile_phone_vibrating_blue.png',
            testName: 'Display ',
            status: PreferenceUtils.getString(Utils.Display_),
            displayName: "display_test"),
      ];
    } else {
      if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "971" ||
          PreferenceUtils.getString(Utils.COUNTRY_ID) == "234") {
        if (PreferenceUtils.getString(Utils.Light_Sensor) != null &&
            PreferenceUtils.getString(Utils.Light_Sensor).trim() == "true") {
          return [
            resultBean(
                id: 0,
                imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                testName: 'Vibration  ',
                status: PreferenceUtils.getString(Utils.vibration),
                displayName: "vibration_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/sim_card_blue.png',
                testName: 'SIM',
                status: PreferenceUtils.getString(Utils.sim),
                displayName: "sim_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/speaker_blue.png',
                testName: 'Speaker ',
                status: PreferenceUtils.getString(Utils.Speaker),
                displayName: "speaker_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/headphones_blue.png',
                testName: 'Earphone Jack',
                status: PreferenceUtils.getString(Utils.Headphone),
                displayName: "head_phone_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/flash_blue.png',
                testName: 'Flash ',
                status: PreferenceUtils.getString(Utils.Flash),
                displayName: "flash_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/camera_blue.png',
                testName: 'Back Camera ',
                status: PreferenceUtils.getString(Utils.Camera),
                displayName: "camera_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/camera_blue.png',
                testName: 'Front Camera ',
                status: PreferenceUtils.getString(Utils.Front_Camera),
                displayName: "front_camera_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/wifi_blue.png',
                testName: 'WiFi ',
                status: PreferenceUtils.getString(Utils.Wifi),
                displayName: "wifi_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/bluetooth_blue.png',
                testName: 'Bluetooth ',
                status: PreferenceUtils.getString(Utils.Bluetooth),
                displayName: "bluetooth_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Light Sensor ',
                status: PreferenceUtils.getString(Utils.Light_Sensor),
                displayName: "light_sensor_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Battery ',
                status: PreferenceUtils.getString(Utils.Battery_Sensor),
                displayName: "battery_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Proximity Sensor ',
                status: PreferenceUtils.getString(Utils.Proximity_Sensor),
                displayName: "proximity_sensor_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Gravity Sensor ',
                status: PreferenceUtils.getString(Utils.Gravity_Sensor),
                displayName: "gravity_sensor_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Magnetic Sensor ',
                status: PreferenceUtils.getString(Utils.Magnetic_Sensor),
                displayName: "magnetic_sensor_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                testName: 'Display ',
                status: PreferenceUtils.getString(Utils.Display_),
                displayName: "display_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                testName: 'Screen Glass ',
                status: PreferenceUtils.getString(Utils.ScreenDamageSatatus),
                displayName: "screen_glass"),
          ];
        } else {
          return [
            resultBean(
                id: 0,
                imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                testName: 'Vibration ',
                status: PreferenceUtils.getString(Utils.vibration),
                displayName: "vibration_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/sim_card_blue.png',
                testName: ' SIM',
                status: PreferenceUtils.getString(Utils.sim),
                displayName: "sim_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/speaker_blue.png',
                testName: 'Speaker',
                status: PreferenceUtils.getString(Utils.Speaker),
                displayName: "speaker_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/headphones_blue.png',
                testName: 'Earphone Jack',
                status: PreferenceUtils.getString(Utils.Headphone),
                displayName: "head_phone_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/flash_blue.png',
                testName: 'Flash',
                status: PreferenceUtils.getString(Utils.Flash),
                displayName: "flash_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/camera_blue.png',
                testName: 'Back Camera',
                status: PreferenceUtils.getString(Utils.Camera),
                displayName: "camera_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/camera_blue.png',
                testName: 'Front Camera',
                status: PreferenceUtils.getString(Utils.Front_Camera),
                displayName: "front_camera_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/wifi_blue.png',
                testName: 'WiFi',
                status: PreferenceUtils.getString(Utils.Wifi),
                displayName: "wifi_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/bluetooth_blue.png',
                testName: 'Bluetooth',
                status: PreferenceUtils.getString(Utils.Bluetooth),
                displayName: "bluetooth_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Battery',
                status: PreferenceUtils.getString(Utils.Battery_Sensor),
                displayName: "battery_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Proximity Sensor',
                status: PreferenceUtils.getString(Utils.Proximity_Sensor),
                displayName: "proximity_sensor_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Gravity Sensor',
                status: PreferenceUtils.getString(Utils.Gravity_Sensor),
                displayName: "gravity_sensor_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Magnetic Sensor',
                status: PreferenceUtils.getString(Utils.Magnetic_Sensor),
                displayName: "magnetic_sensor_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                testName: 'Display',
                status: PreferenceUtils.getString(Utils.Display_),
                displayName: "display_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                testName: 'Screen Glass ',
                status: PreferenceUtils.getString(Utils.ScreenDamageSatatus),
                displayName: "screen_glass"),
          ];
        }
      } else {
        if (PreferenceUtils.getString(Utils.Light_Sensor) != null &&
            PreferenceUtils.getString(Utils.Light_Sensor).trim() == "true") {
          if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "88") {
            return [
              resultBean(
                  id: 0,
                  imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                  testName: 'Vibration  ',
                  status: PreferenceUtils.getString(Utils.vibration),
                  displayName: "vibration_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/sim_card_blue.png',
                  testName: 'SIM',
                  status: PreferenceUtils.getString(Utils.sim),
                  displayName: "sim_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/speaker_blue.png',
                  testName: 'Speaker ',
                  status: PreferenceUtils.getString(Utils.Speaker),
                  displayName: "speaker_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/headphones_blue.png',
                  testName: 'Earphone Jack',
                  status: PreferenceUtils.getString(Utils.Headphone),
                  displayName: "head_phone_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/flash_blue.png',
                  testName: 'Flash ',
                  status: PreferenceUtils.getString(Utils.Flash),
                  displayName: "flash_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/camera_blue.png',
                  testName: 'Back Camera ',
                  status: PreferenceUtils.getString(Utils.Camera),
                  displayName: "camera_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/camera_blue.png',
                  testName: 'Front Camera ',
                  status: PreferenceUtils.getString(Utils.Front_Camera),
                  displayName: "front_camera_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/bluetooth_blue.png',
                  testName: 'Bluetooth ',
                  status: PreferenceUtils.getString(Utils.Bluetooth),
                  displayName: "bluetooth_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Light Sensor ',
                  status: PreferenceUtils.getString(Utils.Light_Sensor),
                  displayName: "light_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Battery ',
                  status: PreferenceUtils.getString(Utils.Battery_Sensor),
                  displayName: "battery_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Proximity Sensor ',
                  status: PreferenceUtils.getString(Utils.Proximity_Sensor),
                  displayName: "proximity_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Gravity Sensor ',
                  status: PreferenceUtils.getString(Utils.Gravity_Sensor),
                  displayName: "gravity_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Magnetic Sensor ',
                  status: PreferenceUtils.getString(Utils.Magnetic_Sensor),
                  displayName: "magnetic_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                  testName: 'Display ',
                  status: PreferenceUtils.getString(Utils.Display_),
                  displayName: "display_test"),
            ];
          } else {
            return [
              resultBean(
                  id: 0,
                  imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                  testName: 'Vibration  ',
                  status: PreferenceUtils.getString(Utils.vibration),
                  displayName: "vibration_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/sim_card_blue.png',
                  testName: 'SIM',
                  status: PreferenceUtils.getString(Utils.sim),
                  displayName: "sim_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/speaker_blue.png',
                  testName: 'Speaker ',
                  status: PreferenceUtils.getString(Utils.Speaker),
                  displayName: "speaker_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/headphones_blue.png',
                  testName: 'Earphone Jack',
                  status: PreferenceUtils.getString(Utils.Headphone),
                  displayName: "head_phone_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/flash_blue.png',
                  testName: 'Flash ',
                  status: PreferenceUtils.getString(Utils.Flash),
                  displayName: "flash_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/camera_blue.png',
                  testName: 'Back Camera ',
                  status: PreferenceUtils.getString(Utils.Camera),
                  displayName: "camera_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/camera_blue.png',
                  testName: 'Front Camera ',
                  status: PreferenceUtils.getString(Utils.Front_Camera),
                  displayName: "front_camera_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/wifi_blue.png',
                  testName: 'WiFi ',
                  status: PreferenceUtils.getString(Utils.Wifi),
                  displayName: "wifi_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/bluetooth_blue.png',
                  testName: 'Bluetooth ',
                  status: PreferenceUtils.getString(Utils.Bluetooth),
                  displayName: "bluetooth_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Light Sensor ',
                  status: PreferenceUtils.getString(Utils.Light_Sensor),
                  displayName: "light_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Battery ',
                  status: PreferenceUtils.getString(Utils.Battery_Sensor),
                  displayName: "battery_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Proximity Sensor ',
                  status: PreferenceUtils.getString(Utils.Proximity_Sensor),
                  displayName: "proximity_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Gravity Sensor ',
                  status: PreferenceUtils.getString(Utils.Gravity_Sensor),
                  displayName: "gravity_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Magnetic Sensor ',
                  status: PreferenceUtils.getString(Utils.Magnetic_Sensor),
                  displayName: "magnetic_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                  testName: 'Display ',
                  status: PreferenceUtils.getString(Utils.Display_),
                  displayName: "display_test"),
            ];
          }
        } else {
          if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "88") {
            return [
              resultBean(
                  id: 0,
                  imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                  testName: 'Vibration ',
                  status: PreferenceUtils.getString(Utils.vibration),
                  displayName: "vibration_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/sim_card_blue.png',
                  testName: ' SIM',
                  status: PreferenceUtils.getString(Utils.sim),
                  displayName: "sim_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/speaker_blue.png',
                  testName: 'Speaker',
                  status: PreferenceUtils.getString(Utils.Speaker),
                  displayName: "speaker_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/headphones_blue.png',
                  testName: 'Earphone Jack',
                  status: PreferenceUtils.getString(Utils.Headphone),
                  displayName: "head_phone_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/flash_blue.png',
                  testName: 'Flash',
                  status: PreferenceUtils.getString(Utils.Flash),
                  displayName: "flash_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/camera_blue.png',
                  testName: 'Back Camera',
                  status: PreferenceUtils.getString(Utils.Camera),
                  displayName: "camera_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/camera_blue.png',
                  testName: 'Front Camera',
                  status: PreferenceUtils.getString(Utils.Front_Camera),
                  displayName: "front_camera_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/bluetooth_blue.png',
                  testName: 'Bluetooth',
                  status: PreferenceUtils.getString(Utils.Bluetooth),
                  displayName: "bluetooth_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Battery',
                  status: PreferenceUtils.getString(Utils.Battery_Sensor),
                  displayName: "battery_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Proximity Sensor',
                  status: PreferenceUtils.getString(Utils.Proximity_Sensor),
                  displayName: "proximity_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Gravity Sensor',
                  status: PreferenceUtils.getString(Utils.Gravity_Sensor),
                  displayName: "gravity_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Magnetic Sensor',
                  status: PreferenceUtils.getString(Utils.Magnetic_Sensor),
                  displayName: "magnetic_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                  testName: 'Display',
                  status: PreferenceUtils.getString(Utils.Display_),
                  displayName: "display_test"),
            ];
          } else {
            return [
              resultBean(
                  id: 0,
                  imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                  testName: 'Vibration ',
                  status: PreferenceUtils.getString(Utils.vibration),
                  displayName: "vibration_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/sim_card_blue.png',
                  testName: ' SIM',
                  status: PreferenceUtils.getString(Utils.sim),
                  displayName: "sim_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/speaker_blue.png',
                  testName: 'Speaker',
                  status: PreferenceUtils.getString(Utils.Speaker),
                  displayName: "speaker_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/headphones_blue.png',
                  testName: 'Earphone Jack',
                  status: PreferenceUtils.getString(Utils.Headphone),
                  displayName: "head_phone_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/flash_blue.png',
                  testName: 'Flash',
                  status: PreferenceUtils.getString(Utils.Flash),
                  displayName: "flash_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/camera_blue.png',
                  testName: 'Back Camera',
                  status: PreferenceUtils.getString(Utils.Camera),
                  displayName: "camera_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/camera_blue.png',
                  testName: 'Front Camera',
                  status: PreferenceUtils.getString(Utils.Front_Camera),
                  displayName: "front_camera_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/wifi_blue.png',
                  testName: 'WiFi',
                  status: PreferenceUtils.getString(Utils.Wifi),
                  displayName: "wifi_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/bluetooth_blue.png',
                  testName: 'Bluetooth',
                  status: PreferenceUtils.getString(Utils.Bluetooth),
                  displayName: "bluetooth_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Battery',
                  status: PreferenceUtils.getString(Utils.Battery_Sensor),
                  displayName: "battery_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Proximity Sensor',
                  status: PreferenceUtils.getString(Utils.Proximity_Sensor),
                  displayName: "proximity_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Gravity Sensor',
                  status: PreferenceUtils.getString(Utils.Gravity_Sensor),
                  displayName: "gravity_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Magnetic Sensor',
                  status: PreferenceUtils.getString(Utils.Magnetic_Sensor),
                  displayName: "magnetic_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                  testName: 'Display',
                  status: PreferenceUtils.getString(Utils.Display_),
                  displayName: "display_test"),
            ];
          }
        }
      }
    }
  }

  List<resultBean> _itemListIOS() {
    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      return [
        resultBean(
            id: 0,
            imageUrl: 'assets/camera_blue.png',
            testName: 'Back Camera ',
            status: PreferenceUtils.getString(Utils.Camera),
            displayName: "camera_test"),
        resultBean(
            id: 0,
            imageUrl: 'assets/camera_blue.png',
            testName: 'Front Camera ',
            status: PreferenceUtils.getString(Utils.Front_Camera),
            displayName: "front_camera_test"),
        resultBean(
            id: 0,
            imageUrl: 'assets/mobile_phone_vibrating_blue.png',
            testName: 'Screen Glass ',
            status: PreferenceUtils.getString(Utils.ScreenDamageSatatus),
            displayName: "screen_glass"),
        resultBean(
            id: 0,
            imageUrl: 'assets/mobile_phone_vibrating_blue.png',
            testName: 'Display ',
            status: PreferenceUtils.getString(Utils.Display_),
            displayName: "display_test"),
      ];
    } else {
      if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "971" ||
          PreferenceUtils.getString(Utils.COUNTRY_ID) == "234") {
        if (PreferenceUtils.getString(Utils.FaceID_Sensor_Status) != null &&
            PreferenceUtils.getString(Utils.FaceID_Sensor_Status) == "true") {
          return [
            resultBean(
                id: 0,
                imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                testName: 'Vibration  ',
                status: PreferenceUtils.getString(Utils.vibration),
                displayName: "vibration_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/sim_card_blue.png',
                testName: 'SIM',
                status: PreferenceUtils.getString(Utils.sim),
                displayName: "sim_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/speaker_blue.png',
                testName: 'Speaker ',
                status: PreferenceUtils.getString(Utils.Speaker),
                displayName: "speaker_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/headphones_blue.png',
                testName: 'Earphone Jack',
                status: PreferenceUtils.getString(Utils.Headphone),
                displayName: "head_phone_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/flash_blue.png',
                testName: 'Flash ',
                status: PreferenceUtils.getString(Utils.Flash),
                displayName: "flash_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/camera_blue.png',
                testName: 'Back Camera ',
                status: PreferenceUtils.getString(Utils.Camera),
                displayName: "camera_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/camera_blue.png',
                testName: 'Front Camera ',
                status: PreferenceUtils.getString(Utils.Front_Camera),
                displayName: "front_camera_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/wifi_blue.png',
                testName: 'Wifi ',
                status: PreferenceUtils.getString(Utils.Wifi),
                displayName: "wifi_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/bluetooth_blue.png',
                testName: 'Bluetooth ',
                status: PreferenceUtils.getString(Utils.Bluetooth),
                displayName: "bluetooth_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Proximity Sensor ',
                status: PreferenceUtils.getString(Utils.Proximity_Sensor),
                displayName: "proximity_sensor_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Battery ',
                status: PreferenceUtils.getString(Utils.Battery_Sensor),
                displayName: "battery_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Gravity Sensor ',
                status: PreferenceUtils.getString(Utils.Gravity_Sensor),
                displayName: "gravity_sensor_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Magnetic Sensor ',
                status: PreferenceUtils.getString(Utils.Magnetic_Sensor),
                displayName: "magnetic_sensor_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Accelerometer Sensor ',
                status: PreferenceUtils.getString(Utils.Accelerometer_Sensor),
                displayName: "accelerometer_sensor_ios"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Location Sensor ',
                status: PreferenceUtils.getString(Utils.Location_Sensor),
                displayName: "location_sensor_ios"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Barometer Sensor ',
                status: PreferenceUtils.getString(Utils.Barometer_Sensor),
                displayName: "barometer_sensor_ios"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Face ID Sensor ',
                status: PreferenceUtils.getString(Utils.FaceID_Sensor),
                displayName: "barometer_sensor_ios"),
            resultBean(
                id: 0,
                imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                testName: 'Display ',
                status: PreferenceUtils.getString(Utils.Display_),
                displayName: "display_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                testName: 'Screen Glass',
                status: PreferenceUtils.getString(Utils.ScreenDamageSatatus),
                displayName: "screenglass_test"),
          ];
        } else {
          return [
            resultBean(
                id: 0,
                imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                testName: 'Vibration  ',
                status: PreferenceUtils.getString(Utils.vibration),
                displayName: "vibration_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/sim_card_blue.png',
                testName: 'SIM',
                status: PreferenceUtils.getString(Utils.sim),
                displayName: "sim_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/speaker_blue.png',
                testName: 'Speaker ',
                status: PreferenceUtils.getString(Utils.Speaker),
                displayName: "speaker_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/headphones_blue.png',
                testName: 'Earphone Jack',
                status: PreferenceUtils.getString(Utils.Headphone),
                displayName: "head_phone_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/flash_blue.png',
                testName: 'Flash ',
                status: PreferenceUtils.getString(Utils.Flash),
                displayName: "flash_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/camera_blue.png',
                testName: 'Back Camera ',
                status: PreferenceUtils.getString(Utils.Camera),
                displayName: "camera_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/camera_blue.png',
                testName: 'Front Camera ',
                status: PreferenceUtils.getString(Utils.Front_Camera),
                displayName: "front_camera_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/wifi_blue.png',
                testName: 'Wifi ',
                status: PreferenceUtils.getString(Utils.Wifi),
                displayName: "wifi_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/bluetooth_blue.png',
                testName: 'Bluetooth ',
                status: PreferenceUtils.getString(Utils.Bluetooth),
                displayName: "bluetooth_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Battery ',
                status: PreferenceUtils.getString(Utils.Battery_Sensor),
                displayName: "battery_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Proximity Sensor ',
                status: PreferenceUtils.getString(Utils.Proximity_Sensor),
                displayName: "proximity_sensor_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Gravity Sensor ',
                status: PreferenceUtils.getString(Utils.Gravity_Sensor),
                displayName: "gravity_sensor_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Magnetic Sensor ',
                status: PreferenceUtils.getString(Utils.Magnetic_Sensor),
                displayName: "magnetic_sensor_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Accelerometer Sensor ',
                status: PreferenceUtils.getString(Utils.Accelerometer_Sensor),
                displayName: "accelerometer_sensor_ios"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Location Sensor ',
                status: PreferenceUtils.getString(Utils.Location_Sensor),
                displayName: "location_sensor_ios"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Barometer Sensor ',
                status: PreferenceUtils.getString(Utils.Barometer_Sensor),
                displayName: "barometer_sensor_ios"),
            resultBean(
                id: 0,
                imageUrl: 'assets/altruist_logo.png',
                testName: 'Fingerprint Sensor ',
                status: PreferenceUtils.getString(Utils.Fringerprint_Sensor),
                displayName: "fingerprint_sensor_ios"),
            resultBean(
                id: 0,
                imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                testName: 'Display ',
                status: PreferenceUtils.getString(Utils.Display_),
                displayName: "display_test"),
            resultBean(
                id: 0,
                imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                testName: 'Screen Glass',
                status: PreferenceUtils.getString(Utils.ScreenDamageSatatus),
                displayName: "screenglass_test"),
          ];
        }
      } else {
        if (PreferenceUtils.getString(Utils.FaceID_Sensor_Status) != null &&
            PreferenceUtils.getString(Utils.FaceID_Sensor_Status) == "true") {
          if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "88") {
            return [
              resultBean(
                  id: 0,
                  imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                  testName: 'Vibration  ',
                  status: PreferenceUtils.getString(Utils.vibration),
                  displayName: "vibration_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/sim_card_blue.png',
                  testName: 'SIM',
                  status: PreferenceUtils.getString(Utils.sim),
                  displayName: "sim_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/speaker_blue.png',
                  testName: 'Speaker ',
                  status: PreferenceUtils.getString(Utils.Speaker),
                  displayName: "speaker_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/headphones_blue.png',
                  testName: 'Earphone Jack',
                  status: PreferenceUtils.getString(Utils.Headphone),
                  displayName: "head_phone_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/flash_blue.png',
                  testName: 'Flash ',
                  status: PreferenceUtils.getString(Utils.Flash),
                  displayName: "flash_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/camera_blue.png',
                  testName: 'Back Camera ',
                  status: PreferenceUtils.getString(Utils.Camera),
                  displayName: "camera_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/camera_blue.png',
                  testName: 'Front Camera ',
                  status: PreferenceUtils.getString(Utils.Front_Camera),
                  displayName: "front_camera_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/bluetooth_blue.png',
                  testName: 'Bluetooth ',
                  status: PreferenceUtils.getString(Utils.Bluetooth),
                  displayName: "bluetooth_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Proximity Sensor ',
                  status: PreferenceUtils.getString(Utils.Proximity_Sensor),
                  displayName: "proximity_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Battery ',
                  status: PreferenceUtils.getString(Utils.Battery_Sensor),
                  displayName: "battery_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Gravity Sensor ',
                  status: PreferenceUtils.getString(Utils.Gravity_Sensor),
                  displayName: "gravity_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Magnetic Sensor ',
                  status: PreferenceUtils.getString(Utils.Magnetic_Sensor),
                  displayName: "magnetic_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Accelerometer Sensor ',
                  status: PreferenceUtils.getString(Utils.Accelerometer_Sensor),
                  displayName: "accelerometer_sensor_ios"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Location Sensor ',
                  status: PreferenceUtils.getString(Utils.Location_Sensor),
                  displayName: "location_sensor_ios"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Barometer Sensor ',
                  status: PreferenceUtils.getString(Utils.Barometer_Sensor),
                  displayName: "barometer_sensor_ios"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Face ID Sensor ',
                  status: PreferenceUtils.getString(Utils.FaceID_Sensor),
                  displayName: "barometer_sensor_ios"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                  testName: 'Display ',
                  status: PreferenceUtils.getString(Utils.Display_),
                  displayName: "display_test"),
            ];
          } else {
            return [
              resultBean(
                  id: 0,
                  imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                  testName: 'Vibration  ',
                  status: PreferenceUtils.getString(Utils.vibration),
                  displayName: "vibration_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/sim_card_blue.png',
                  testName: 'SIM',
                  status: PreferenceUtils.getString(Utils.sim),
                  displayName: "sim_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/speaker_blue.png',
                  testName: 'Speaker ',
                  status: PreferenceUtils.getString(Utils.Speaker),
                  displayName: "speaker_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/headphones_blue.png',
                  testName: 'Earphone Jack',
                  status: PreferenceUtils.getString(Utils.Headphone),
                  displayName: "head_phone_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/flash_blue.png',
                  testName: 'Flash ',
                  status: PreferenceUtils.getString(Utils.Flash),
                  displayName: "flash_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/camera_blue.png',
                  testName: 'Back Camera ',
                  status: PreferenceUtils.getString(Utils.Camera),
                  displayName: "camera_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/camera_blue.png',
                  testName: 'Front Camera ',
                  status: PreferenceUtils.getString(Utils.Front_Camera),
                  displayName: "front_camera_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/wifi_blue.png',
                  testName: 'Wifi ',
                  status: PreferenceUtils.getString(Utils.Wifi),
                  displayName: "wifi_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/bluetooth_blue.png',
                  testName: 'Bluetooth ',
                  status: PreferenceUtils.getString(Utils.Bluetooth),
                  displayName: "bluetooth_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Proximity Sensor ',
                  status: PreferenceUtils.getString(Utils.Proximity_Sensor),
                  displayName: "proximity_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Battery ',
                  status: PreferenceUtils.getString(Utils.Battery_Sensor),
                  displayName: "battery_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Gravity Sensor ',
                  status: PreferenceUtils.getString(Utils.Gravity_Sensor),
                  displayName: "gravity_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Magnetic Sensor ',
                  status: PreferenceUtils.getString(Utils.Magnetic_Sensor),
                  displayName: "magnetic_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Accelerometer Sensor ',
                  status: PreferenceUtils.getString(Utils.Accelerometer_Sensor),
                  displayName: "accelerometer_sensor_ios"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Location Sensor ',
                  status: PreferenceUtils.getString(Utils.Location_Sensor),
                  displayName: "location_sensor_ios"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Barometer Sensor ',
                  status: PreferenceUtils.getString(Utils.Barometer_Sensor),
                  displayName: "barometer_sensor_ios"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Face ID Sensor ',
                  status: PreferenceUtils.getString(Utils.FaceID_Sensor),
                  displayName: "barometer_sensor_ios"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                  testName: 'Display ',
                  status: PreferenceUtils.getString(Utils.Display_),
                  displayName: "display_test"),
            ];
          }
        } else {
          if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "88") {
            return [
              resultBean(
                  id: 0,
                  imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                  testName: 'Vibration  ',
                  status: PreferenceUtils.getString(Utils.vibration),
                  displayName: "vibration_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/sim_card_blue.png',
                  testName: 'SIM',
                  status: PreferenceUtils.getString(Utils.sim),
                  displayName: "sim_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/speaker_blue.png',
                  testName: 'Speaker ',
                  status: PreferenceUtils.getString(Utils.Speaker),
                  displayName: "speaker_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/headphones_blue.png',
                  testName: 'Earphone Jack',
                  status: PreferenceUtils.getString(Utils.Headphone),
                  displayName: "head_phone_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/flash_blue.png',
                  testName: 'Flash ',
                  status: PreferenceUtils.getString(Utils.Flash),
                  displayName: "flash_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/camera_blue.png',
                  testName: 'Back Camera ',
                  status: PreferenceUtils.getString(Utils.Camera),
                  displayName: "camera_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/camera_blue.png',
                  testName: 'Front Camera ',
                  status: PreferenceUtils.getString(Utils.Front_Camera),
                  displayName: "front_camera_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/bluetooth_blue.png',
                  testName: 'Bluetooth ',
                  status: PreferenceUtils.getString(Utils.Bluetooth),
                  displayName: "bluetooth_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Battery ',
                  status: PreferenceUtils.getString(Utils.Battery_Sensor),
                  displayName: "battery_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Proximity Sensor ',
                  status: PreferenceUtils.getString(Utils.Proximity_Sensor),
                  displayName: "proximity_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Gravity Sensor ',
                  status: PreferenceUtils.getString(Utils.Gravity_Sensor),
                  displayName: "gravity_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Magnetic Sensor ',
                  status: PreferenceUtils.getString(Utils.Magnetic_Sensor),
                  displayName: "magnetic_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Accelerometer Sensor ',
                  status: PreferenceUtils.getString(Utils.Accelerometer_Sensor),
                  displayName: "accelerometer_sensor_ios"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Location Sensor ',
                  status: PreferenceUtils.getString(Utils.Location_Sensor),
                  displayName: "location_sensor_ios"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Barometer Sensor ',
                  status: PreferenceUtils.getString(Utils.Barometer_Sensor),
                  displayName: "barometer_sensor_ios"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Fingerprint Sensor ',
                  status: PreferenceUtils.getString(Utils.Fringerprint_Sensor),
                  displayName: "fingerprint_sensor_ios"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                  testName: 'Display ',
                  status: PreferenceUtils.getString(Utils.Display_),
                  displayName: "display_test"),
            ];
          } else {
            return [
              resultBean(
                  id: 0,
                  imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                  testName: 'Vibration  ',
                  status: PreferenceUtils.getString(Utils.vibration),
                  displayName: "vibration_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/sim_card_blue.png',
                  testName: 'SIM',
                  status: PreferenceUtils.getString(Utils.sim),
                  displayName: "sim_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/speaker_blue.png',
                  testName: 'Speaker ',
                  status: PreferenceUtils.getString(Utils.Speaker),
                  displayName: "speaker_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/headphones_blue.png',
                  testName: 'Earphone Jack',
                  status: PreferenceUtils.getString(Utils.Headphone),
                  displayName: "head_phone_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/flash_blue.png',
                  testName: 'Flash ',
                  status: PreferenceUtils.getString(Utils.Flash),
                  displayName: "flash_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/camera_blue.png',
                  testName: 'Back Camera ',
                  status: PreferenceUtils.getString(Utils.Camera),
                  displayName: "camera_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/camera_blue.png',
                  testName: 'Front Camera ',
                  status: PreferenceUtils.getString(Utils.Front_Camera),
                  displayName: "front_camera_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/wifi_blue.png',
                  testName: 'Wifi ',
                  status: PreferenceUtils.getString(Utils.Wifi),
                  displayName: "wifi_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/bluetooth_blue.png',
                  testName: 'Bluetooth ',
                  status: PreferenceUtils.getString(Utils.Bluetooth),
                  displayName: "bluetooth_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Battery ',
                  status: PreferenceUtils.getString(Utils.Battery_Sensor),
                  displayName: "battery_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Proximity Sensor ',
                  status: PreferenceUtils.getString(Utils.Proximity_Sensor),
                  displayName: "proximity_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Gravity Sensor ',
                  status: PreferenceUtils.getString(Utils.Gravity_Sensor),
                  displayName: "gravity_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Magnetic Sensor ',
                  status: PreferenceUtils.getString(Utils.Magnetic_Sensor),
                  displayName: "magnetic_sensor_test"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Accelerometer Sensor ',
                  status: PreferenceUtils.getString(Utils.Accelerometer_Sensor),
                  displayName: "accelerometer_sensor_ios"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Location Sensor ',
                  status: PreferenceUtils.getString(Utils.Location_Sensor),
                  displayName: "location_sensor_ios"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Barometer Sensor ',
                  status: PreferenceUtils.getString(Utils.Barometer_Sensor),
                  displayName: "barometer_sensor_ios"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/altruist_logo.png',
                  testName: 'Fingerprint Sensor ',
                  status: PreferenceUtils.getString(Utils.Fringerprint_Sensor),
                  displayName: "fingerprint_sensor_ios"),
              resultBean(
                  id: 0,
                  imageUrl: 'assets/mobile_phone_vibrating_blue.png',
                  testName: 'Display ',
                  status: PreferenceUtils.getString(Utils.Display_),
                  displayName: "display_test"),
            ];
          }
        }
      }
    }
  }

  void mRating() {
    if (Platform.isAndroid) {
      mGetAndroidRating();
    } else {
      mGetIOSRatingList();
    }
  }

  void mGetAndroidRating() {
    if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "971" ||
        PreferenceUtils.getString(Utils.COUNTRY_ID) == "234") {
      totalScore = totalScore + 6;
      if (PreferenceUtils.getString(Utils.vibration) != null) {
        if (PreferenceUtils.getString(Utils.vibration) == "true") {
          finalScore = finalScore + 6;
        }
      }
      totalScore = totalScore + 5;
      if (PreferenceUtils.getString(Utils.sim) != null) {
        if (PreferenceUtils.getString(Utils.sim) == "true") {
          finalScore = finalScore + 5;
        }
      }
      totalScore = totalScore + 5;
      if (PreferenceUtils.getString(Utils.Speaker) != null) {
        if (PreferenceUtils.getString(Utils.Speaker) == "true") {
          finalScore = finalScore + 5;
        }
      }
      totalScore = totalScore + 5;
      if (PreferenceUtils.getString(Utils.Headphone) != null) {
        if (PreferenceUtils.getString(Utils.Headphone) == "true") {
          finalScore = finalScore + 5;
        }
      }
      totalScore = totalScore + 6;
      if (PreferenceUtils.getString(Utils.Flash) != null) {
        if (PreferenceUtils.getString(Utils.Flash) == "true") {
          finalScore = finalScore + 6;
        }
      }
      totalScore = totalScore + 10;
      if (PreferenceUtils.getString(Utils.Camera) != null) {
        if (PreferenceUtils.getString(Utils.Camera) == "true") {
          finalScore = finalScore + 10;
        }
      }
      totalScore = totalScore + 10;
      if (PreferenceUtils.getString(Utils.Front_Camera) != null) {
        if (PreferenceUtils.getString(Utils.Front_Camera) == "true") {
          finalScore = finalScore + 10;
        }
      }
      totalScore = totalScore + 5;
      if (PreferenceUtils.getString(Utils.Wifi) != null) {
        if (PreferenceUtils.getString(Utils.Wifi) == "true") {
          finalScore = finalScore + 5;
        }
      }
      totalScore = totalScore + 5;
      if (PreferenceUtils.getString(Utils.Bluetooth) != null) {
        if (PreferenceUtils.getString(Utils.Bluetooth) == "true") {
          finalScore = finalScore + 5;
        }
      }

      if (PreferenceUtils.getString(Utils.Light_Sensor) != null &&
          PreferenceUtils.getString(Utils.Light_Sensor).trim() == "true") {
        totalScore = totalScore + 4;
        if (PreferenceUtils.getString(Utils.Light_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Light_Sensor) == "true") {
            finalScore = finalScore + 4;
          }
        }
      }

      totalScore = totalScore + 7;
      if (PreferenceUtils.getString(Utils.Battery_Sensor) != null) {
        if (PreferenceUtils.getString(Utils.Battery_Sensor) == "true") {
          finalScore = finalScore + 7;
        }
      }
      totalScore = totalScore + 4;
      if (PreferenceUtils.getString(Utils.Proximity_Sensor) != null) {
        if (PreferenceUtils.getString(Utils.Proximity_Sensor) == "true") {
          finalScore = finalScore + 4;
        }
      }
      totalScore = totalScore + 4;
      if (PreferenceUtils.getString(Utils.Gravity_Sensor) != null) {
        if (PreferenceUtils.getString(Utils.Gravity_Sensor) == "true") {
          finalScore = finalScore + 4;
        }
      }
      totalScore = totalScore + 4;
      if (PreferenceUtils.getString(Utils.Magnetic_Sensor) != null) {
        if (PreferenceUtils.getString(Utils.Magnetic_Sensor) == "true") {
          finalScore = finalScore + 4;
        }
      }
      totalScore = totalScore + 10;
      if (PreferenceUtils.getString(Utils.Display_) != null) {
        if (PreferenceUtils.getString(Utils.Display_) == "true") {
          finalScore = finalScore + 10;
        }
      }

      totalScore = totalScore + 10;
      if (PreferenceUtils.getString(Utils.ScreenDamageSatatus) != null) {
        if (PreferenceUtils.getString(Utils.ScreenDamageSatatus) == "true") {
          finalScore = finalScore + 10;
        }
      }
    } else {
      totalScore = totalScore + 6;
      if (PreferenceUtils.getString(Utils.vibration) != null) {
        if (PreferenceUtils.getString(Utils.vibration) == "true") {
          finalScore = finalScore + 6;
        }
      }
      totalScore = totalScore + 5;
      if (PreferenceUtils.getString(Utils.sim) != null) {
        if (PreferenceUtils.getString(Utils.sim) == "true") {
          finalScore = finalScore + 5;
        }
      }
      totalScore = totalScore + 5;
      if (PreferenceUtils.getString(Utils.Speaker) != null) {
        if (PreferenceUtils.getString(Utils.Speaker) == "true") {
          finalScore = finalScore + 5;
        }
      }
      totalScore = totalScore + 5;
      if (PreferenceUtils.getString(Utils.Headphone) != null) {
        if (PreferenceUtils.getString(Utils.Headphone) == "true") {
          finalScore = finalScore + 5;
        }
      }
      totalScore = totalScore + 6;
      if (PreferenceUtils.getString(Utils.Flash) != null) {
        if (PreferenceUtils.getString(Utils.Flash) == "true") {
          finalScore = finalScore + 6;
        }
      }
      totalScore = totalScore + 10;
      if (PreferenceUtils.getString(Utils.Camera) != null) {
        if (PreferenceUtils.getString(Utils.Camera) == "true") {
          finalScore = finalScore + 10;
        }
      }
      totalScore = totalScore + 10;
      if (PreferenceUtils.getString(Utils.Front_Camera) != null) {
        if (PreferenceUtils.getString(Utils.Front_Camera) == "true") {
          finalScore = finalScore + 10;
        }
      }

      if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "88") {
      } else {
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Wifi) != null) {
          if (PreferenceUtils.getString(Utils.Wifi) == "true") {
            finalScore = finalScore + 5;
          }
        }
      }

      totalScore = totalScore + 5;
      if (PreferenceUtils.getString(Utils.Bluetooth) != null) {
        if (PreferenceUtils.getString(Utils.Bluetooth) == "true") {
          finalScore = finalScore + 5;
        }
      }
      if (PreferenceUtils.getString(Utils.Light_Sensor) != null &&
          PreferenceUtils.getString(Utils.Light_Sensor).trim() == "true") {
        totalScore = totalScore + 4;
        if (PreferenceUtils.getString(Utils.Light_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Light_Sensor) == "true") {
            finalScore = finalScore + 4;
          }
        }
      }

      totalScore = totalScore + 7;
      if (PreferenceUtils.getString(Utils.Battery_Sensor) != null) {
        if (PreferenceUtils.getString(Utils.Battery_Sensor) == "true") {
          finalScore = finalScore + 7;
        }
      }
      totalScore = totalScore + 4;
      if (PreferenceUtils.getString(Utils.Proximity_Sensor) != null) {
        if (PreferenceUtils.getString(Utils.Proximity_Sensor) == "true") {
          finalScore = finalScore + 4;
        }
      }
      totalScore = totalScore + 4;
      if (PreferenceUtils.getString(Utils.Gravity_Sensor) != null) {
        if (PreferenceUtils.getString(Utils.Gravity_Sensor) == "true") {
          finalScore = finalScore + 4;
        }
      }
      totalScore = totalScore + 4;
      if (PreferenceUtils.getString(Utils.Magnetic_Sensor) != null) {
        if (PreferenceUtils.getString(Utils.Magnetic_Sensor) == "true") {
          finalScore = finalScore + 4;
        }
      }

      if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "88") {
        totalScore = totalScore + 25;
        if (PreferenceUtils.getString(Utils.Display_) != null) {
          if (PreferenceUtils.getString(Utils.Display_) == "true") {
            finalScore = finalScore + 25;
          }
        }
      } else {
        totalScore = totalScore + 10;
        if (PreferenceUtils.getString(Utils.Display_) != null) {
          if (PreferenceUtils.getString(Utils.Display_) == "true") {
            finalScore = finalScore + 10;
          }
        }
      }
    }

    print('Total Score $totalScore');
    print('Final Score after Calculations $finalScore');
    percentage = (finalScore / totalScore) * 100;
    FinalPercentage = percentage.toInt();
    print('FinalPercentage  $FinalPercentage');
    PreferenceUtils.setString(Utils.TOTALScore, totalScore.toString());
    PreferenceUtils.setString(Utils.RATINGScore, finalScore.toString());

    if (FinalPercentage < 85) {
      setState(() {
        mimeitestStatus_ = true;
        buttonoptionvisible_ = true;
        buttonContinueVisibility_ = false;
        mSellorBynowOption();
      });
    } else {
      setState(() {
        mimeitestStatus_ = false;
        buttonoptionvisible_ = false;
        buttonContinueVisibility_ = true;
      });
    }
  }

  void mGetIOSRatingList() {
    if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "971" ||
        PreferenceUtils.getString(Utils.COUNTRY_ID) == "234") {
      if (PreferenceUtils.getString(Utils.FaceID_Sensor_Status) != null &&
          PreferenceUtils.getString(Utils.FaceID_Sensor_Status) == "true") {
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.vibration) != null) {
          if (PreferenceUtils.getString(Utils.vibration) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.sim) != null) {
          if (PreferenceUtils.getString(Utils.sim) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Speaker) != null) {
          if (PreferenceUtils.getString(Utils.Speaker) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Flash) != null) {
          if (PreferenceUtils.getString(Utils.Flash) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Headphone) != null) {
          if (PreferenceUtils.getString(Utils.Headphone) == "true") {
            finalScore = finalScore + 5;
          }
        }

        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Camera) != null) {
          if (PreferenceUtils.getString(Utils.Camera) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Front_Camera) != null) {
          if (PreferenceUtils.getString(Utils.Front_Camera) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Wifi) != null) {
          if (PreferenceUtils.getString(Utils.Wifi) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Bluetooth) != null) {
          if (PreferenceUtils.getString(Utils.Bluetooth) == "true") {
            finalScore = finalScore + 5;
          }
        }

//    if (PreferenceUtils.getString(Utils.Light_Sensor) != null) {
//      if (PreferenceUtils.getString(Utils.Light_Sensor) == "true") {
//        finalScore = finalScore + 5;
//      }
//    }
        totalScore = totalScore + 7;
        if (PreferenceUtils.getString(Utils.Battery_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Battery_Sensor) == "true") {
            finalScore = finalScore + 7;
          }
        }
        totalScore = totalScore + 3;
        if (PreferenceUtils.getString(Utils.Proximity_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Proximity_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }
        totalScore = totalScore + 3;

        if (PreferenceUtils.getString(Utils.Gravity_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Gravity_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }
        totalScore = totalScore + 3;
        if (PreferenceUtils.getString(Utils.Magnetic_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Magnetic_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }
        totalScore = totalScore + 10;
        if (PreferenceUtils.getString(Utils.FaceID_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.FaceID_Sensor) == "true") {
            finalScore = finalScore + 10;
          }
        }
        totalScore = totalScore + 10;
        if (PreferenceUtils.getString(Utils.Display_) != null) {
          if (PreferenceUtils.getString(Utils.Display_) == "true") {
            finalScore = finalScore + 10;
          }
        }
        totalScore = totalScore + 3;
        if (PreferenceUtils.getString(Utils.Location_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Location_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }

        totalScore = totalScore + 3;
        if (PreferenceUtils.getString(Utils.Barometer_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Barometer_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }

        totalScore = totalScore + 3;
        if (PreferenceUtils.getString(Utils.Accelerometer_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Accelerometer_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }
        totalScore = totalScore + 10;
        if (PreferenceUtils.getString(Utils.ScreenDamageSatatus) != null) {
          if (PreferenceUtils.getString(Utils.ScreenDamageSatatus) == "true") {
            finalScore = finalScore + 10;
          }
        }
        print('Total Score $totalScore');
        print('Final Score after Calculations $finalScore');
        percentage = (finalScore / totalScore) * 100;
        FinalPercentage = percentage.toInt();
        print('FinalPercentage  $FinalPercentage');

        PreferenceUtils.setString(Utils.RATINGScore, finalScore.toString());
        PreferenceUtils.setString(Utils.TOTALScore, totalScore.toString());
        setState(() {});
      } else {
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.vibration) != null) {
          if (PreferenceUtils.getString(Utils.vibration) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.sim) != null) {
          if (PreferenceUtils.getString(Utils.sim) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Speaker) != null) {
          if (PreferenceUtils.getString(Utils.Speaker) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Flash) != null) {
          if (PreferenceUtils.getString(Utils.Flash) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Headphone) != null) {
          if (PreferenceUtils.getString(Utils.Headphone) == "true") {
            finalScore = finalScore + 5;
          }
        }

        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Camera) != null) {
          if (PreferenceUtils.getString(Utils.Camera) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Front_Camera) != null) {
          if (PreferenceUtils.getString(Utils.Front_Camera) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Wifi) != null) {
          if (PreferenceUtils.getString(Utils.Wifi) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Bluetooth) != null) {
          if (PreferenceUtils.getString(Utils.Bluetooth) == "true") {
            finalScore = finalScore + 5;
          }
        }

//    if (PreferenceUtils.getString(Utils.Light_Sensor) != null) {
//      if (PreferenceUtils.getString(Utils.Light_Sensor) == "true") {
//        finalScore = finalScore + 5;
//      }
//    }
        totalScore = totalScore + 7;
        if (PreferenceUtils.getString(Utils.Battery_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Battery_Sensor) == "true") {
            finalScore = finalScore + 7;
          }
        }
        totalScore = totalScore + 3;
        if (PreferenceUtils.getString(Utils.Proximity_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Proximity_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }
        totalScore = totalScore + 3;

        if (PreferenceUtils.getString(Utils.Gravity_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Gravity_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }
        totalScore = totalScore + 3;
        if (PreferenceUtils.getString(Utils.Magnetic_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Magnetic_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }
        totalScore = totalScore + 10;
        if (PreferenceUtils.getString(Utils.Display_) != null) {
          if (PreferenceUtils.getString(Utils.Display_) == "true") {
            finalScore = finalScore + 10;
          }
        }
        totalScore = totalScore + 3;
        if (PreferenceUtils.getString(Utils.Location_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Location_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }

        totalScore = totalScore + 3;
        if (PreferenceUtils.getString(Utils.Barometer_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Barometer_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }

        totalScore = totalScore + 3;
        if (PreferenceUtils.getString(Utils.Accelerometer_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Accelerometer_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }
        totalScore = totalScore + 10;
        if (PreferenceUtils.getString(Utils.ScreenDamageSatatus) != null) {
          if (PreferenceUtils.getString(Utils.ScreenDamageSatatus) == "true") {
            finalScore = finalScore + 10;
          }
        }

        totalScore = totalScore + 10;
        if (PreferenceUtils.getString(Utils.Fringerprint_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Fringerprint_Sensor) == "true") {
            finalScore = finalScore + 10;
          }
        }

        print('Total Score $totalScore');
        print('Final Score after Calculations $finalScore');
        percentage = (finalScore / totalScore) * 100;
        FinalPercentage = percentage.toInt();
        print('FinalPercentage  $FinalPercentage');
        PreferenceUtils.setString(Utils.RATINGScore, finalScore.toString());
        PreferenceUtils.setString(Utils.TOTALScore, totalScore.toString());
        setState(() {});
      }
    } else {
      if (PreferenceUtils.getString(Utils.FaceID_Sensor_Status) != null &&
          PreferenceUtils.getString(Utils.FaceID_Sensor_Status) == "true") {
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.vibration) != null) {
          if (PreferenceUtils.getString(Utils.vibration) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.sim) != null) {
          if (PreferenceUtils.getString(Utils.sim) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Speaker) != null) {
          if (PreferenceUtils.getString(Utils.Speaker) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Flash) != null) {
          if (PreferenceUtils.getString(Utils.Flash) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Headphone) != null) {
          if (PreferenceUtils.getString(Utils.Headphone) == "true") {
            finalScore = finalScore + 5;
          }
        }

        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Camera) != null) {
          if (PreferenceUtils.getString(Utils.Camera) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Front_Camera) != null) {
          if (PreferenceUtils.getString(Utils.Front_Camera) == "true") {
            finalScore = finalScore + 5;
          }
        }

        if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "88") {
        } else {
          totalScore = totalScore + 5;
          if (PreferenceUtils.getString(Utils.Wifi) != null) {
            if (PreferenceUtils.getString(Utils.Wifi) == "true") {
              finalScore = finalScore + 5;
            }
          }
        }

        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Bluetooth) != null) {
          if (PreferenceUtils.getString(Utils.Bluetooth) == "true") {
            finalScore = finalScore + 5;
          }
        }

//    if (PreferenceUtils.getString(Utils.Light_Sensor) != null) {
//      if (PreferenceUtils.getString(Utils.Light_Sensor) == "true") {
//        finalScore = finalScore + 5;
//      }
//    }
        totalScore = totalScore + 7;
        if (PreferenceUtils.getString(Utils.Battery_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Battery_Sensor) == "true") {
            finalScore = finalScore + 7;
          }
        }
        totalScore = totalScore + 3;
        if (PreferenceUtils.getString(Utils.Proximity_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Proximity_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }
        totalScore = totalScore + 3;

        if (PreferenceUtils.getString(Utils.Gravity_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Gravity_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }
        totalScore = totalScore + 3;
        if (PreferenceUtils.getString(Utils.Magnetic_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Magnetic_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }
        totalScore = totalScore + 10;
        if (PreferenceUtils.getString(Utils.FaceID_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.FaceID_Sensor) == "true") {
            finalScore = finalScore + 10;
          }
        }
        totalScore = totalScore + 10;
        if (PreferenceUtils.getString(Utils.Display_) != null) {
          if (PreferenceUtils.getString(Utils.Display_) == "true") {
            finalScore = finalScore + 10;
          }
        }
        totalScore = totalScore + 3;
        if (PreferenceUtils.getString(Utils.Location_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Location_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }

        totalScore = totalScore + 3;
        if (PreferenceUtils.getString(Utils.Barometer_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Barometer_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }

        totalScore = totalScore + 3;
        if (PreferenceUtils.getString(Utils.Accelerometer_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Accelerometer_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }
//        totalScore = totalScore + 10;
//        if (PreferenceUtils.getString(Utils.ScreenDamageSatatus) != null) {
//          if (PreferenceUtils.getString(Utils.ScreenDamageSatatus) == "true") {
//            finalScore = finalScore + 10;
//          }
//        }

        print('Total Score $totalScore');
        print('Final Score after Calculations $finalScore');
        percentage = (finalScore / totalScore) * 100;
        FinalPercentage = percentage.toInt();
        print('FinalPercentage  $FinalPercentage');

        PreferenceUtils.setString(Utils.RATINGScore, finalScore.toString());
        PreferenceUtils.setString(Utils.TOTALScore, totalScore.toString());
        setState(() {});
      } else {
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.vibration) != null) {
          if (PreferenceUtils.getString(Utils.vibration) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.sim) != null) {
          if (PreferenceUtils.getString(Utils.sim) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Speaker) != null) {
          if (PreferenceUtils.getString(Utils.Speaker) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Flash) != null) {
          if (PreferenceUtils.getString(Utils.Flash) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Headphone) != null) {
          if (PreferenceUtils.getString(Utils.Headphone) == "true") {
            finalScore = finalScore + 5;
          }
        }

        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Camera) != null) {
          if (PreferenceUtils.getString(Utils.Camera) == "true") {
            finalScore = finalScore + 5;
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Front_Camera) != null) {
          if (PreferenceUtils.getString(Utils.Front_Camera) == "true") {
            finalScore = finalScore + 5;
          }
        }
        if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "88") {
        } else {
          totalScore = totalScore + 5;
          if (PreferenceUtils.getString(Utils.Wifi) != null) {
            if (PreferenceUtils.getString(Utils.Wifi) == "true") {
              finalScore = finalScore + 5;
            }
          }
        }
        totalScore = totalScore + 5;
        if (PreferenceUtils.getString(Utils.Bluetooth) != null) {
          if (PreferenceUtils.getString(Utils.Bluetooth) == "true") {
            finalScore = finalScore + 5;
          }
        }

//    if (PreferenceUtils.getString(Utils.Light_Sensor) != null) {
//      if (PreferenceUtils.getString(Utils.Light_Sensor) == "true") {
//        finalScore = finalScore + 5;
//      }
//    }
        totalScore = totalScore + 7;
        if (PreferenceUtils.getString(Utils.Battery_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Battery_Sensor) == "true") {
            finalScore = finalScore + 7;
          }
        }
        totalScore = totalScore + 3;
        if (PreferenceUtils.getString(Utils.Proximity_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Proximity_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }
        totalScore = totalScore + 3;

        if (PreferenceUtils.getString(Utils.Gravity_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Gravity_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }
        totalScore = totalScore + 3;
        if (PreferenceUtils.getString(Utils.Magnetic_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Magnetic_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }

        totalScore = totalScore + 10;
        if (PreferenceUtils.getString(Utils.Display_) != null) {
          if (PreferenceUtils.getString(Utils.Display_) == "true") {
            finalScore = finalScore + 10;
          }
        }
        totalScore = totalScore + 3;
        if (PreferenceUtils.getString(Utils.Location_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Location_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }

        totalScore = totalScore + 3;
        if (PreferenceUtils.getString(Utils.Barometer_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Barometer_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }

        totalScore = totalScore + 3;
        if (PreferenceUtils.getString(Utils.Accelerometer_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Accelerometer_Sensor) == "true") {
            finalScore = finalScore + 3;
          }
        }

        totalScore = totalScore + 10;
        if (PreferenceUtils.getString(Utils.Fringerprint_Sensor) != null) {
          if (PreferenceUtils.getString(Utils.Fringerprint_Sensor) == "true") {
            finalScore = finalScore + 10;
          }
        }

//        totalScore = totalScore + 10;
//        if (PreferenceUtils.getString(Utils.ScreenDamageSatatus) != null) {
//          if (PreferenceUtils.getString(Utils.ScreenDamageSatatus) == "true") {
//            finalScore = finalScore + 10;
//          }
//        }

        print('Total Score $totalScore');
        print('Final Score after Calculations $finalScore');
        percentage = (finalScore / totalScore) * 100;
        FinalPercentage = percentage.toInt();
        print('FinalPercentage  $FinalPercentage');
        PreferenceUtils.setString(Utils.RATINGScore, finalScore.toString());
        PreferenceUtils.setString(Utils.TOTALScore, totalScore.toString());
      }
    }
    if (FinalPercentage < 85) {
      mimeitestStatus_ = true;
      buttonoptionvisible_ = true;
      buttonContinueVisibility_ = false;
      mSellorBynowOption();
    } else {
      mimeitestStatus_ = false;
      buttonoptionvisible_ = false;
      buttonContinueVisibility_ = true;
    }
    setState(() {});
  }

  int calc_ranks(ranks) {
    double multiplier = .5;
    return (multiplier * ranks).round();
  }

  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

  void mDialogSuccess(String title, String Discription) {
    SweetAlert.show(context,
        title: title, subtitle: Discription, style: SweetAlertStyle.success);
  }

  void mSellorBynowOption() {
    var packageName = PreferenceUtils.getString(Utils.appPackageName);
    print('packageName ==== $packageName');

    if (packageName == "com.r3factory".trim() ||
        packageName == "com.insurance.altruistSecureR3".trim() ||
        packageName == "com.app.noon_secure".trim() ||
        packageName == "com.insurance.noonSecure".trim()) {
      setState(() {
        sellVisibilty_ = true;
        repairVisibilty_ = true;
      });
    } else {
      sellVisibilty_ = false;
      repairVisibilty_ = false;
    }
  }

  void mMandSecureRating() {
    totalScore = totalScore + 25;
    if (PreferenceUtils.getString(Utils.Camera) != null) {
      if (PreferenceUtils.getString(Utils.Camera) == "true") {
        finalScore = finalScore + 25;
      }
    }
    totalScore = totalScore + 25;
    if (PreferenceUtils.getString(Utils.Front_Camera) != null) {
      if (PreferenceUtils.getString(Utils.Front_Camera) == "true") {
        finalScore = finalScore + 25;
      }
    }

    totalScore = totalScore + 25;
    if (PreferenceUtils.getString(Utils.Display_) != null) {
      if (PreferenceUtils.getString(Utils.Display_) == "true") {
        finalScore = finalScore + 25;
      }
    }

    totalScore = totalScore + 25;
    if (PreferenceUtils.getString(Utils.ScreenDamageSatatus) != null) {
      if (PreferenceUtils.getString(Utils.ScreenDamageSatatus) == "true") {
        finalScore = finalScore + 25;
      }
    }

    print('Total Score $totalScore');
    print('Final Score after Calculations $finalScore');
    percentage = (finalScore / totalScore) * 100;
    FinalPercentage = percentage.toInt();
    print('FinalPercentage  $FinalPercentage');
    PreferenceUtils.setString(Utils.RATINGScore, finalScore.toString());
    PreferenceUtils.setString(Utils.TOTALScore, totalScore.toString());
    setState(() {});

    if (FinalPercentage < 85) {
      setState(() {
        buttonContinueVisibility_ = false;
      });
    } else {
      setState(() {
        buttonContinueVisibility_ = true;
      });
    }
  }

  void mContinueClick() {
//    if(PreferenceUtils.getString(Utils.appPackageName) == "com.app.altruists_secure_bangla"){
//
//
//
//      return;
//    }
    if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "88") {
      if (FinalPercentage >= 80) {
        diagnosResultDetailsList = [];
        for (var i = 0; i < assignLsit.length; i++) {
          for (var j = 0; j < diagnosticsList.length; j++) {
            if (diagnosticsList[j].diagnosTechName ==
                assignLsit[i].displayName) {
              if (assignLsit[i].status == "true") {
                diagnosResultDetailsList.add(DiagnosResultDetail(
                    diagnosId: diagnosticsList[j].id,
                    diagnosTechName: diagnosticsList[j].diagnosTechName,
                    score: diagnosticsList[j].maxScore));
              } else {
                diagnosResultDetailsList.add(DiagnosResultDetail(
                    diagnosId: diagnosticsList[j].id,
                    diagnosTechName: diagnosticsList[j].diagnosTechName,
                    score: diagnosticsList[j].minScore));
              }
            }
          }
        }
        var saveDiagnoseRequestModel = SaveDiagnoseRequestModel(
            userId: PreferenceUtils.getString(Utils.USER_ID),
            source: StringConstants.SOURCE,
            diagnosResult: DiagnosResult(
                deviceOs: deviceOS,
                imieNumber: id,
                deviceModel: deviceModel,
                deviceName: deviceName,
                appVersion: "1.0",
                score: finalScore),
            diagnosResultDetails: diagnosResultDetailsList);
        _bloc.add(SaveDiagnosedApplistClickEvent(
            saveDiagnoseRequestModel: saveDiagnoseRequestModel));
      } else {
        mToast("Test Score must be minimum 80%");
      }
    } else {
      if (FinalPercentage >= 85) {
        diagnosResultDetailsList = [];
        for (var i = 0; i < assignLsit.length; i++) {
          for (var j = 0; j < diagnosticsList.length; j++) {
            if (diagnosticsList[j].diagnosTechName ==
                assignLsit[i].displayName) {
              if (assignLsit[i].status == "true") {
                diagnosResultDetailsList.add(DiagnosResultDetail(
                    diagnosId: diagnosticsList[j].id,
                    diagnosTechName: diagnosticsList[j].diagnosTechName,
                    score: diagnosticsList[j].maxScore));
              } else {
                diagnosResultDetailsList.add(DiagnosResultDetail(
                    diagnosId: diagnosticsList[j].id,
                    diagnosTechName: diagnosticsList[j].diagnosTechName,
                    score: diagnosticsList[j].minScore));
              }
            }
          }
        }
        var saveDiagnoseRequestModel = SaveDiagnoseRequestModel(
            userId: PreferenceUtils.getString(Utils.USER_ID),
            source: StringConstants.SOURCE,
            diagnosResult: DiagnosResult(
                deviceOs: deviceOS,
                imieNumber: id,
                deviceModel: deviceModel,
                deviceName: deviceName,
                appVersion: "1.0",
                score: finalScore),
            diagnosResultDetails: diagnosResultDetailsList);
        _bloc.add(SaveDiagnosedApplistClickEvent(
            saveDiagnoseRequestModel: saveDiagnoseRequestModel));
      } else {
        mToast("Test Score must be minimum 85%");
      }
    }
  }
}
