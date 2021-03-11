import 'dart:async';
import 'package:altruist_secure_flutter/ChatHead/ChatHeadProcess.dart';
import 'package:altruist_secure_flutter/DisplayTest/UI/display_test.dart';
import 'package:altruist_secure_flutter/FingerPrintSensor/fingerPrintSensor.dart';
import 'package:altruist_secure_flutter/ScreenGlass&IMEIInstructionPage/ScreenGlassImeiInstructionPage.dart';
import 'package:altruist_secure_flutter/ScreenGlassImageDisplayAndUpload/screen_glass_display_upload_presenter.dart';
import 'package:altruist_secure_flutter/ScreenGlassTest/screenglasstest.dart';
import 'package:altruist_secure_flutter/SenSorList2/UI/sensor_list2.dart';
import 'package:altruist_secure_flutter/Sim/UI/simt_test.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/ui/finalResultList/ResultListMain.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:vibration/vibration.dart';
import 'package:toast/toast.dart';

class VibrationTest extends StatefulWidget {
  _VibrationClass createState() => _VibrationClass();
}

class _VibrationClass extends State<VibrationTest> {
  ProgressDialog pr;
  bool visible = false;
  bool true_status = false;
  bool false_status = false;
  bool resultText_status = false;
  var mTextStatus = TextEditingController();

  @override
  void initState() {
    super.initState();
    // configLoading();
    loadProgress();
    pr = ProgressDialog(context);
    PreferenceUtils.init();
    Future.delayed(const Duration(milliseconds: 100), () {
      checkVibration();
    });
  }

  Future<void> checkVibration() async {
    String vibResult = "";
    try {
      // await pr.show();
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 1500);
        vibResult = "TRUE";
        mNavigate(true);
        //mToast("Vibration Working Fine");
      } else {
        //  true_status = false;
        mNavigate(false);
        vibResult = "FALSE";
        //  mToast("Vibration Not Working");
      }
    } on PlatformException catch (e) {
      vibResult = "Failed to get vibration result: '${e.message}'.";
    }
  }

  void mNavigate(bool mStatus) {
    Future.delayed(const Duration(milliseconds: 2000), () {
      resultText_status = true;
      if (mStatus == true) {
        PreferenceUtils.setString(Utils.vibration, "true");
        EventTracker.logEvent("VIBRATION_TEST_VERIFIED");
        true_status = true;
      } else {
        EventTracker.logEvent("VIBRATION_TEST_FAILED");
        PreferenceUtils.setString(Utils.vibration, "false");
        false_status = true;
      }
      loadProgress();
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            //   builder: (context) => ScreenGlassImeiInstructionPage(),
                builder: (context) => SimTest(),
           //   builder: (context) => FingerPrintSensor(),
            //  builder: (context) => ResultListMain(),
          //    builder: (context) => DisplayTest(),
            //  builder: (context) => ScreenGlassTest(),
              settings: RouteSettings(name: 'SimTest')),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Vibration Test';
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
              fontFamily: 'OpenSans'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
//          SizedBox(height: 15),
//          Text(
//            "Vibration Test",
//            textAlign: TextAlign.center,
//            style: new TextStyle(
//                fontSize: 18, color: Colors.black, fontFamily: 'OpenSans'),
//          ),
          SizedBox(height: 30),
          Image.asset(
            'mobile_phone_vibrating_grey.png',
            height: 100,
            width: 100,
          ),
          SizedBox(height: 20),

          Padding(
            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: Text(
              "Make sure vibration is enabled in mobile phone settings. " +
                  "Keep your mobile non a flat surface for accuracy",
              textAlign: TextAlign.center,
              style: new TextStyle(
                  fontSize: 16, color: Colors.black, fontFamily: 'OpenSans'),
            ),
          ),

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
          )
        ],
      ),
    );
  }

  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

  loadProgress() {
    if (visible == true) {
      setState(() {
        visible = false;
        if (true_status == true) {
          true_status = true;
          false_status = false;
          mTextStatus.text = Utils.TestSuccessfull;
        } else {
          true_status = false;
          false_status = true;
          mTextStatus.text = Utils.Testfailed;
        }
        //  false_status = false;
      });
    } else {
      setState(() {
        visible = true;
      });
    }
  }
}
