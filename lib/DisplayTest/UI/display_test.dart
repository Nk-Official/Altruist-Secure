import 'dart:math';
import 'package:altruist_secure_flutter/ChatHead/ChatHeadProcess.dart';
import 'package:altruist_secure_flutter/ScreenGlassTest/screenglasstest.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/ui/finalResultList/ResultListMain.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

class DisplayTest extends StatefulWidget {
  @override
  DisplayTestClass createState() => DisplayTestClass();
}

class DisplayTestClass extends State<DisplayTest> {
  static const platform =
      const MethodChannel('samples.flutter.dev/battery/vibration_test');
  bool resultText_status = false;
  var mTextStatus = TextEditingController();
  bool true_status = false;
  bool false_status = false;
  bool text_status1 = true;
  bool text_status2 = true;
  bool text_status3 = true;
  bool buttonVisibilty = true;

  void initState() {
    PreferenceUtils.init();
    super.initState();
  }

  Future<void> _getSensorTest() async {
    setState(() {
      buttonVisibilty = false;
      text_status1 = false;
      text_status2 = false;
      text_status3 = false;
    });

    try {
      platform.setMethodCallHandler(_handleCallback);
      final bool result = await platform.invokeMethod('display_test');
    } on PlatformException catch (e) {}
    setState(() {});
  }

  Future<dynamic> _handleCallback(MethodCall call) async {
    PreferenceUtils.init();
    switch (call.method) {
      case "display_test":
        var mVal = call.arguments;
        //   mIntent();
        mVal = mVal.toString();
        if (mVal == "true") {
          //    mToast(mVal);
          true_status = true;
          resultText_status = true;
          mSuccesSharedPref();
          //   mIntent();
          // mToast("Screen Test Working  $mVal");
        } else {
          // mToast(mVal);
          false_status = true;
          mFailSharedPref();
          //  mIntent();
          //mToast("Screen Test Working  $mVal");
        }

        Future.delayed(const Duration(milliseconds: 100), () {
          loadProgress();
        });
    }
  }

  void mIntent() {
    Future.delayed(const Duration(milliseconds: 100), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ResultListMain(),
            settings: RouteSettings(name: 'ResultListMain')
//          builder: (context) => ResultList(),
            ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Display Test';
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
//            "Display Test",
//            textAlign: TextAlign.center,
//            style: new TextStyle(
//                fontSize: 18, color: Colors.black, fontFamily: 'Raleway'),
//          ),
          SizedBox(height: 30),
          Image.asset(
            'display_grey.png',
            height: 100,
            width: 100,
          ),
          SizedBox(height: 20),
          Visibility(
            visible: text_status1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 2),
              child: Text(
                Utils.DisplayTestText,
                textAlign: TextAlign.start,
                style: new TextStyle(
                    fontSize: 17, color: Colors.black54, fontFamily: 'Raleway'),
              ),
            ),
          ),

          SizedBox(height: 2),
          Visibility(
            visible: text_status2,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
              child: Text(
                Utils.DisplayTestText2,
                textAlign: TextAlign.start,
                style: new TextStyle(
                    fontSize: 17, color: Colors.black54, fontFamily: 'Raleway'),
              ),
            ),
          ),
          SizedBox(height: 2),
          Visibility(
            visible: text_status3,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
              child: Text(
                Utils.DisplayTestText3,
                textAlign: TextAlign.start,
                style: new TextStyle(
                    fontSize: 17, color: Colors.black54, fontFamily: 'Raleway'),
              ),
            ),
          ),

          Column(
            children: <Widget>[
              Visibility(
                  maintainAnimation: true,
                  maintainState: true,
                  visible: false,
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
            visible: buttonVisibilty,
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
                      onPressed: _getSensorTest,
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
            visible: false,
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

          SizedBox(height: 50),
        ],
      ),
    );
  }

  void mSuccesSharedPref() {
    PreferenceUtils.setString(Utils.Display_, "true");
    EventTracker.logEvent("DISPLAT_TEST_VERIFIED");
  }

  // ignore: non_constant_identifier_names
  void mFailSharedPref() {
    PreferenceUtils.setString(Utils.Display_, "false");
    EventTracker.logEvent("DISPLAT_TEST_FAILED");
  }

  void mSkip() {
    mFailSharedPref();
    if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "971" ||
        PreferenceUtils.getString(Utils.COUNTRY_ID) == "234") {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              //   builder: (context) => ChatHeadProcess(),
              builder: (context) => ResultListMain(),
              settings: RouteSettings(name: 'ScreenGlassTest')),
        );
      });
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ResultListMain(),
              settings: RouteSettings(name: 'ResultListMain')),
        );
      });
    }
  }

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

      if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "971" ||
          PreferenceUtils.getString(Utils.COUNTRY_ID) == "234") {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                // builder: (context) => ChatHeadProcess(),
                builder: (context) => ResultListMain(),
                settings: RouteSettings(name: 'ResultListMain')),
          );
        });
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ResultListMain(),
                settings: RouteSettings(name: 'ResultListMain')),
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
}
