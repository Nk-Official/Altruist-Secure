import 'package:altruist_secure_flutter/HeadPhoneTest/UI/headphone.dart';
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

class SpeakerTest extends StatefulWidget {
  @override
  Speaker createState() => Speaker();
}

Color _colorFromHex(String hexColor) {
  //_colorFromHex("#feee00")
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

class Speaker extends State<SpeakerTest> {
  var _height = 30.0;
  var _width = 30.0;
  var numStartAgainVal;
  int numVal;
  bool ReturnValue;
  bool visible = false;
  bool true_status = false;
  bool false_status = false;
  bool resultText_status = false;
  var mTextStatus = TextEditingController();

  bool mRow1 = false;
  bool mRow2 = false;
  bool buttonvisible = true;
  bool instructionText = true;
  bool _btnEnabled = true;

  static const platform =
      const MethodChannel('samples.flutter.dev/battery/vibration_test');

  Future<void> _getSpeaker(var value_) async {
    try {
      ReturnValue = await platform.invokeMethod('speaker_test', {"text": value_});
      if (ReturnValue == true) {
        print(ReturnValue);
      } else {
        buttonvisible = true;
      }
    } on PlatformException catch (e) {}
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        mRow1 = true;
        mRow2 = true;
        buttonvisible = true;
      });
    });
  }

  @override
  void initState() {
    PreferenceUtils.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Speaker Test';
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
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 30),
          Image.asset(
            'speaker_grey.png',
            height: 100,
            width: 100,
          ),
          Visibility(
            visible: instructionText,
            child: Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Text(
                "To test the speaker, press the \"Start Test\" button and Click on the number you heard.",
                textAlign: TextAlign.start,
                style: new TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontFamily: 'OpenSans'),
              ),
            ),
          ),
          SizedBox(height: 15),
          new Visibility(
              visible: mRow1,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: _width,
                    height: _height,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(2.0),
                          side: BorderSide(color: ColorConstant.ButtonColor)),
                      color: Colors.white,
                      textColor: Colors.black87,
                      padding: EdgeInsets.all(8.0),
                      onPressed: () {
                        mCheckResult(1);
                      },
                      child: Text(
                        "1".toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: _width,
                    height: _height,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(2.0),
                          side: BorderSide(color: ColorConstant.ButtonColor)),
                      color: Colors.white,
                      textColor: Colors.black87,
                      padding: EdgeInsets.all(8.0),
                      onPressed: () {
                        mCheckResult(2);
                      },
                      child: Text(
                        "2".toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: _width,
                    height: _height,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(2.0),
                          side: BorderSide(color: ColorConstant.ButtonColor)),
                      color: Colors.white,
                      textColor: Colors.black87,
                      padding: EdgeInsets.all(8.0),
                      onPressed: () {
                        mCheckResult(3);
                      },
                      child: Text(
                        "3".toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: _width,
                    height: _height,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(2.0),
                          side: BorderSide(color: ColorConstant.ButtonColor)),
                      color: Colors.white,
                      textColor: Colors.black87,
                      padding: EdgeInsets.all(8.0),
                      onPressed: () {
                        mCheckResult(4);
                      },
                      child: Text(
                        "4".toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          SizedBox(height: 30),
          new Visibility(
            visible: mRow2,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: _width,
                  height: _height,
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(2.0),
                        side: BorderSide(color: ColorConstant.ButtonColor)),
                    color: Colors.white,
                    textColor: Colors.black87,
                    padding: EdgeInsets.all(8.0),
                    onPressed: () {
                      mCheckResult(5);
                    },
                    child: Text(
                      "5".toUpperCase(),
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: _width,
                  height: _height,
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(2.0),
                        side: BorderSide(color: ColorConstant.ButtonColor)),
                    color: Colors.white,
                    textColor: Colors.black87,
                    padding: EdgeInsets.all(8.0),
                    onPressed: () {
                      mCheckResult(6);
                    },
                    child: Text(
                      "6".toUpperCase(),
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: _width,
                  height: _height,
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(2.0),
                        side: BorderSide(color: ColorConstant.ButtonColor)),
                    color: Colors.white,
                    textColor: Colors.black87,
                    padding: EdgeInsets.all(8.0),
                    onPressed: () {
                      mCheckResult(7);
                    },
                    child: Text(
                      "7".toUpperCase(),
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: _width,
                  height: _height,
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(2.0),
                        side: BorderSide(color: ColorConstant.ButtonColor)),
                    color: Colors.white,
                    textColor: Colors.black87,
                    padding: EdgeInsets.all(8.0),
                    onPressed: () {
                      mCheckResult(8);
                    },
                    child: Text(
                      "8".toUpperCase(),
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ],
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
                      onPressed:() async{
                        if(_btnEnabled){
                          mStartAgain();

                        }
                      }
                      ,
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
          SizedBox(height: 20,),
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
          ),
        ],
      ),
    );
  }

  mStartAgain() {

    setState(() {
      _btnEnabled =false;
    });
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _btnEnabled =true;
      });

    });

    var rng = new Random();
    Future.delayed(const Duration(milliseconds: 1000), () {
      for (var i = 0; i < 1; i++) {
        int Low = 1;
        int High = 8;
        print(rng.nextInt(High - Low) + Low);
        numVal = rng.nextInt(High - Low) + Low;
      }
      if (rng.nextInt(8) == 0) {
        numVal = 7;
      } else if (rng.nextInt(8) == 9) {
        numVal = 7;
      }
      Future.delayed(const Duration(milliseconds: 100), () {
        if (numVal != null) {
          _getSpeaker(numVal);
        }
      });
    });
  }

  int mRandomNumber() {
    int Low = 1;
    int High = 8;
    var rng = new Random();
    for (var i = 0; i < 1; i++) {
      print(rng.nextInt(High - Low) + Low);
      numVal = (rng.nextInt(High - Low) + Low);
    }
    if (rng.nextInt(8) == 0) {
      numVal = 7;
    } else if (rng.nextInt(8) == 9) {
      numVal = 7;
    }
    return numVal;
  }

  mCheckResult(int mVal) {
    print(numVal);
    print(mVal);
    loadProgress();
    instructionText = false;
    mRow1 = false;
    mRow2 = false;
    buttonvisible = false;
    if (numVal == mVal) {
      print("Press vaule True");
      PreferenceUtils.setString(Utils.Speaker, "true");
      EventTracker.logEvent("SPEAKER_TEST_VERIFIED");
      mRePr(true, true);
    } else {
      mRePr(true, false);
      PreferenceUtils.setString(Utils.Speaker, "false");
      EventTracker.logEvent("SPEAKER_TEST_FAILED");
      print("Press vaule False");
    }
  }

  mSkip() {
    PreferenceUtils.setString(Utils.Speaker, "false");
    EventTracker.logEvent("SPEAKER_TEST_FAILED");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => headPhoneTest(),
          settings: RouteSettings(name: 'headPhoneTest')),
    );
  }

  void mRePr(bool status, bool val) {
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (val == true) {
        true_status = true;
      } else {
        false_status = true;
      }
      loadProgress();
    });
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
        Future.delayed(const Duration(milliseconds: 2000), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => headPhoneTest(),
                settings: RouteSettings(name: 'headPhoneTest')),
          );
        });
        //  false_status = false;
      });
    } else {
      setState(() {
        visible = true;
      });
    }
  }
}
