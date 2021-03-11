import 'package:altruist_secure_flutter/DisplayTest/UI/display_test.dart';
import 'package:altruist_secure_flutter/IosSensorlist/UI/iosSensorList.dart';
import 'package:altruist_secure_flutter/ScreenGlass&IMEIInstructionPage/ScreenGlassImeiInstructionPage.dart';
import 'package:altruist_secure_flutter/ScreenGlassImageDisplayAndUpload/screen_glass_display_upload_presenter.dart';
import 'package:altruist_secure_flutter/ScreenGlassTest/screenglasstest.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/WifiTest/UI/wifi_test.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'dart:io' show Platform;

class SenSorTest2 extends StatefulWidget {
  @override
  SenSorTestClass2_ createState() => SenSorTestClass2_();
}

class SenSorTestClass2_ extends State<SenSorTest2> {
  static const platform =
      const MethodChannel('samples.flutter.dev/battery/vibration_test');
  ProgressDialog pr;
  var mIntent;

  bool mFacelockAvalibility = false;

  bool facelock_progress_visible = false;
  bool facelock_true_status = false;
  bool facelock_false_status = false;
  bool facelock_status = false;
  var mTextStatus_facelock = TextEditingController();

  bool gravity_progress_visible = false;
  bool gravity_true_status = false;
  bool gravity_false_status = false;

  bool magnetic_progress_visible = false;
  bool magnetic_true_status = false;
  bool magnetic_false_status = false;

  bool resultText_status_gravity = false;
  var mTextStatus_gravity = TextEditingController();

  bool resultText_status_magnetic = false;
  var mTextStatus_magnetic = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      var packageName = PreferenceUtils.getString(Utils.appPackageName);
      var countryCode = PreferenceUtils.getString(Utils.COUNTRY_ID);
      print('packageName ==== $packageName');
      print('CountryCode ==== $countryCode');
      if (packageName == "com.insurance.atpl.altruist_secure_flutter" ||
          packageName == "com.insurance.altruistSecureFlutter") {
        if (countryCode == "234") {
       //   mIntent = ScreenGlassImeiInstructionPage();
          mIntent = ScreenGlassTest();
        } else {
          mIntent = DisplayTest();
        }
      }else if(packageName =="com.app.altruists_secure_bangla".trim() || packageName == "com.app.altruists-secure-bangla") {
        mIntent = DisplayTest();
      }else {
        mIntent = ScreenGlassImeiInstructionPage();
      }
     // mIntent = ScreenGlassImeiInstructionPage();
    } else if (Platform.isIOS) {
      // iOS-specific code
      mIntent = SenSorIos();
      mFacelockAvalibility = true;
      setState(() {});
    }
    pr = ProgressDialog(context);
    loadProgress("gravity");
    Future.delayed(const Duration(milliseconds: 1000), () {
      _getgravitySensorTest();
    });
  }

  Future<void> _getfacelockSensorTest() async {
    try {
      // platform.setMethodCallHandler(_handleCallback);
      final bool result = await platform.invokeMethod('facelock_sensor_ios');
      if (result == true) {
        print(result);
        gravity_true_status = true;
        //  mToast("Gravity Sensor Working Fine");
        mSuccessGravity_SensorSharedPref();
      } else {
        gravity_false_status = true;
        //   mToast("Gravity Sensor  Not Working ");
        mFailGravity_SensorSharedPref();
      }
    } on PlatformException catch (e) {}

    Future.delayed(const Duration(milliseconds: 1000), () {
      loadProgress("gravity");
    });
  }

  Future<void> _getgravitySensorTest() async {
    try {
      // platform.setMethodCallHandler(_handleCallback);
      final bool result = await platform.invokeMethod('gravity_test');
      if (result == true) {
        print(result);
        gravity_true_status = true;
        //  mToast("Gravity Sensor Working Fine");
        mSuccessGravity_SensorSharedPref();
      } else {
        gravity_false_status = true;
        //   mToast("Gravity Sensor  Not Working ");
        mFailGravity_SensorSharedPref();
      }
    } on PlatformException catch (e) {}

    Future.delayed(const Duration(milliseconds: 1000), () {
      loadProgress("gravity");
    });
  }

  Future<void> _getMegnaticTest() async {
    try {
      //  platform.setMethodCallHandler(_handleCallback);
      final bool result = await platform.invokeMethod('magnetic_test');
      if (result == true) {
        print(result);
        mSuccessMagnetic_SensorSharedPref();
        megnaticeRe(true);
      } else {
        mFailMagnetic_SensorSharedPref();
        megnaticeRe(false);
      }
    } on PlatformException catch (e) {}
  }

  void megnaticeRe(bool result) {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (result == true) {
        magnetic_true_status = true;
      } else {
        magnetic_false_status = true;
      }
      loadProgress("magnetic");
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Sensors Test';
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor:ColorConstant.AppBarColor,
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: new TextStyle(
                fontSize: 17, color:ColorConstant.TextColor, fontFamily: 'OpenSans'),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 15),
              new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 15),
                  Text(
                    "Gravity Test",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: 'OpenSans'),
                  ),
                  SizedBox(height: 30),
                  Column(
                    children: <Widget>[
                      Visibility(
                          maintainAnimation: true,
                          maintainState: true,
                          visible: gravity_progress_visible,
                          child: Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            child: SizedBox(
                              child: CircularProgressIndicator(),
                              height: 50.0,
                              width: 50.0,
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                          visible: gravity_true_status,
                          maintainState: true,
                          child: Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            child: Image.asset(
                              'assets/progresstrue.png',
                              height: 60,
                              width: 60,
                            ),
                          )),
                      Visibility(
                          visible: gravity_false_status,
                          maintainState: true,
                          child: Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            child: Image.asset(
                              'assets/progressfalse.png',
                              height: 60,
                              width: 60,
                            ),
                          )),
                      Visibility(
                        visible: resultText_status_gravity,
                        maintainState: true,
                        child: new Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 0, bottom: 10),
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontFamily: 'OpenSans'),
                              decoration: new InputDecoration.collapsed(
                                border: InputBorder.none,
                              ),
                              controller: mTextStatus_gravity,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 15),
              Divider(
                color: Colors.black,
              ),
              new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 15),
                  Text(
                    "Magnetic Test",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: 'OpenSans'),
                  ),
                  SizedBox(height: 30),
                  Column(
                    children: <Widget>[
                      Visibility(
                          maintainAnimation: true,
                          maintainState: true,
                          visible: magnetic_progress_visible,
                          child: Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            child: SizedBox(
                              child: CircularProgressIndicator(),
                              height: 50.0,
                              width: 50.0,
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                          visible: magnetic_true_status,
                          maintainState: true,
                          child: Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            child: Image.asset(
                              'assets/progresstrue.png',
                              height: 60,
                              width: 60,
                            ),
                          )),
                      Visibility(
                          visible: magnetic_false_status,
                          maintainState: true,
                          child: Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            child: Image.asset(
                              'assets/progressfalse.png',
                              height: 60,
                              width: 60,
                            ),
                          )),
                      Visibility(
                        visible: resultText_status_magnetic,
                        maintainState: true,
                        child: new Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 0, bottom: 10),
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontFamily: 'OpenSans'),
                              decoration: new InputDecoration.collapsed(
                                border: InputBorder.none,
                              ),
                              controller: mTextStatus_magnetic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 15),
              Divider(
                color: Colors.black,
              ),
              new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 15),
                  Visibility(
                    visible: facelock_status,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Facelock Test",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: 'OpenSans'),
                        ),
                        SizedBox(height: 30),
                        Visibility(
                            maintainAnimation: true,
                            maintainState: true,
                            visible: facelock_progress_visible,
                            child: Container(
                              margin: EdgeInsets.only(top: 5, bottom: 5),
                              child: SizedBox(
                                child: CircularProgressIndicator(),
                                height: 50.0,
                                width: 50.0,
                              ),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                            visible: facelock_true_status,
                            maintainState: true,
                            child: Container(
                              margin: EdgeInsets.only(top: 5, bottom: 5),
                              child: Image.asset(
                                'assets/progresstrue.png',
                                height: 60,
                                width: 60,
                              ),
                            )),
                        Visibility(
                            visible: facelock_false_status,
                            maintainState: true,
                            child: Container(
                              margin: EdgeInsets.only(top: 5, bottom: 5),
                              child: Image.asset(
                                'assets/progressfalse.png',
                                height: 60,
                                width: 60,
                              ),
                            )),
                        Visibility(
                          visible: resultText_status_magnetic,
                          maintainState: true,
                          child: new Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 0, bottom: 10),
                              child: TextField(
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                    fontFamily: 'OpenSans'),
                                decoration: new InputDecoration.collapsed(
                                  border: InputBorder.none,
                                ),
                                controller: mTextStatus_magnetic,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

  void mSuccessGravity_SensorSharedPref() {
    PreferenceUtils.setString(Utils.Gravity_Sensor, "true");
    EventTracker.logEvent("GRAVITY_SENSOR_TEST_VERIFIED");
  }

  // ignore: non_constant_identifier_names
  void mFailGravity_SensorSharedPref() {
    PreferenceUtils.setString(Utils.Gravity_Sensor, "false");
    EventTracker.logEvent("GRAVITY_SENSOR_TEST_FAILED");
  }

  void mSuccessMagnetic_SensorSharedPref() {
    PreferenceUtils.setString(Utils.Magnetic_Sensor, "true");
    EventTracker.logEvent("MAGNETIC_SENSOR_TEST_VERIFIED");
  }

  // ignore: non_constant_identifier_names
  void mFailMagnetic_SensorSharedPref() {
    PreferenceUtils.setString(Utils.Magnetic_Sensor, "false");
    EventTracker.logEvent("MAGNETIC_SENSOR_TEST_FAILED");
  }

  loadProgress(String tagCaseName) {
    if (tagCaseName.trim() == "gravity") {
      if (gravity_progress_visible == true) {
        setState(() {
          gravity_progress_visible = false;
          resultText_status_gravity = true;
          if (gravity_true_status == true) {
            gravity_true_status = true;
            gravity_false_status = false;
            mTextStatus_gravity.text = Utils.TestSuccessfull;
          } else {
            gravity_true_status = false;
            gravity_false_status = true;
            mTextStatus_gravity.text = Utils.Testfailed;
          }
          Future.delayed(const Duration(milliseconds: 1000), () {
            loadProgress("magnetic");
            _getMegnaticTest();
          });
          //  false_status = false;
        });
      } else {
        setState(() {
          gravity_progress_visible = true;
        });
      }
    } else if (tagCaseName.trim() == "magnetic") {
      if (magnetic_progress_visible == true) {
        setState(() {
          magnetic_progress_visible = false;
          resultText_status_magnetic = true;
          if (magnetic_true_status == true) {
            magnetic_true_status = true;
            magnetic_false_status = false;
            mTextStatus_magnetic.text = Utils.TestSuccessfull;
          } else {
            magnetic_true_status = false;
            magnetic_false_status = true;
            mTextStatus_magnetic.text = Utils.Testfailed;
          }
          setState(() {
            Future.delayed(const Duration(milliseconds: 2000), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => mIntent,
                ),
              );
            });
          });
          //  false_status = false;
        });
      } else {
        setState(() {
          magnetic_progress_visible = true;
        });
      }
    }
  }
}
