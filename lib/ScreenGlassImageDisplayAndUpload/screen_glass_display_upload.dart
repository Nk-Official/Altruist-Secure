import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';

import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'dart:io' as io;
import 'package:flutter/material.dart';

class ScreenGlassDisplay extends StatelessWidget {
  bool imageVisible;
  String Imageshow;
  GestureTapCallback UploadImage;
  GestureTapCallback ReclickImage;
  bool buttonVisibilty;
  bool textVisible1;
  bool true_status;
  bool false_status;
  bool resultText_status;
  var mTextStatus = TextEditingController();
  final bool buttonvisibleCheckStatus;
  final bool buttonvisibleSkip;
  final GestureTapCallback checkStatusClick;
  final GestureTapCallback mSkip;

  ScreenGlassDisplay({
    Key key,
    this.imageVisible,
    this.Imageshow,
    this.UploadImage,
    this.ReclickImage,
    this.buttonVisibilty,
    this.textVisible1,
    this.true_status,
    this.false_status,
    this.resultText_status,
    this.mTextStatus,
    this.buttonvisibleCheckStatus,
    this.checkStatusClick,
    this.buttonvisibleSkip,
    this.mSkip,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.AppBarColor,
        title: Text(
          Utils.GlassTestTitle,
          style: TextStyle(
              color: ColorConstant.TextColor,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans'),
        ),
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Visibility(
            visible: textVisible1,
            child: Text(
              Utils.GlassTestText4,
              style: new TextStyle(
                  fontSize: 16, color: Colors.black, fontFamily: 'Raleway'),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Visibility(
              visible: imageVisible,
              child: Container(
                  height: 250,
                  width: 250,
                  child: Image.file(
                    File.fromUri(Uri.parse(Imageshow)),
                    fit: BoxFit.cover,
                  ))),
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
          SizedBox(
            height: 10,
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
                      color:ColorConstant.ButtonColor,
                      onPressed: UploadImage,
                      child: Text(
                        Utils.Upload,
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
            visible: buttonVisibilty,
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
                    onPressed: ReclickImage,
                    child: Text(
                      Utils.Reclcik,
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

          Visibility(
            visible: buttonvisibleCheckStatus,
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
                    onPressed: checkStatusClick,
                    child: Text(
                      "Check Status",
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
            height: 40,
          ),


          Visibility(
            visible: buttonvisibleSkip,
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
        ]),
      ),
    );
  }
}