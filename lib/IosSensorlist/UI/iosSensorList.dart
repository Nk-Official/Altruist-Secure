import 'package:altruist_secure_flutter/DisplayTest/UI/display_test.dart';
import 'package:altruist_secure_flutter/FaceRecognition/faceRecognition.dart';
import 'package:altruist_secure_flutter/FingerPrintSensor/fingerPrintSensor.dart';
import 'package:altruist_secure_flutter/ResultList/UI/result_list.dart';
import 'package:altruist_secure_flutter/ScreenGlass&IMEIInstructionPage/ScreenGlassImeiInstructionPage.dart';
import 'package:altruist_secure_flutter/ScreenGlassTest/screenglasstest.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class SenSorIos extends StatefulWidget {
  @override
  SenSorios_ createState() => SenSorios_();
}

class SenSorios_ extends State<SenSorIos> {
  static const platform =
      const MethodChannel('samples.flutter.dev/battery/vibration_test');
  bool location_progress_visible = false;
  bool location_true_status = false;
  bool location_false_status = false;

  bool barometer_progress_visible = false;
  bool barometer_true_status = false;
  bool barometer_false_status = false;

  bool fringerprint_progress_visible = false;
  bool fringerprint_true_status = false;
  bool fringerprint_false_status = false;

  bool textVisi = false;

  bool resultText_status_location = false;
  var mTextStatus_location = TextEditingController();

  bool resultText_status_barometer = false;
  var mTextStatus_barometer = TextEditingController();

  bool resultText_status_fringerprint = false;
  var mTextStatus_fringerprint = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProgress("location_sensor_ios");
    Future.delayed(const Duration(milliseconds: 2000), () {
      _getLocationSensorTest();
    });
  }

  Future<void> _getLocationSensorTest() async {
    try {
      final bool result = await platform.invokeMethod('location_sensor_ios');
      print("Location Sensors $result");
      if (result == true) {
        location_true_status = true;
        mSuccessLocation_SensorSharedPref();
      }else{
        location_false_status = true;
        mFailLocation_SensorSharedPref();
      }

      Future.delayed(const Duration(milliseconds: 2000), () {
        loadProgress("location_sensor_ios");
      });
    } on PlatformException catch (e) {}
  }

  Future<void> _getBarometerTest() async {
    try {
      //  platform.setMethodCallHandler(_handleCallback);
      bool result = await platform.invokeMethod('barometer_sensor_ios');
      //  mToast(result.toString());
      if (result != null) {
        if (result == true) {
          print(result);
          mSuccessBarometer_SensorSharedPref();
          mBarometerRe(true);
        } else {
          mFailBarometer_SensorSharedPref();
          mBarometerRe(false);
        }

        //  _getFingerPrintTest();
      }
    } on PlatformException catch (e) {
      // mToast(e.toString());
    }
  }

  void mBarometerRe(bool result) {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (result == true) {
        barometer_true_status = true;
      } else {
        barometer_false_status = true;
      }
      loadProgress("barometer_sensor_ios");
    });
  }

  Future<void> _getFingerPrintTest() async {
    try {
      //  platform.setMethodCallHandler(_handleCallback);
      int  result = await platform.invokeMethod('sensor_availability_ios');
      //  mToast(result.toString());
      print(result);
      if (result == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FingerPrintSensor(),
          ),
        );
      }
      if (result == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FaceRecognitionSensor(),
          ),
        );
      }
      if (result == 3) {
        var packageName = PreferenceUtils.getString(Utils.appPackageName);
        var countryCode = PreferenceUtils.getString(Utils.COUNTRY_ID);
        print('packageName ==== $packageName');
        print('CountryCode ==== $countryCode');
        if (packageName == "com.insurance.atpl.altruist_secure_flutter" ||
            packageName == "com.insurance.altruistSecureFlutter") {
          if (countryCode == "234") {
            Future.delayed(const Duration(milliseconds: 0), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ScreenGlassTest(),
                    settings: RouteSettings(name: 'ScreenGlassTest')),
              );
            });
          } else {
            Future.delayed(const Duration(milliseconds: 0), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => DisplayTest(),
                    settings: RouteSettings(name: 'DisplayTest')),
              );
            });
          }
        } else if(packageName == "com.app.altruists_secure_bangla".trim() ||
            packageName == "com.app.altruists-secure-bangla".trim()){
          Future.delayed(const Duration(milliseconds: 0), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => DisplayTest(),
                  settings: RouteSettings(name: 'DisplayTest')),
            );
          });
        }
          else {
          Future.delayed(const Duration(milliseconds: 0), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ScreenGlassImeiInstructionPage(),
                  settings: RouteSettings(name: 'ScreenGlassImeiInstructionPage')),
            );
          });
        }



//        Navigator.pushReplacement(
//          context,
//          MaterialPageRoute(
//            builder: (context) => ScreenGlassImeiInstructionPage(),
//          ),
//        );
      }

//      Future.delayed(const Duration(milliseconds: 1000), () {
//        if (fringerprint_true_status == true) {
//          Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(
//              builder: (context) => FingerPrintSensor(),
//            ),
//          );
//        } else {
//          Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(
//              builder: (context) => FaceRecognitionSensor(),
//            ),
//          );
//        }
//      });
    } on PlatformException catch (e) {
      // mToast(e.toString());
    }
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
                fontSize: 17, color: ColorConstant.TextColor, fontFamily: 'Raleway'),
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
                    "Location Sensor Test",
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
                          visible: location_progress_visible,
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
                          visible: location_true_status,
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
                          visible: location_false_status,
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
                        visible: resultText_status_location,
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
                              controller: mTextStatus_location,
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
                    "Barometer Sensor Test",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: 'Raleway'),
                  ),
                  SizedBox(height: 30),
                  Column(
                    children: <Widget>[
                      Visibility(
                          maintainAnimation: true,
                          maintainState: true,
                          visible: barometer_progress_visible,
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
                          visible: barometer_true_status,
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
                          visible: barometer_false_status,
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
                        visible: resultText_status_barometer,
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
                              controller: mTextStatus_barometer,
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
                    visible: false,
                    child: Text(
                      "Fingetprint Sensor Test",
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'Raleway'),
                    ),
                  ),
                  SizedBox(height: 30),
                  Column(
                    children: <Widget>[
                      Visibility(
                          maintainAnimation: true,
                          maintainState: true,
                          visible: fringerprint_progress_visible,
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
                          visible: fringerprint_true_status,
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
                        visible: textVisi,
                        child: Text(
                          "SenSor Not Avaliable",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: 'Raleway'),
                        ),
                      ),
                      Visibility(
                          visible: fringerprint_false_status,
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
                        visible: resultText_status_fringerprint,
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
                              controller: mTextStatus_fringerprint,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 15),
            ],
          ),
        ));
  }

  loadProgress(String tagCaseName) {
    if (tagCaseName.trim() == "location_sensor_ios") {
      if (location_progress_visible == true) {
        setState(() {
          location_progress_visible = false;
          resultText_status_location = true;
          if (location_true_status == true) {
            location_true_status = true;
            location_false_status = false;
            mTextStatus_location.text = Utils.TestSuccessfull;
          } else {
            location_true_status = false;
            location_false_status = true;
            mTextStatus_location.text = Utils.Testfailed;
          }
          Future.delayed(const Duration(milliseconds: 1000), () {
            loadProgress("barometer_sensor_ios");
            _getBarometerTest();
          });
          //  false_status = false;
        });
      } else {
        setState(() {
          location_progress_visible = true;
        });
      }
    } else if (tagCaseName.trim() == "barometer_sensor_ios") {
      if (barometer_progress_visible == true) {
        setState(() {
          barometer_progress_visible = false;
          resultText_status_barometer = true;
          if (barometer_true_status == true) {
            barometer_true_status = true;
            barometer_false_status = false;
            mTextStatus_barometer.text = Utils.TestSuccessfull;
          } else {
            barometer_true_status = false;
            barometer_false_status = true;
            mTextStatus_barometer.text = Utils.Testfailed;
          }
          Future.delayed(const Duration(milliseconds: 2000), () {
            // loadProgress("fingerprint_sensor_ios");
            _getFingerPrintTest();
          });
          //  false_status = false;
        });
      } else {
        setState(() {
          barometer_progress_visible = true;
        });
      }
    } else if (tagCaseName.trim() == "fingerprint_sensor_ios") {
      if (fringerprint_progress_visible == true) {
        setState(() {
          fringerprint_progress_visible = false;
          resultText_status_fringerprint = true;
          if (fringerprint_true_status == true) {
            fringerprint_true_status = true;
            fringerprint_false_status = false;
            mTextStatus_fringerprint.text = Utils.TestSuccessfull;
          } else {
            // fringerprint_true_status = false;
            //   fringerprint_false_status = true;
          }




//          Future.delayed(const Duration(milliseconds: 2000), () {
//            Navigator.pushReplacement(
//              context,
//              MaterialPageRoute(
//                builder: (context) => ScreenGlassImeiInstructionPage(),
//              ),
//            );
//          });
          //  false_status = false;




          var packageName = PreferenceUtils.getString(Utils.appPackageName);
          var countryCode = PreferenceUtils.getString(Utils.COUNTRY_ID);
          print('packageName ==== $packageName');
          print('CountryCode ==== $countryCode');
          if (packageName == "com.insurance.atpl.altruist_secure_flutter" ||
              packageName == "com.insurance.altruistSecureFlutter") {
            if (countryCode == "234") {
              Future.delayed(const Duration(milliseconds: 0), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScreenGlassTest(),
                      settings: RouteSettings(name: 'ScreenGlassTest')),
                );
              });
            } else {
              Future.delayed(const Duration(milliseconds: 0), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DisplayTest(),
                      settings: RouteSettings(name: 'DisplayTest')),
                );
              });
            }
          } else {
            Future.delayed(const Duration(milliseconds: 0), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ScreenGlassImeiInstructionPage(),
                    settings: RouteSettings(name: 'ScreenGlassImeiInstructionPage')),
              );
            });
          }

        });
      } else {
        setState(() {
          fringerprint_progress_visible = true;
        });
      }
    }
  }

  void mSuccessLocation_SensorSharedPref() {
    PreferenceUtils.setString(Utils.Location_Sensor, "true");
    EventTracker.logEvent("LOCATION_SENSOR_IOS_VERIFIED");
  }

  // ignore: non_constant_identifier_names
  void mFailLocation_SensorSharedPref() {
    PreferenceUtils.setString(Utils.Location_Sensor, "false");
    EventTracker.logEvent("LOCATION_SENSOR_IOS_FAILED");
  }

  void mSuccessBarometer_SensorSharedPref() {
    PreferenceUtils.setString(Utils.Barometer_Sensor, "true");
    EventTracker.logEvent("BAROMETER_SENSOR_IOS_VERIFIED");
  }

  // ignore: non_constant_identifier_names
  void mFailBarometer_SensorSharedPref() {
    PreferenceUtils.setString(Utils.Barometer_Sensor, "false");
    EventTracker.logEvent("BAROMETER_SENSOR_IOS_FAILED");
  }

  void mSuccessFringerprint_SensorSharedPref() {
    PreferenceUtils.setString(Utils.Fringerprint_Sensor, "true");
    EventTracker.logEvent("FINGERPRINT_SENSOR_IOS_VERIFIED");
  }

  // ignore: non_constant_identifier_names
  void mFailFringerprint_SensorSharedPref() {
    PreferenceUtils.setString(Utils.Fringerprint_Sensor, "false");
    EventTracker.logEvent("FINGERPRINT_SENSOR_IOS_FAILED");
  }

  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }
}
