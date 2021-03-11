import 'package:altruist_secure_flutter/Camera/UI/camera_test.dart';
import 'package:altruist_secure_flutter/SensorList/UI/sensor_list.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:torch/torch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:flutter/cupertino.dart';
class FlashTest extends StatefulWidget {
  @override
  _FlashTestClass createState() => new _FlashTestClass();
}

class _FlashTestClass extends State<FlashTest> {
  bool visible = false;
  bool true_status = false;
  bool false_status = false;
  bool resultText_status = false;
  var mTextStatus = TextEditingController();
  Future<void> testFlash() async {
    try {
      var result = await Torch.hasTorch;
      if (result) {
        Torch.turnOn();
        Torch.flash(Duration(milliseconds: 1000));
        true_status = true;
        // mToast("Flash Working Fine");

        mSuccessSharedPref();
        //  flashResult = "TRUE";
      } else {
        false_status = true;
        //flashResult = "FALSE";
        //  mToast("Flash Not Working ");
        mFailSharedPref();
      }
    } on PlatformException catch (e) {
      //  flashResult = "Failed to get Flash results: '${e.message}'.";
    }
    setState(() {
      Torch.turnOff();
      loadProgress();
      Future.delayed(Duration(milliseconds: 2000), () {
        Torch.turnOff();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TakePictureScreen__(),
              settings: RouteSettings(name: 'TakePictureScreen')),
        );
      });
    });
  }

  @override
  void initState() {
    PreferenceUtils.init();
    loadProgress();
    Future.delayed(Duration(milliseconds: 1000), () {
      testFlash();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Flash Test';
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor:ColorConstant.AppBarColor,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: new TextStyle(
              fontSize: 17, color: ColorConstant.TextColor,fontFamily: 'OpenSans'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
//          SizedBox(height: 15),
//          Text(
//            "Flash Test",
//            textAlign: TextAlign.center,
//            style: new TextStyle(
//                fontSize: 18, color: Colors.black, fontFamily: 'Raleway'),
//          ),
          SizedBox(height: 30),
          Image.asset('flash_grey.png',
              height: 100, width: 100, alignment: Alignment.center),

          SizedBox(height: 10),
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
                      style:TextStyle(
                          fontSize: 17, color: Colors.black87, fontFamily: 'OpenSans'),
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

  void mSuccessSharedPref() {
    EventTracker.logEvent("FLASH_TEST_VERIFIED");
    PreferenceUtils.setString(Utils.Flash, "true");
  }

  void mFailSharedPref() {
    EventTracker.logEvent("FLASH_TEST_FAILED");
    PreferenceUtils.setString(Utils.Flash, "false");
  }

  loadProgress() {
    if (visible == true) {
      setState(() {
        visible = false;
        resultText_status = true;
        if (true_status == true) {
          mTextStatus.text = Utils.TestSuccessfull;
          true_status = true;
          false_status = false;
        } else {
          mTextStatus.text = Utils.Testfailed;
          false_status = true;
          true_status = false;
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
