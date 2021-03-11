import 'dart:math';
import 'package:altruist_secure_flutter/BluetoothTest/UI/bluetooth_test.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'dart:io' show Platform;
import 'dart:async';

class WifiTest extends StatefulWidget {
  WifiTestClass createState() => WifiTestClass();
}

class WifiTestClass extends State<WifiTest> {
  bool visible = false;
  bool true_status = false;
  bool false_status = false;
  bool resultText_status = false;
  var mTextStatus = TextEditingController();
  bool mCheckIosWifi =false;
  static const platform = const MethodChannel('samples.flutter.dev/battery/vibration_test');

  Future<void> _getWifi() async {
    // mToast("_getWifi method called");
    try {
      platform.setMethodCallHandler(_handleCallback);
      final bool result = await platform.invokeMethod('wifi_test');
      if (result == true) {
        print(result);
        mSuccessSharedPref();
        mwifiNaviGate(true);
      } else {
        if (Platform.isAndroid) {
          mFailSharedPref();
          mwifiNaviGate(false);
        } else if (Platform.isIOS) {
         // mToast("Wifi Case Called");
          if(mCheckIosWifi == false){
             mCheckIosWifi = true;
            _showMaterialDialog();
         //    mToast("Wifi _showMaterialDialog Called");
          }else{
          //  mToast("Wifi Failed Called");
            mFailSharedPref();
            mwifiNaviGate(false);
          }

        }


      }
    } on PlatformException catch (e) {}
  }


  _showMaterialDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text(
                "Enable WiFi",
                style: new TextStyle(fontFamily: 'OpenSans'),
              ),
              content: new Text(
                "Please ensure that the WiFi is enabled and your phone is connected to an active WiFi network for successful completion of this test ",
                style: new TextStyle(fontFamily: 'OpenSans'),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Ok',
                    style: new TextStyle(fontFamily: 'OpenSans'),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    // Navigator.of(context).pop();
                    loadProgress();
                    _getWifi();
                  },
                ),
              ],
            ));
  }

  void mwifiNaviGate(bool status) {
    Future.delayed(Duration(milliseconds: 2000), () {
      if (status == true) {
        true_status = true;
      } else {
        false_status = true;
      }
      loadProgress();
    });
    Future.delayed(Duration(milliseconds: 3000), () {
      setState(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BluetoothTest(),
              settings: RouteSettings(name: 'BluetoothTest')),
        );
        //_FlashResult = flashResult;
      });
    });
  }

  Future<dynamic> _handleCallback(MethodCall call) async {
    switch (call.method) {
      case "message_":
        print(call.arguments);
    }
  }

  @override
  void initState() {
    if (Platform.isAndroid) {
      Future.delayed(Duration(milliseconds: 1000), () {
       //   _showMaterialDialog();
       loadProgress();
        _getWifi();
      });
    } else if (Platform.isIOS) {
      mCheckIosWifi = false;
      _getWifi();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final title = 'WiFi Test';
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
          SizedBox(height: 30),
          Image.asset('wifi_grey.png',
              height: 80, width: 80, alignment: Alignment.center),
          SizedBox(
            height: 30,
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
                          color: Colors.black,
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

  void mSuccessSharedPref() {
    PreferenceUtils.setString(Utils.Wifi, "true");
    EventTracker.logEvent("WIFI_TEST_VERIFIED");
  }

  void mFailSharedPref() {
    PreferenceUtils.setString(Utils.Wifi, "false");
    EventTracker.logEvent("WIFI_TEST_FAILED");
  }

  loadProgress() {
    if (visible == true) {
      setState(() {
        visible = false;
        resultText_status = true;
        if (true_status == true) {
          true_status = true;
          false_status = false;
          mTextStatus.text = Utils.TestSuccessfull;
        } else {
          false_status = true;
          true_status = false;
          mTextStatus.text = Utils.WiFiTestfailed;
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
