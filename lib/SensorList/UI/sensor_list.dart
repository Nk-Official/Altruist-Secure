import 'package:altruist_secure_flutter/DisplayTest/UI/display_test.dart';
import 'package:altruist_secure_flutter/SenSorList2/UI/sensor_list2.dart';
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
import 'dart:async';

class SenSorTest extends StatefulWidget {
  @override
  SenSorTestClass_ createState() => SenSorTestClass_();
}

class SenSorTestClass_ extends State<SenSorTest> {
  static const platform =
      const MethodChannel('samples.flutter.dev/battery/vibration_test');
  var mLightSensorVisibilty = false;
  var accelerometerVisibility = false;

  bool light_progress_visible = false;
  bool light_true_status = false;
  bool light_false_status = false;
  bool light_SensorSatus = false;

  bool battery_progress_visible = false;
  bool battery_true_status = false;
  bool battery_false_status = false;

  bool proximity_progress_visible = false;
  bool proximity_true_status = false;
  bool proximity_false_status = false;

  bool accelerometer_progress_visible = false;
  bool accelerometer_true_status = false;
  bool accelerometer_false_status = false;

  bool resultText_status_light = false;
  var mTextStatus_light = TextEditingController();

  bool resultText_status_battery = false;
  var mTextStatus_battery = TextEditingController();

  bool resultText_status_proximity = false;
  var mTextStatus_proximity = TextEditingController();

  bool resultText_status_accelerometer = false;
  var mTextStatus_accelerometer = TextEditingController();

  @override
  void initState() {
    super.initState();
    // pr = ProgressDialog(context);
    PreferenceUtils.init();
    if (Platform.isAndroid) {
      // Android-specific code
      accelerometerVisibility = false;
      mLightSensorVisibilty = true;
      loadProgress("Light");
      Future.delayed(const Duration(milliseconds: 1000), () {
        _getSensorTest();
      });
    } else if (Platform.isIOS) {
      // iOS-specific code
      loadProgress("accelerometer");
      mLightSensorVisibilty = false;
      accelerometerVisibility = true;
      Future.delayed(const Duration(milliseconds: 1000), () {
        _getAccelerometeTest();
      });
    }
  }

  Future<void> _getSensorTest() async {
    try {
      final bool result = await platform.invokeMethod('lightsensor_test');
      if (result == true) {
        light_true_status = true;
        print(result);
        mSuccessLight_SensorSharedPref();
        // =("Light Sensor Working Fine");
      } else {
        // light_false_status = true;
        mFailLight_SensorSharedPref();
        //   mToast(result.toString());
      }
      Future.delayed(const Duration(milliseconds: 2000), () {
        loadProgress("Light");
      });
    } on PlatformException catch (e) {}
  }

  Future<void> _getAccelerometeTest() async {
    try {
      // platform.setMethodCallHandler(_handleCallback);
      final bool result =
      await platform.invokeMethod('accelerometer_sensor_ios');
      if (result == true) {
        print(result);
        mSuccessAccelerometer_SensorSharedPref();
        accelerometer_true_status = true;
      } else {
        mFailAccelerometer_SensorSharedPref();
        accelerometer_false_status = true;
        //    mToast(result.toString());
      }
    } on PlatformException catch (e) {}
    Future.delayed(const Duration(milliseconds: 2000), () {
      loadProgress("accelerometer");
    });
  }

  Future<void> _getbatteryTest() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
      mSuccessBattery_SensorSharedPref();
      mBattery(true);
      //  mToast(batteryLevel);
    } on PlatformException catch (e) {
      mFailBattery_SensorSharedPref();
      batteryLevel = "Failed to get battery level: '${e.message}'.";
      mBattery(false);
      //     mToast(e.message);
    }
  }

  void mBattery(bool val) {
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (val == true) {
        battery_true_status = true;
      } else {
        battery_false_status = true;
      }
      loadProgress("Battery");
    });
  }

  Future<void> _getProximity() async {
    try {
      //  platform.setMethodCallHandler(_handleCallback);
      final bool result = await platform.invokeMethod('proximity_test');
      if (result == true) {
        print(result);
        mSuccessProximity_SensorSharedPref();
        // mToast("Proximity Sensor Working");
      //  proximity_true_status = true;
        mproxity(true);
      } else {
     //   proximity_false_status = true;
        mFailProximity_SensorSharedPref();
        mproxity(false);
        // mToast("Proximity Sensor  Not Working");
      }
    } on PlatformException catch (e) {}
  }

  void mproxity(bool val) {
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (val == true) {
        proximity_true_status = true;
      } else {
        proximity_false_status = true;
      }
      loadProgress("proximity");
    });
  }


  @override
  Widget build(BuildContext context) {
    final title = 'Sensors Test';
    return (Scaffold(
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
            ///////////////////Light Test////////////////////////
            new Visibility(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 15),
                  Text(
                    "Light Test",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: 'OpenSans'),
                  ),
                  SizedBox(height: 30),
//                Image.asset('altruist_logo.png',
//                    height: 100, width: 100, alignment: Alignment.center),
                  Column(
                    children: <Widget>[
                      Visibility(
                          maintainAnimation: true,
                          maintainState: true,
                          visible: light_progress_visible,
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
                        visible: light_SensorSatus,
                        maintainState: true,
                        child: Text(
                          "Light Sensor Not Found",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: 'OpenSans'),
                        ),
                      ),
                      Visibility(
                          visible: light_true_status,
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
                          visible: light_false_status,
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
                        visible: resultText_status_light,
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
                              controller: mTextStatus_light,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              visible: mLightSensorVisibilty,
            ),
            new Visibility(
              child: Divider(
                color: Colors.black,
              ),
              visible: mLightSensorVisibilty,
            ),
            ///////////////////Accelerometer Test////////////////////////
            new Visibility(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 15),
                  Text(
                    "Accelerometer Test",
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
                          visible: accelerometer_progress_visible,
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
                          visible: accelerometer_true_status,
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
                          visible: accelerometer_false_status,
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
                        visible: resultText_status_accelerometer,
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
                              controller: mTextStatus_accelerometer,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              visible: accelerometerVisibility,
            ),
            new Visibility(
              child: Divider(
                color: Colors.black,
              ),
              visible: accelerometerVisibility,
            ),
            SizedBox(height: 15),

            ///////////////////Battery Test////////////////////////
            new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 15),
                Text(
                  "Battery Test",
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
                        visible: battery_progress_visible,
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
                        visible: battery_true_status,
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
                        visible: battery_false_status,
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
                      visible: resultText_status_battery,
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
                            controller: mTextStatus_battery,
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

            ///////////////////Proximity Test////////////////////////
            new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 15),
                Text(
                  "Proximity Test",
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
                        visible: proximity_progress_visible,
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
                        visible: proximity_true_status,
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
                        visible: proximity_false_status,
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
                      visible: resultText_status_proximity,
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
                            controller: mTextStatus_proximity,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }

  loadProgress(String tagCaseName) {
    if (tagCaseName.trim() == "Light") {
      if (light_progress_visible == true) {
        setState(() {
          resultText_status_light = true;
          light_progress_visible = false;
          if (light_true_status == true) {
            mTextStatus_light.text = Utils.TestSuccessfull;
            light_true_status = true;
            light_false_status = false;
            light_SensorSatus = false;
          } else {
            light_true_status = false;
            //light_false_status = true;
            light_SensorSatus = true;
            mTextStatus_light.text = Utils.Testfailed;
          }
          Future.delayed(const Duration(milliseconds: 1000), () {
            loadProgress("Battery");
            _getbatteryTest();
          });
          //  false_status = false;
        });
      } else {
        setState(() {
          light_progress_visible = true;
        });
      }
    } else if (tagCaseName.trim() == "accelerometer") {
      if (accelerometer_progress_visible == true) {
        setState(() {
          accelerometer_progress_visible = false;
          resultText_status_accelerometer = true;
          if (accelerometer_true_status == true) {
            accelerometer_true_status = true;
            accelerometer_false_status = false;
            mTextStatus_accelerometer.text = Utils.TestSuccessfull;
          } else {
            accelerometer_true_status = false;
            accelerometer_false_status = true;
            mTextStatus_accelerometer.text = Utils.Testfailed;
          }
          Future.delayed(const Duration(milliseconds: 1000), () {
            loadProgress("Battery");
            _getbatteryTest();
          });
          //  false_status = false;
        });
      } else {
        setState(() {
          accelerometer_progress_visible = true;
        });
      }
    } else if (tagCaseName.trim() == "Battery") {
      if (battery_progress_visible == true) {
        setState(() {
          battery_progress_visible = false;
          resultText_status_battery = true;
          if (battery_true_status == true) {
            battery_true_status = true;
            battery_false_status = false;
            mTextStatus_battery.text = Utils.TestSuccessfull;
          } else {
            battery_true_status = false;
            battery_false_status = true;
            mTextStatus_battery.text = Utils.Testfailed;
          }
          Future.delayed(const Duration(milliseconds: 1000), () {
            loadProgress("proximity");
            _getProximity();
          });
          //  false_status = false;
        });
      } else {
        setState(() {
          battery_progress_visible = true;
        });
      }
    } else if (tagCaseName.trim() == "proximity") {
      if (proximity_progress_visible == true) {
        setState(() {
          proximity_progress_visible = false;
          resultText_status_proximity = true;
          if (proximity_true_status == true) {
            proximity_true_status = true;
            proximity_false_status = false;
            mTextStatus_proximity.text = Utils.TestSuccessfull;
          } else {
            proximity_true_status = false;
            proximity_false_status = true;
            mTextStatus_proximity.text = Utils.Testfailed;
          }
          Future.delayed(const Duration(milliseconds: 1000), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SenSorTest2(),
                  settings: RouteSettings(name: 'SenSorTest2')),
            );
          });
        });
      } else {
        setState(() {
          proximity_progress_visible = true;
        });
      }
    }
  }

  void mSuccessLight_SensorSharedPref() {
    PreferenceUtils.setString(Utils.Light_Sensor, "true");
    EventTracker.logEvent("LIGHT_SENSOR_VERIFIED");
  }

  void mFailLight_SensorSharedPref() {
    PreferenceUtils.setString(Utils.Light_Sensor, "false");
    EventTracker.logEvent("LIGHT_SENSOR_FAILED");
  }

  void mSuccessAccelerometer_SensorSharedPref() {
    PreferenceUtils.setString(Utils.Accelerometer_Sensor, "true");
    EventTracker.logEvent("ACCELEROMETER_SENSOR_VERIFIED");
  }

  void mFailAccelerometer_SensorSharedPref() {
    PreferenceUtils.setString(Utils.Accelerometer_Sensor, "false");
    EventTracker.logEvent("ACCELEROMETER_SENSOR_FAILED");
  }

  void mSuccessBattery_SensorSharedPref() {
    PreferenceUtils.setString(Utils.Battery_Sensor, "true");
    EventTracker.logEvent("BATTERY_TEST_VERIFIED");
  }

  void mFailBattery_SensorSharedPref() {
    PreferenceUtils.setString(Utils.Battery_Sensor, "false");
    EventTracker.logEvent("BATTERY_TEST_FAILED");
  }

  void mSuccessProximity_SensorSharedPref() {
    PreferenceUtils.setString(Utils.Proximity_Sensor, "true");
    EventTracker.logEvent("PROXIMITY_SENSOR_VERIFIED");
  }

  void mFailProximity_SensorSharedPref() {
    PreferenceUtils.setString(Utils.Proximity_Sensor, "false");
    EventTracker.logEvent("PROXIMITY_SENSOR_FAILED");
  }

  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }
}
