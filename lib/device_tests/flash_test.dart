import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:torch/torch.dart';

class FlashTest extends StatefulWidget {
  @override
  _FlashTestState createState() => _FlashTestState();
}

class _FlashTestState extends State<FlashTest> {
  ProgressDialog pr;
  String _FlashResult = "";

  Future<void> testFlash() async {
    String flashResult = "";
    try {
      pr.show();
      var result = await Torch.hasTorch;
      if (result) {
        Torch.turnOn();
        Torch.flash(Duration(milliseconds: 1500));
        flashResult = "TRUE";
      } else {
        flashResult = "FALSE";
      }
    } on PlatformException catch (e) {
      flashResult = "Failed to get Flash results: '${e.message}'.";
    }

    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        Torch.turnOff();
        pr.hide().then((isHidden) {
          print(isHidden);
        });
        _FlashResult = flashResult;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pr = ProgressDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: const Text('Test Plugin example app'),
          ),
          body: Builder(builder: (BuildContext context) {
            return Center(
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text('FLASH test'),
                    onPressed: () {
                      testFlash();
                    },
                  ),
                  Text(_FlashResult),
                ],
              ),
            );
          })),
    );
  }
}
