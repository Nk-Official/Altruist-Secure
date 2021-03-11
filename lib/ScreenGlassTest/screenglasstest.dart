import 'dart:math';
import 'package:altruist_secure_flutter/CameraCaptureScreen/DeviceDetailsCode.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

class ScreenGlassTest extends StatefulWidget {
  @override
  ScreenGlassTestState createState() => ScreenGlassTestState();
}


class ScreenGlassTestState extends State<ScreenGlassTest> {
  bool buttonVisibilty = true;
  void initState() {
    PreferenceUtils.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor:ColorConstant.AppBarColor,
        title: Text(
         Utils.GlassTestTitle,
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
          Image.asset(
            'display_grey.png',
            height: 100,
            width: 100,
          ),
          SizedBox(height: 20),
          Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 2),
              child: Text(
                Utils.GlassTestText1,
                textAlign: TextAlign.start,
                style: new TextStyle(
                    fontSize: 17, color: Colors.black54, fontFamily: 'Raleway'),
              ),
            ),

          SizedBox(height: 10),

          Padding(
              padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
              child: Text(
                Utils.GlassTestText2,
                textAlign: TextAlign.start,
                style: new TextStyle(
                    fontSize: 17, color: Colors.black54, fontFamily: 'Raleway'),
              ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 2),
            child: Text(
              Utils.DisplayTestText3,
              textAlign: TextAlign.start,
              style: new TextStyle(
                  fontSize: 17, color: Colors.black54, fontFamily: 'Raleway'),
            ),
          ),
          SizedBox(height: 10),

          Container(
            height: 150,
            width: 150,
          child: Image.asset("screen_glass_image.png",),
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
                      onPressed: _getCameraTest,
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




          SizedBox(height: 50),
        ],
      ),
    );
  }


  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }
  _getCameraTest() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => CameraScreen(),
              settings: RouteSettings(name: 'CameraScreen')),
        );
  }

}
