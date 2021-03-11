import 'package:altruist_secure_flutter/SensorList/UI/sensor_list.dart';
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

class BluetoothTest extends StatefulWidget {
  BluetoothTestClass createState() => BluetoothTestClass();
}

class BluetoothTestClass extends State<BluetoothTest> {
  bool visible = false;
  bool true_status = false;
  bool false_status = false;
  bool resultText_status = false;
  var mTextStatus = TextEditingController();
  static const platform =
      const MethodChannel('samples.flutter.dev/battery/vibration_test');

  Future<void> _getBluetooth() async {
    try {
      //  platform.setMethodCallHandler(_handleCallback);
      final bool result = await platform.invokeMethod('bluetooth_test');
      print(result);
      if (result == true) {
        //    mToast("Bluetooth Working Fine");
        mBlu(true);
        mSuccessSharedPref();
      } else {
        mBlu(false);
        mFailSharedPref();
      }
    } on PlatformException catch (e) {}
  }

  void mBlu(bool status) {
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
              builder: (context) => SenSorTest(),
              settings: RouteSettings(name: 'SenSorTest')),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Bluetooth Test';
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor:ColorConstant.AppBarColor,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: new TextStyle(
              fontSize: 17, color:ColorConstant.TextColor,  fontFamily: 'OpenSans'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 15),
//          Text(
//            "Bluetooth Test",
//            textAlign: TextAlign.center,
//            style: new TextStyle(
//                fontSize: 18, color: Colors.black, fontFamily: 'Raleway'),
//          ),
          SizedBox(height: 30),
          Image.asset('bluetooth_grey.png',
              height: 100, width: 100, alignment: Alignment.center),

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

  @override
  void initState() {
    PreferenceUtils.init();
    loadProgress();
    Future.delayed(Duration(milliseconds: 1000), () {
      _getBluetooth();
    });
    super.initState();
  }

  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

  void mSuccessSharedPref() {
    PreferenceUtils.setString(Utils.Bluetooth, "true");
    EventTracker.logEvent("BLUETOOTH_TEST_VERIFIED");
  }

  void mFailSharedPref() {
    PreferenceUtils.setString(Utils.Bluetooth, "false");
    EventTracker.logEvent("BLUETOOTH_TEST_FAILED");
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
