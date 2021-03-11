import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/models/responses/currencyInfo/CurrencyInfoResponseModel.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class EnterOtpProcessForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController userNumber;
  final TextEditingController userCountryCode;
  final GestureTapCallback onCountryCodeClick;
  final GestureTapCallback onNextClick;
  final OperatorConfig operatorConfig;
  int mobileNumberLength;
  String appBarName = "OTP Verification";
  String hintName = "";
  bool mSponserText;

  EnterOtpProcessForm(
      {Key key,
      this.formKey,
      this.userNumber,
      this.userCountryCode,
      this.onCountryCodeClick,
      this.onNextClick,
      this.operatorConfig,
      this.mobileNumberLength,
      this.hintName,
      this.mSponserText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
//      bottomNavigationBar: BottomAppBar(
//        child: Visibility(
//          visible: mSponserText,
//          child: Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Text(
//              Utils.sponser,
//              style: TextStyle(
//                  color:ColorConstant.SponserTextColor,
//                  fontSize: Utils.sponserTextSize,
//                  fontWeight: FontWeight.bold,
//                  fontFamily: 'OpenSans-SemiBoldItalic'),
//              textAlign: TextAlign.center,
//            ),
//          ),
//        ),
//      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Card(
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
//                          Card(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
//                                  Text(
//                                    "Select Country*",
//                                    style: TextStyle(
//                                        color: Colors.black54,
//                                        fontSize: 15.0,
//                                        fontWeight: FontWeight.bold),
//                                  ),

                              InkWell(
                                  onTap: onCountryCodeClick,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: userCountryCode,
                                    enabled: false,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                        fontFamily: 'OpenSans'),
                                    decoration: InputDecoration(
                                      labelText: 'Select Country*',
                                      hintStyle: TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontSize: 15.0,
                                          color: Colors.black),
                                      labelStyle: TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontSize: 16.0,
                                          color: Colors.black54),
                                      contentPadding: EdgeInsets.all(5),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black54),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
//                          ),
//                          Card(
//                            child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new TextFormField(
                                maxLength: mobileNumberLength,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                                controller: userNumber,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter phone number first';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontFamily: 'OpenSans'),
                                decoration: InputDecoration(
                                  hintText: hintName,
                                  labelText: 'Mobile Number*',
                                  labelStyle: TextStyle(
                                      color: Colors.black54,
                                      fontFamily: 'OpenSans'),
                                  contentPadding: new EdgeInsets.fromLTRB(
                                      5.0, 5.0, 5.0, 5.0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black54),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              RaisedButton(
                                onPressed: onNextClick,
                                color: ColorConstant.ButtonColor,
                                textColor: ColorConstant.TextColor,
                                child: Text('Send OTP'),
                              ),
                              SizedBox(height: 10.0),
                            ],
                          ),
//                          ),
                        ],
                      ),
                    )),

                SizedBox(height: 100,),
                Visibility(
                    visible: mSponserText,
                    child: Container(
                        margin: EdgeInsets.only(top: 5.0),
                      child:_mPoweredWidget(),
                    )),
              ],
            )),
      )),
    );
  }


  Widget _mPoweredWidget() {
    if (PreferenceUtils.getString(Utils.appPackageName) == "com.insurance.atpl.altruist_secure_flutter" || PreferenceUtils.getString(Utils.appPackageName) == "com.insurance.altruistSecureFlutter"){
      return Container(
//        height: 35,
//        width: double.infinity,
//        child: Image.asset(
//          'powered_by_image.png',
//        ),
      );
    }else{
      return Container(
      );
    }

  }



//  void mIntent(String mNumber, mCountryID) {
//    print('Country Code $mCountryID');
//
//    print(mNumber);
//    EventTracker.logEventWithParams("ENTER_NUMBER_SCREEN", mNumber);
//    Navigator.pushReplacement(
//      context,
//      MaterialPageRoute(
//          builder: (context) => OtpVerification(mNumber, mCountryID),
//          settings: RouteSettings(name: 'OtpVerification')),
//    );
//  }
}
