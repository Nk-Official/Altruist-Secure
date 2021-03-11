import 'dart:async';
import 'dart:developer';
import 'package:altruist_secure_flutter/ChatHead/ChatHeadProcess.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ScreenGlassImeiInstructionPage extends StatefulWidget {
  @override
  ScreenGlassImeiInstructionPageState createState() =>
      ScreenGlassImeiInstructionPageState();
}

class ScreenGlassImeiInstructionPageState
    extends State<ScreenGlassImeiInstructionPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: ColorConstant.AppBarColor,
        title: Text(
          "Steps to perform Glass & IMEI Test",
          textAlign: TextAlign.center,
          style: new TextStyle(
              fontSize: 17,
              color: ColorConstant.TextColor,
              fontFamily: 'OpenSans'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
//          Image.asset('process_flow.png',fit: BoxFit.cover),
            Center(
              child: Visibility(
                visible: true,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                  child: Text(
                    "Please ensure to have one more phone handy with you to perform this Glass Test",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontSize: 28,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
          height: 50,
          child: Column(
            children: <Widget>[
              Visibility(
                visible: true,
                child: Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(0.0),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatHeadProcess(),
                            settings: RouteSettings(name: 'ChatHeadProcess')),
                      );
                    },
                    color: ColorConstant.ButtonColor,
                    child: Text(
                      Utils.Start_Test,
                      style: TextStyle(
                        color: ColorConstant.TextColor,
                        fontFamily: 'OpenSans',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
