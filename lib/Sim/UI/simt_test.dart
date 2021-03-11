import 'package:altruist_secure_flutter/SpeakerTest/UI/speaker_test.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

class SimTest extends StatefulWidget {
  SimTestClass createState() => SimTestClass();
}

class SimTestClass extends State<SimTest> {
  bool statyus_visible = false;
  String textValue;
  int result;
  bool visible = false;
  bool true_status = false;
  bool false_status = false;
  bool resultText_status = false;
  var mTextStatus = TextEditingController();

  static const platform = const MethodChannel('samples.flutter.dev/battery/vibration_test');

  Future<void> _getSimtest() async {
    try {
      platform.setMethodCallHandler(_handleCallback);
      result = await platform.invokeMethod('sim_test');
   //  mToast("Sim State result ==  $result");
      print(result);
      setState(() {
        Future.delayed(const Duration(milliseconds: 2000), () {
          if (result == 5) {
            true_status = true;
            PreferenceUtils.setString(Utils.sim, "true");
            EventTracker.logEvent("SIM_TEST_VERIFIED");
            mTextStatus.text = Utils.TestSuccessfull;
          } else if (result == 1) {
            statyus_visible = true;
            PreferenceUtils.setString(Utils.sim, "false");
            EventTracker.logEvent("SIM_TEST_FAILED");
            true_status = false;
            mTextStatus.text = Utils.Testfailed;
          } else {
            PreferenceUtils.setString(Utils.sim, "false");
            EventTracker.logEvent("SIM_TEST_FAILED");
            true_status = false;
            mTextStatus.text = Utils.Testfailed;
          }
          resultText_status = true;
          loadProgress();
          Future.delayed(const Duration(milliseconds: 2000), () {
            if (true_status == true) {
              mIntent();
            } else {}
          });
        });
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

  @override
  void initState() {
    super.initState();
    loadProgress();
    PreferenceUtils.init();
    Future.delayed(const Duration(milliseconds: 100), () {
      _getSimtest();
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = 'SIM Test';
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor:ColorConstant.AppBarColor,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: new TextStyle(
              fontSize: 17, color:ColorConstant.TextColor, fontFamily: 'Raleway'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
//          SizedBox(height: 15),
//          Text(
//            "Sim Test",
//            textAlign: TextAlign.center,
//            style: new TextStyle(
//                fontSize: 18, color: Colors.black, fontFamily: 'Raleway'),
//          ),
          SizedBox(height: 30),
          Image.asset(
            'sim_card_grey.png',
            height: 100,
            width: 100,
          ),
          SizedBox(height: 20),
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
          ),
          SizedBox(height: 20),
          Visibility(
            visible: statyus_visible,
            child: Text(
              "SIM State Absent \n Please insert a  SIM Card",
              textAlign: TextAlign.center,
              style: new TextStyle(fontFamily: 'SemiBoldItalic',
                  fontSize: 16, color: Colors.black54,),
            ),
          ),
          SizedBox(height: 30),
          Visibility(
            visible: statyus_visible,
            child: Text(
              "OR",
              textAlign: TextAlign.center,
              style: new TextStyle(
                  fontSize: 18, color: Colors.black, fontFamily: 'SemiBoldItalic'),
            ),
          ),
          SizedBox(height: 30),
//          Visibility(
//            visible: statyus_visible,
//            child: SizedBox(
//              width: double.infinity,
//              child: Column(
//                children: <Widget>[
//                  RaisedButton(
//                    onPressed: mIntent,
//                    color: Colors.lightBlueAccent,
//                    textColor: Colors.white,
//                    child: Text(Utils.SkipButtonTest),
//                  ),
//                  // This makes the blue container full width.
//                ],
//              ),
//            ),
//          ),



      Visibility(
        visible: statyus_visible,
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
                      onPressed: mIntent,
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
        ],
      ),
    );
  }

  String _mCheckSimStatus(int simState) {
    var fragSimStatus = "";
    if (simState == 1) {
      fragSimStatus = "SIM State Absent \n Please insert a  SIM Card";
    } else if (simState == 4) {
      fragSimStatus = "SIM State Network Locked";
    } else if (simState == 2) {
      fragSimStatus = "SIM State Pin Required";
    } else if (simState == 3) {
      fragSimStatus = "SIM State Puk Required";
    } else if (simState == 5) {
      fragSimStatus = "";
    } else if (simState == 0) {
      fragSimStatus = "";
    }
    print(fragSimStatus);
    return fragSimStatus;
  }

  void mIntent() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SpeakerTest(),
          settings: RouteSettings(name: 'SpeakerTest')
      ),
    );
  }
  void mSkip() {
    PreferenceUtils.setString(Utils.sim, "false");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SpeakerTest(),
          settings: RouteSettings(name: 'SpeakerTest')
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
}
