import 'package:altruist_secure_flutter/DisplayTest/UI/display_test.dart';
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
import 'dart:math';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class FingerPrintSensor extends StatefulWidget {
  @override
  FingerPrint createState() => FingerPrint();
}

class FingerPrint extends State<FingerPrintSensor> {
  bool ReturnValue;
  bool visible = false;
  bool true_status = false;
  bool false_status = false;
  bool resultText_status = false;
  var mTextStatus = TextEditingController();
  bool buttonvisible = true;
  bool instructionText = true;

  static const platform =
      const MethodChannel('samples.flutter.dev/battery/vibration_test');

  Future<void> _getFaceID() async {
    PreferenceUtils.setString(Utils.Fringerprint_Sensor_Status, "true");
    try {
      ReturnValue = await platform.invokeMethod('fingerprint_sensor_ios');
      if (ReturnValue == true) {
        print(ReturnValue);
        true_status = true;

        mSuccessFringerprint_SensorSharedPref();
      } else {
        false_status = true;
        buttonvisible = true;
        mFailFringerprint_SensorSharedPref();
      }
    } on PlatformException catch (e) {}
    Future.delayed(const Duration(milliseconds: 100), () {
      loadProgress();
    });
  }

  @override
  void initState() {
    PreferenceUtils.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Fingerprint Sensor Test';
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: ColorConstant.AppBarColor,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: new TextStyle(
              fontSize: 17,
              color: ColorConstant.TextColor,
              fontFamily: 'Raleway'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 30),
          Image.asset(
            'fingerprint_grey.png',
            height: 100,
            width: 100,
          ),
          Visibility(
            visible: instructionText,
            child: Padding(
              padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
              child: Text(
                "Before testing your Fingerprint sensor please make sure that your Fingerprint is configured properly on your phone.",
                textAlign: TextAlign.start,
                style: new TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontFamily: 'OpenSans'),
              ),
            ),
          ),
          new GestureDetector(
            onTap: () {
              _launchURL();
            },
            child: Visibility(
              visible: instructionText,
              child: Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
                child: Text(
                  "Click here to know more about Fingerprint configuration.",
                  textAlign: TextAlign.start,
                  style: new TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 15,
                      color: Colors.black87,
                      fontFamily: 'OpenSans'),
                ),
              ),
            ),
          ),
          Visibility(
            visible: instructionText,
            child: Padding(
              padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
              child: Text(
                "To start Fingerprint sensor test, Press Start Test.",
                textAlign: TextAlign.start,
                style: new TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontFamily: 'OpenSans'),
              ),
            ),
          ),
//          SizedBox(height: 15),
//          Visibility(
//            visible: buttonvisible,
//            child: SizedBox(
//              width: double.infinity,
//              child: Column(
//                children: <Widget>[
//                  RaisedButton(
//                    onPressed: mStartAgain,
//                    color: Colors.lightBlueAccent,
//                    textColor: Colors.white,
//                    child: Text('Start'),
//                  ),
//                  // This makes the blue container full width.
//                ],
//              ),
//            ),
//          ),
          SizedBox(height: 15),
          Column(
            children: <Widget>[
              Visibility(
                  maintainAnimation: true,
                  maintainState: true,
                  visible: visible,
                  child: Container(
                    margin: EdgeInsets.only(top: 50, bottom: 30),
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
                  visible: true_status,
                  maintainState: true,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: Image.asset(
                      'assets/progresstrue.png',
                      height: 60,
                      width: 60,
                    ),
                  )),
              Visibility(
                  visible: false_status,
                  maintainState: true,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: Image.asset(
                      'assets/progressfalse.png',
                      height: 60,
                      width: 60,
                    ),
                  )),
              Visibility(
                visible: resultText_status,
                maintainState: true,
                child: new Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 0, bottom: 10),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.black87,
                          fontFamily: 'OpenSans'),
                      decoration: new InputDecoration.collapsed(
                        border: InputBorder.none,
                      ),
                      controller: mTextStatus,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Visibility(
            visible: buttonvisible,
            child: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: new EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(3.2),
                      ),
                      color: ColorConstant.ButtonColor,
                      onPressed: mStartAgain,
                      child: Text(
                        Utils.StatButtonTest,
                        style: new TextStyle(
                            fontSize: 16,
                            color: ColorConstant.TextColor,
                            fontFamily: 'Raleway'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(
            height: 20,
          ),
          Visibility(
            visible: buttonvisible,
            maintainState: true,
            maintainAnimation: true,
            maintainSize: true,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: new EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(3.2),
                    ),
                    color: Colors.blueGrey,
                    onPressed: mSkip,
                    child: Text(
                      Utils.SkipButtonTest,
                      style: new TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'Raleway'),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }

  mStartAgain() {
    setState(() {
      buttonvisible = false;
      instructionText = false;
    });
    _getFaceID();
  }

//  void mRePr(bool status, bool val) {
//    Future.delayed(const Duration(milliseconds: 2000), () {
//      if (val == true) {
//        true_status = true;
//      } else {
//        false_status = true;
//      }
//      loadProgress();
//    });
//  }

  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

  loadProgress() {
    setState(() {
      if (true_status == true) {
        resultText_status = true;
        true_status = true;
        false_status = false;
        mTextStatus.text = Utils.TestSuccessfull;
      } else {
        resultText_status = true;
        false_status = true;
        true_status = false;
        mTextStatus.text = Utils.Testfailed;
      }
      var packageName = PreferenceUtils.getString(Utils.appPackageName);
      var countryCode = PreferenceUtils.getString(Utils.COUNTRY_ID);
      print('packageName ==== $packageName');
      print('CountryCode ==== $countryCode');
      if (packageName == "com.insurance.atpl.altruist_secure_flutter" ||
          packageName == "com.insurance.altruistSecureFlutter") {
        if (countryCode == "234") {
          Future.delayed(const Duration(milliseconds: 3000), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ScreenGlassTest(),
                  settings: RouteSettings(name: ' ScreenGlassTest()')),
            );
          });
        } else {
          Future.delayed(const Duration(milliseconds: 3000), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => DisplayTest(),
                  settings: RouteSettings(name: 'DisplayTest')),
            );
          });
        }
      } else if (packageName == "com.app.altruists_secure_bangla".trim() ||
          packageName == "com.app.altruists-secure-bangla") {
        Future.delayed(const Duration(milliseconds: 3000), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DisplayTest(),
                settings: RouteSettings(name: 'DisplayTest')),
          );
        });
      } else {
        Future.delayed(const Duration(milliseconds: 3000), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ScreenGlassImeiInstructionPage(),
                settings:
                    RouteSettings(name: 'ScreenGlassImeiInstructionPage')),
          );
        });
      }

      //  false_status = false;
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

  mSkip() {
    mFailFringerprint_SensorSharedPref();
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
    } else if (packageName == "com.app.altruists_secure_bangla".trim() ||
        packageName == "com.app.altruists-secure-bangla") {
      Future.delayed(const Duration(milliseconds: 0), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => DisplayTest(),
              settings: RouteSettings(name: 'DisplayTest')),
        );
      });
    }else {
      Future.delayed(const Duration(milliseconds: 0), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ScreenGlassImeiInstructionPage(),
              settings: RouteSettings(name: 'ScreenGlassImeiInstructionPage')),
        );
      });
    }
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
}

_launchURL() async {
  const url = 'https://support.apple.com/en-us/HT201371';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
