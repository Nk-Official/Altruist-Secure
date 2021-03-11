import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';

class OtpVerificationForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String appBarName = "OTP Verification";

  final TextEditingController otpTextController;
  final GestureTapCallback onRegisterClick;

//  final GestureTapCallback onVerifyOtpClick;
  final GestureTapCallback onResendClick;
  final GestureTapCallback onBackPress;
  final GestureTapCallback onChangeNumberClick;
  final bool isResendEnabled;
  final bool mOptVerifybuttonVisible;
  final bool isOtpVerifyEnabled;

  final int counterVal;
  final String mobileNumber;

  OtpVerificationForm({
    Key key,
    this.otpTextController,
    this.onRegisterClick,
    this.onResendClick,
    this.onBackPress,
    this.isResendEnabled,
    this.isOtpVerifyEnabled,
    this.counterVal,
    this.onChangeNumberClick,
    this.mobileNumber,
    this.mOptVerifybuttonVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorConstant.AppBarColor,
            title: Text(
              appBarName,
              textAlign: TextAlign.center,
              style: new TextStyle(
                  fontSize: 17,
                  color: ColorConstant.TextColor,
                  fontFamily: 'OpenSans'),
            ),
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Container(
                child: Padding(
              padding: EdgeInsets.all(20.0),
//                  child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    elevation: 5,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        Text(
                          "Please enter OTP",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans'),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Enter the 6-digit code sent to your mobile number",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13.0,
                                fontFamily: 'OpenSans'),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        GestureDetector(
                          child: Text(
                            "$mobileNumber",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.red,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans'),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        GestureDetector(
                          child: Text(
                            "Change mobile number",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.red,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans'),
                          ),
                          onTap: onChangeNumberClick,
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: TextFormField(
                              maxLength: 6,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.phone,
                              controller: otpTextController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter OTP';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontFamily: 'OpenSans'),
                              decoration: InputDecoration(
                                hintText: 'Please enter OTP',
                                labelText: 'Enter OTP*',
                                labelStyle: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: 'OpenSans'),
                                contentPadding:
                                    new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black26),
                                ),
                              ),
                            )),
                        SizedBox(height: 10.0),
                        Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Visibility(
                                visible: isResendEnabled ? false : true,
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.timer,
                                      size: 18,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(
                                        counterVal > 9
                                            ? "00:$counterVal"
                                            : "00:0$counterVal",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12.0,
                                          fontFamily: 'OpenSans',
                                        ),
                                      ),
                                    )
                                  ],
                                ))),
                        SizedBox(height: 10.0),
                        Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Visibility(
                                visible: isResendEnabled,
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: GestureDetector(
                                        child: Text('Resend OTP',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                                fontFamily: 'OpenSans')),
                                        onTap: isResendEnabled
                                            ? onResendClick
                                            : null,
                                      ),
                                    )
                                  ],
                                ))),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    onPressed: isOtpVerifyEnabled ? onRegisterClick : null,
                    color: ColorConstant.ButtonColor,
                    textColor: ColorConstant.TextColor,
                    child: Text('Verify OTP '),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  _mPoweredWidget(),
                ],
              ),
//                  ),
            )),
          )),
    );
  }

  Widget _mPoweredWidget() {
    if (PreferenceUtils.getString(Utils.appPackageName) ==
            "com.insurance.atpl.altruist_secure_flutter" ||
        PreferenceUtils.getString(Utils.appPackageName) ==
            "com.insurance.altruistSecureFlutter") {
      return Container(
//        height: 35,
//        width: double.infinity,
//        child: Image.asset(
//          'powered_by_image.png',
//        ),
      );
    } else {
      return Container();
    }
  }
}
