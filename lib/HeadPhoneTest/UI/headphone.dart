import 'package:altruist_secure_flutter/FlashTest/UI/flash_test.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

class headPhoneTest extends StatefulWidget {
  @override
  headPhoneTestClass createState() => headPhoneTestClass();
}

class headPhoneTestClass extends State<headPhoneTest> {
  var numStartAgainVal;
  int numVal;
  var ReturnValue;
  bool visible = false;
  bool true_status = false;
  bool false_status = false;
  bool skipVisibility = true;
  bool orVisibility = true;
  bool textVisibility = true;
  bool resultText_status = false;
  var mTextStatus = TextEditingController();
  static const platform =
      const MethodChannel('samples.flutter.dev/battery/vibration_test');

  Future<void> _getHeadPhone() async {
    try {
      platform.setMethodCallHandler(_handleCallback);
      ReturnValue = await platform.invokeMethod('headphone_test');
    } on PlatformException catch (e) {}
  }

  Future<dynamic> _handleCallback(MethodCall call) async {
    switch (call.method) {
      case "headphone_test":
        ReturnValue = call.arguments;
        print(ReturnValue);
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (ReturnValue == true) {
            skipVisibility = false;
            orVisibility = false;
            textVisibility = false;
            loadProgress();
            PreferenceUtils.setString(Utils.Headphone, "true");
            mTextStatus.text = Utils.TestSuccessfull;
            Future.delayed(const Duration(milliseconds: 2000), () {
              true_status = true;
              msucessmethos();

            });
            }
           else {
            false_status = true;
            mTextStatus.text = Utils.Testfailed;
            PreferenceUtils.setString(Utils.Headphone, "false");
            EventTracker.logEvent("HEADPHONE_TEST_FAILED");
            loadProgress();
            msucessmethos();
           }

        });

    }
  }

  @override
  void initState() {
    super.initState();
    PreferenceUtils.init();
    Future.delayed(const Duration(milliseconds: 100), () {
      _getHeadPhone();
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Earphone Jack Test';
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor:ColorConstant.AppBarColor,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: new TextStyle(
              fontSize: 17, color: ColorConstant.TextColor, fontFamily: 'OpenSans'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
//          SizedBox(height: 15),
//          Text(
//            "Headphone Test",
//            textAlign: TextAlign.center,
//            style: new TextStyle(
//                fontSize: 18, color: Colors.black, fontFamily: 'OpenSans'),
//          ),
          SizedBox(height: 30),
          Image.asset(
            'headphones_grey.png',
            height: 100,
            width: 100,
          ),
         Visibility(
           visible:textVisibility ,
         child: Padding(
             padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
             child: Text(
               "Plug-in your wired earphone into \n your mobile to continue",
               textAlign: TextAlign.center,
               style: new TextStyle(
                   fontSize: 16, color: Colors.black54, fontFamily: 'OpenSans'),
             ),
           ),
         ),

          Visibility(
            visible: orVisibility,
           child: Padding(
              padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
              child: Text(
                "OR",
                textAlign: TextAlign.center,
                style: new TextStyle(
                    fontSize: 18, color: Colors.black, fontFamily: 'OpenSans'),
              ),
            ),
          ),

//          Visibility(
//            visible:skipVisibility ,
////            child:GestureDetector(
////              onTap: _skip,
////              child: Text(
////                "Skip",
////                textAlign: TextAlign.center,
////                style: new TextStyle(
////                    fontSize: 16, color: Colors.black54, fontFamily: 'OpenSans'),
////              ),
////            ),
//
//            child: SizedBox(
//              width: double.infinity,
//              child: Column(
//                children: <Widget>[
//                  RaisedButton(
//                    onPressed: _skip,
//                    color: Colors.lightBlueAccent,
//                    textColor: Colors.white,
//                    child: Text(Utils.SkipButtonTest),
//                  ),
//                  // This makes the blue container full width.
//                ],
//              ),
//            ),
//
//          ),

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
,

          Visibility(
            visible: skipVisibility,
            child:Expanded(
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
                      onPressed: _skip,
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
          ),

          SizedBox(
            height: 50,
          ),
//          Visibility(
//            visible: false,
//            maintainState: true,
//            child: Expanded(
//              child: Align(
//                alignment: Alignment.bottomCenter,
//                child: Container(
//                  margin: new EdgeInsets.symmetric(horizontal: 20.0),
//                  child: SizedBox(
//                    width: double.infinity,
//                    child: RaisedButton(
//                      shape: RoundedRectangleBorder(
//                        borderRadius: new BorderRadius.circular(3.2),
//                      ),
//                      color: Colors.lightBlueAccent,
//                      child: Text(
//                        Utils.StatButtonTest,
//                        style: new TextStyle(
//                            fontSize: 16,
//                            color: Colors.white,
//                            fontFamily: 'Raleway'),
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//            ),
//          ),

        ],

      ),
    );
  }

  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

  void _skip() {
    PreferenceUtils.setString(Utils.Headphone, "false");
    EventTracker.logEvent("HEADPHONE_TEST_SKIPPED");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => FlashTest(),
          settings: RouteSettings(name: 'FlashTest')),
    );
  }

  loadProgress() {
    if (visible == true) {
      setState(() {
        visible = false;
        resultText_status =true;
        if (true_status == true) {
          true_status = true;
          false_status = false;
        } else {
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

  void msucessmethos() {
    loadProgress();
    EventTracker.logEvent("HEADPHONE_TEST_VERIFIED");
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        print(ReturnValue);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => FlashTest(),
              settings: RouteSettings(name: 'FlashTest')),
        );
      });
    });
  }

  void mNavigator() {


  }

}


