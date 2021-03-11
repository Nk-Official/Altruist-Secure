import 'package:altruist_secure_flutter/EditRegistration/UI/EditRegistrationProcess.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class userConfirmationScreenXml extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameTextController;
  final TextEditingController mobileNumberTextController;
  final TextEditingController emailTextController;
  final TextEditingController deviceNameTextController;
  final TextEditingController deviceModelTextController;
  final TextEditingController deviceImeiTextController;
  final TextEditingController invoiceAmountTextController;
  final TextEditingController invoiceDateTextController;
  final TextEditingController agreeValueTextController;
  final TextEditingController nationalIDtextController;
  final TextEditingController mFathereNametextController;
  final GestureTapCallback onSubmitClick;
  final String currency;
  final String firstName, lastName;
  bool imeiEditableFlag;
  bool flagVisibleNationalID;
  bool flagVisibleFatherName;
  bool imeioption;
  bool flagVisibleInvoiceAmmount;
  bool flagVisibleDate;
  bool flagVisibleAgreeValue;

//  final GestureTapCallback onBackClick;

  userConfirmationScreenXml({Key key,
    this.nameTextController,
    this.mobileNumberTextController,
    this.emailTextController,
    this.deviceNameTextController,
    this.deviceModelTextController,
    this.deviceImeiTextController,
    this.invoiceAmountTextController,
    this.invoiceDateTextController,
    this.onSubmitClick,
    this.currency,
    this.imeiEditableFlag,
    this.firstName,
    this.lastName,
    this.flagVisibleNationalID,
    this.flagVisibleFatherName,
    this.nationalIDtextController,
    this.mFathereNametextController,
    this.imeioption,
    this.flagVisibleInvoiceAmmount,
    this.flagVisibleDate,
    this.agreeValueTextController,
    this.flagVisibleAgreeValue
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.AppBarColor,
        automaticallyImplyLeading: true,
        title: Text(
          "Confirm details",
          textAlign: TextAlign.center,
          style: new TextStyle(
              fontSize: 17,
              color: ColorConstant.TextColor,
              fontFamily: 'OpenSans'),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.all(15),
        key: _formKey,
        child: new ListView(
          children: <Widget>[
            TextFormField(
              enabled: false,
              style: TextStyle(
                  color: Colors.blue, fontSize: 18.0, fontFamily: 'OpenSans'),
              decoration: InputDecoration(
                labelText: 'User Details',
                labelStyle:
                TextStyle(color: Colors.black, fontFamily: 'OpenSans'),
                contentPadding: EdgeInsets.all(5),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
            TextFormField(
              controller: nameTextController,
              readOnly: true,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15.0,
                  fontFamily: 'OpenSans'),
              decoration: InputDecoration(
                labelText: 'Name',
                hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.blue,
                    fontFamily: 'OpenSans'),
                labelStyle:
                TextStyle(color: Colors.blue, fontFamily: 'OpenSans'),
                contentPadding: EdgeInsets.all(5),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: mobileNumberTextController,
              readOnly: true,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15.0,
                  fontFamily: 'OpenSans'),
              decoration: InputDecoration(
                labelText: 'Mobile',
                labelStyle:
                TextStyle(color: Colors.blue, fontFamily: 'OpenSans'),
                contentPadding: EdgeInsets.all(5),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                ),
              ),
              onSaved: (String value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
                print(value);
              },
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: emailTextController,
              readOnly: true,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15.0,
                  fontFamily: 'OpenSans'),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle:
                TextStyle(color: Colors.blue, fontFamily: 'OpenSans'),
                contentPadding: EdgeInsets.all(5),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                ),
              ),
            ),
            TextField(
              enabled: false,
              style: TextStyle(
                  color: Colors.blue, fontSize: 18.0, fontFamily: 'OpenSans'),
              decoration: InputDecoration(
                labelText: 'Device Details',
                labelStyle:
                TextStyle(color: Colors.black, fontFamily: 'OpenSans'),
                contentPadding: EdgeInsets.all(5),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
            TextFormField(
              controller: deviceNameTextController,
              readOnly: true,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15.0,
                  fontFamily: 'OpenSans'),
              decoration: InputDecoration(
                labelText: 'Device Name',
                labelStyle:
                TextStyle(color: Colors.blue, fontFamily: 'OpenSans'),
                contentPadding: EdgeInsets.all(5),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: deviceModelTextController,
              readOnly: true,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15.0,
                  fontFamily: 'OpenSans'),
              decoration: InputDecoration(
                labelText: 'Device Model',
                labelStyle:
                TextStyle(color: Colors.blue, fontFamily: 'OpenSans'),
                contentPadding: EdgeInsets.all(5),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Visibility(
              visible: imeioption,
              child: TextFormField(
                controller: deviceImeiTextController,
                readOnly: true,
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15.0,
                    fontFamily: 'OpenSans'),
                decoration: InputDecoration(
                  labelText: 'Device IMEI',
                  labelStyle:
                  TextStyle(color: Colors.blue, fontFamily: 'OpenSans'),
                  contentPadding: EdgeInsets.all(5),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Visibility(
                visible: flagVisibleInvoiceAmmount,
                child: TextFormField(
                  controller: invoiceAmountTextController,
                  readOnly: true,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15.0,
                      fontFamily: 'OpenSans'),
                  decoration: InputDecoration(
                    labelText: 'Invoice Amount' +
                        '(' +
                        PreferenceUtils.getString(
                            Utils.CURRENCYFORPREFRENCE) +
                        ')',
                    labelStyle:
                    TextStyle(color: Colors.blue, fontFamily: 'OpenSans'),
                    contentPadding: EdgeInsets.all(5),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                  ),
                )),
            SizedBox(height: 10.0),
            Visibility(
                visible: flagVisibleDate,
                child: TextFormField(
                  controller: invoiceDateTextController,
                  readOnly: true,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15.0,
                      fontFamily: 'OpenSans'),
                  decoration: InputDecoration(
                    labelText: 'Invoice Month/Year',
                    labelStyle:
                    TextStyle(color: Colors.blue, fontFamily: 'OpenSans'),
                    contentPadding: EdgeInsets.all(5),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                  ),
                )),
            SizedBox(height: 10.0),
            Visibility(
              visible: flagVisibleNationalID,
              child: TextFormField(
                controller: nationalIDtextController,
                readOnly: true,
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15.0,
                    fontFamily: 'OpenSans'),
                decoration: InputDecoration(
                  labelText: 'National ID',
                  hintText: "Please enter your National ID",
                  hintStyle: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 15.0,
                      color: Colors.black54),
                  labelStyle: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 15.0,
                      color: Colors.lightBlue),
                  contentPadding: EdgeInsets.all(5),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Nationa ID*';
                  }
                  return null;
                },
                onSaved: (String value) {
                  print(value);
                },
              ),
            ),
            Visibility(
              visible: flagVisibleFatherName,
              child: TextFormField(
                controller: mFathereNametextController,
                readOnly: true,
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15.0,
                    fontFamily: 'OpenSans'),
                decoration: InputDecoration(
                  labelText: 'Father Name',
                  hintText: "Please enter your Father Name",
                  hintStyle: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 15.0,
                      color: Colors.black54),
                  labelStyle: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 15.0,
                      color: Colors.lightBlue),
                  contentPadding: EdgeInsets.all(5),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Father Name*';
                  }
                  if (value.length <= 2) {
                    return 'Father name should be aleast 3 characters';
                  }
                  return null;
                },
                onSaved: (String value) {
                  print(value);
                },
              ),
            ),
            SizedBox(height: 5.0),
            Visibility(
                visible: flagVisibleAgreeValue,
                child: TextFormField(
                  controller: agreeValueTextController,
                  readOnly: true,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15.0,
                      fontFamily: 'OpenSans'),
                  decoration: InputDecoration(
                    labelText: Utils.agree_value,
                    labelStyle:
                    TextStyle(color: Colors.blue, fontFamily: 'OpenSans'),
                    contentPadding: EdgeInsets.all(5),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                  ),
                )),
            SizedBox(height: 5.0),
            RaisedButton(
              onPressed: onSubmitClick,
              color: ColorConstant.ButtonColor,
              textColor: ColorConstant.TextColor,
              child: Text('Confirm'),
            ),
            SizedBox(height: 10,),
            _mPoweredWidget(),
            SizedBox(height: 10,),
          ],


        ),
      ),
    );
  }


  Widget _mPoweredWidget() {
    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.insurance.atpl.altruist_secure_flutter" ||
        PreferenceUtils.getString(Utils.appPackageName) ==
            "com.insurance.altruistSecureFlutter") {
      return Container(
        height: 35,
        width: double.infinity,
        child: Image.asset(
          'powered_by_image.png',
        ),
      );
    } else {
      return Container(
      );
    }
  }

}
