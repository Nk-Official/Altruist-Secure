import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Vibration_test extends StatefulWidget {
  @override
  _Vibration_testState createState() => _Vibration_testState();
}

class _Vibration_testState extends State<Vibration_test> {
  String _vibrationResult = "";
  ProgressDialog pr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pr = ProgressDialog(context);
  }

  Future<void> checkVibration() async {
    String vibResult = "";
    try {
      await pr.show();
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 1500);
        vibResult = "TRUE";
      } else {
        vibResult = "FALSE";
      }
    } on PlatformException catch (e) {
      vibResult = "Failed to get vibration result: '${e.message}'.";
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        pr.hide().then((isHidden) {
          print(isHidden);
        });
        print(vibResult);
        _vibrationResult = vibResult;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: const Text('Test Plugin example app'),
          ),
          body: Builder(builder: (BuildContext context) {
            return Center(
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text('Vibrate for default 1500ms'),
                    onPressed: () {
                      checkVibration();
                    },
                  ),
                  Text(_vibrationResult),
//                  RaisedButton(
//                    child: Text('BLUETOOTH test'),
//                    onPressed: () {
//                      testBluetooth();
//                    },
//                  ),
//                  Text(_bluetoothResult),
//                  RaisedButton(
//                    child: Text('FLASH test'),
//                    onPressed: () {
//                      testFlash();
//                    },
//                  ),
//                  Text(_FlashResult),
                ],
              ),
            );
          }),
    );
  }
}
