import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

class ChatBoxTest extends StatelessWidget {
  final bool text1;
  final bool ORCodeVisibilty;
  final bool buttonvisible;
  final GestureTapCallback startClick;
  final GestureTapCallback mSkip;
  final GestureTapCallback checkStatusClick;
  String ImageQRCode;
  final int counterVal;
  final bool isResendEnabled;
  final bool true_status;
  final bool false_status;
  final bool resultText_status;
  final bool buttonvisibleSkip;
  final bool skiptesText;
  final bool inprocessText;
  final bool buttonvisibleCheckStatus;
  final bool textVisibilityNotUploadAnything;
  var mTextStatus = TextEditingController();

  ChatBoxTest({
    Key key,
    this.text1,
    this.buttonvisible,
    this.startClick,
    this.ORCodeVisibilty,
    this.ImageQRCode,
    this.counterVal,
    this.isResendEnabled,
    this.true_status,
    this.false_status,
    this.resultText_status,
    this.mTextStatus,
    this.buttonvisibleSkip,
    this.skiptesText,
    this.mSkip,
    this.inprocessText,
    this.buttonvisibleCheckStatus,
    this.textVisibilityNotUploadAnything,
    this.checkStatusClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = 'Glass & IMEI Test';
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
              fontFamily: 'Raleway'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
//            Visibility(
//              visible: text1,
//              child: Padding(
//                padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
//                child: Text(
//                  "Steps to perform Glass & IMEI test:",
//                  textAlign: TextAlign.start,
//                  style: new TextStyle(
//                      fontSize: 15,
//                      color: Colors.black87,
//                      fontFamily: 'OpenSans'),
//                ),
//              ),
//            ),

            SizedBox(height: 50,),
            Visibility(
              visible: ORCodeVisibilty,
              child: Padding(
                padding: EdgeInsets.all(2),
                child: Image.network(
                  ImageQRCode ?? "",
                  height: 200,
                  width: 200,
                ),
              ),
            ),
            SizedBox(height: 50,),

            Visibility(
              visible: text1,
              child: Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                child: Text(
                  "\"Scan above QR Code with other phone to perform this test\"",
                  textAlign: TextAlign.start,
                  style: new TextStyle(
                      fontSize: 24,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans'),
                ),
              ),
            ),
//            Visibility(
//              visible: text1,
//              child: Padding(
//                padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
//                child: Text(
//                  "- Click on start button and you will be redirected to Dialpad",
//                  textAlign: TextAlign.start,
//                  style: new TextStyle(
//                      fontSize: 15,
//                      color: Colors.black87,
//                      fontFamily: 'OpenSans'),
//                ),
//              ),
//            ),
//            Visibility(
//              visible: text1,
//              child: Padding(
//                padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
//                child: Text(
//                  "- Dial *#06# on the dialpad to get the IMEI ",
//                  textAlign: TextAlign.start,
//                  style: new TextStyle(
//                      fontSize: 15,
//                      color: Colors.black87,
//                      fontFamily: 'OpenSans'),
//                ),
//              ),
//            ),
//            Visibility(
//              visible: text1,
//              child: Padding(
//                padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
//                child: Text(
//                  "- Click the picture of this screen with IMEI number from other phone and upload",
//                  textAlign: TextAlign.start,
//                  style: new TextStyle(
//                      fontSize: 15,
//                      color: Colors.black87,
//                      fontFamily: 'OpenSans'),
//                ),
//              ),
//            ),
//            Visibility(
//              visible: text1,
//              child: Padding(
//                padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
//                child: Text(
//                  "- Click on Altruist Secure button to open the app again for payment",
//                  textAlign: TextAlign.start,
//                  style: new TextStyle(
//                      fontSize: 15,
//                      color: Colors.black87,
//                      fontFamily: 'OpenSans'),
//                ),
//              ),
//            ),
//            SizedBox(height: 20,),
//            Visibility(
//              visible: false,
//              child: Column(
//                children: <Widget>[
//                  new  Padding(
//                    padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
//                    child:  Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Text(
//                          "It seems your device your device rating is low and you can’t proceed further for the activation of Altruist secure",
//                          textAlign: TextAlign.start,
//                          style: TextStyle(
//                            fontSize: 15,
//                            color: Colors.black87,
//                            fontFamily: 'OpenSans',
//                            fontWeight: FontWeight.bold,
//                          ),
//                        ),
//                        SizedBox(
//                          height: 5,
//                        ),
//                        Text(
//                          "Option 1 - Do you want to sell your device. If YES CLICK HERE",
//                          style: TextStyle(
//                            fontSize: 15,
//                            color: Colors.black87,
//                            fontFamily: 'OpenSans',
//                            fontWeight: FontWeight.bold,
//                          ),
//                        ),
//                        SizedBox(
//                          height: 5,
//                        ),
//                        Text(
//                          "Thanks for showing your interest to pick up your device to sell you device. We will pick up your device from your door step to evaluate and will give you the best price of your device. Our executive will call you soon to assist you further",
//                          style: TextStyle(
//                            fontSize: 15,
//                            color: Colors.black87,
//                            fontFamily: 'OpenSans',
//                          ),
//                        ),
//                        SizedBox(
//                          height: 5,
//                        ),
//                        Text(
//                          "Option 2- Do you want to us to repair/fix your device. If YES CLICK HERE",
//                          style: TextStyle(
//                            fontSize: 15,
//                            color: Colors.black87,
//                            fontFamily: 'OpenSans',
//                            fontWeight: FontWeight.bold,
//                          ),
//                        ),
//                        SizedBox(
//                          height: 5,
//                        ),
//                        Text(
//                          "Thanks for showing your interest to pick up your device for the repair. Our executive will call you soon to assist you further ",
//                          style: TextStyle(
//                            fontSize: 15,
//                            color: Colors.black87,
//                            fontFamily: 'OpenSans',
//                          ),
//                        ),
//                        SizedBox(
//                          height: 5,
//                        ),
//                      ],
//                    ),
//                  )
//                ],
//              ),
//            ),

            Visibility(
              visible: textVisibilityNotUploadAnything,
              child: Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                child:
                Text(
                  "Dear customer, It seems you have not uploaded the image for Glass test and IMEI check \n\nPlease scan above QR code to re-perform the test ",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),


            Visibility(
              visible: buttonvisible,
              child: Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                child:
                Text(
               //   "Dear customer, It seems Glass & IMEI Test was not performed properly so please scan QR Code and upload image to perform the test",
                  "Dear customer, It seems Glass & IMEI Test was not performed properly and has been rejected.\n\nPlease scan above QR Code and upload image to perform the test",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Visibility(
              visible: skiptesText,
              child: Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                child:
                Text(
                  "Dear customer, Please upload the image to continue with the mandatory glass test or click Skip to continue",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),


            Visibility(
              visible: inprocessText,
              child: Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                child:
                Text(
                  "Dear customer, Your image has been uploaded successfully but the same not yet verified, our executive will soon review the image\n\nPlease check the status in sometime",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),


            SizedBox(
              height: 20,
            ),
            Visibility(
                visible: isResendEnabled,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.timer,
                      size: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        counterVal > 9 ? "00:$counterVal" : "00:0$counterVal",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15.0,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    )
                  ],
                )),
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
            SizedBox(
              height: 20,
            ),
//            Visibility(
//              visible: buttonvisible,
//              child: Flexible(
//                child: Align(
//                  alignment: Alignment.center,
//                  child: Container(
//                    margin: new EdgeInsets.symmetric(horizontal: 20.0),
//                    child: SizedBox(
//                      width: double.infinity,
//                      child: RaisedButton(
//                        shape: RoundedRectangleBorder(
//                          borderRadius: new BorderRadius.circular(3.2),
//                        ),
//                        color: ColorConstant.ButtonColor,
//                        onPressed: startClick,
//                        child: Text(
//                          "Start Test Again",
//                          style: new TextStyle(
//                              fontSize: 16,
//                              color: ColorConstant.TextColor,
//                              fontFamily: 'Raleway'),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//            ),

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
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
