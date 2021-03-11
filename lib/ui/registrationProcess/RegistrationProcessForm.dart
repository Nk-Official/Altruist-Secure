import 'dart:io';

import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/models/responses/currencyInfo/CurrencyInfoResponseModel.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class RegistrationProcessForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController userFirstNameController;
  final TextEditingController userLastNameController;
  final TextEditingController userEmailController;
  final TextEditingController phoneNumberController;
  final TextEditingController inVoiceAmmountController;
  final TextEditingController inVoiceDateController;
  final TextEditingController deviceImeiTextController;
  final TextEditingController nationalIDtextController;
  final TextEditingController mFathereNametextController;
  final GestureTapCallback onDatePickerClick;
  final GestureTapCallback onNextClick;
  final GestureTapCallback clickInvoiceUpload;
  final OperatorConfig operatorConfig;
  bool imeiEditableFlag;
  bool flagVisibleImei;
  bool flagVisibleNationalID;
  bool flagVisibleFatherName;
  bool flagEditableFirstName;
  bool flagEditableLasttName;
  bool flagEditableMobilenumber;
  bool flagEditableEmail;
  bool flagVisibleInvoiceAmmount;
  bool flagVisibleInvoiceDate;
  bool buttonInvoiceUploadVisibility;
  bool clickButtonVisibility;
  bool spinnerVisibilty;
  int lenghtCurrecy;
  String dropdownValue;
  File imageFile;
  String uploadImageText;
  final GestureTapCallback onStoreClick;
  final TextEditingController storeController;

  RegistrationProcessForm(
      {Key key,
      this.formKey,
      this.userFirstNameController,
      this.userLastNameController,
      this.userEmailController,
      this.phoneNumberController,
      this.inVoiceAmmountController,
      this.inVoiceDateController,
      this.deviceImeiTextController,
      this.onDatePickerClick,
      this.onNextClick,
      this.operatorConfig,
      this.imeiEditableFlag,
      this.flagVisibleImei,
      this.flagVisibleNationalID,
      this.flagVisibleFatherName,
      this.nationalIDtextController,
      this.mFathereNametextController,
      this.lenghtCurrecy,
      this.flagEditableFirstName,
      this.flagEditableLasttName,
      this.flagEditableEmail,
      this.flagEditableMobilenumber,
      this.flagVisibleInvoiceAmmount,
      this.flagVisibleInvoiceDate,
      this.dropdownValue,
      this.buttonInvoiceUploadVisibility,
      this.clickInvoiceUpload,
      this.clickButtonVisibility,this.spinnerVisibilty,this.imageFile,this.uploadImageText,this.onStoreClick,this.storeController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.fromLTRB(5.0, 10, 5.0, 10),
            child: SingleChildScrollView(
              child: Card(
                  elevation: 3,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 10, 5.0, 10),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: _statusText(),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          new TextFormField(
                            readOnly: flagEditableFirstName,
                            maxLength: 25,
                            controller: userFirstNameController,
                            textCapitalization: TextCapitalization.sentences,
                            // initialValue: "Sumit",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.black54,
                              fontSize: 15.0,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Please enter first name",
                              labelText: 'First Name*',
                              hintStyle: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 15.0,
                                  color: Colors.black54),
                              labelStyle: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 15.0,
                                  color: Colors.lightBlue),
                              contentPadding: EdgeInsets.all(5),
                              //
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.lightBlue),
                              ),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter first name';
                              }
                              if (value.length <= 2) {
                                return 'User name should be aleast 3 characters';
                              }
                              return null;
                            },
                          ),
                          new TextFormField(
                            readOnly: flagEditableLasttName,
                            maxLength: 25,
                            controller: userLastNameController,
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(
                              fontFamily: 'OpenSans SemiBoldItalic',
                              color: Colors.black54,
                              fontSize: 15.0,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Last Name*',
                              hintText: "Please enter last name",
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
                                return 'Please enter last Name*';
                              }
                              if (value.length <= 2) {
                                return 'User name should be aleast 3 characters';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              print(value);
                            },
                          ),
                          new TextFormField(
                            readOnly: flagEditableEmail,
                            controller: userEmailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.black54,
                              fontSize: 15.0,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Email-Id*',
                              hintText: "Please enter your email id",
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
                                return 'Email-ID*';
                              }
                              if (!EmailValidator.validate(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.0),
                          new TextFormField(
                            readOnly: flagEditableMobilenumber,
                            enableInteractiveSelection: false,
                            controller: phoneNumberController,
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.black54,
                              fontSize: 15.0,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Mobile Number*',
                              hintStyle: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 15.0,
                                  color: Colors.lightBlue),
                              labelStyle: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 15.0,
                                  color: Colors.lightBlue),
                              contentPadding: EdgeInsets.all(5),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.lightBlue),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Visibility(
                            visible: flagVisibleImei,
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              maxLength: 15,
                              controller: deviceImeiTextController,
                              readOnly: imeiEditableFlag,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15.0,
                                  fontFamily: 'OpenSans'),
                              decoration: InputDecoration(
                                labelText:
                                    'Device IMEI (Dial *#06# To Get IMEI Number)',
                                labelStyle: TextStyle(
                                    color: Colors.blue, fontFamily: 'OpenSans'),
                                contentPadding: EdgeInsets.all(5),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black54),
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter IMEI number*';
                                }
                                if (value.length < 15) {
                                  return 'IMEI number should be 15 characters';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 10.0),
                          new Visibility(
                              visible: flagVisibleInvoiceAmmount,
                              child: TextFormField(
                                maxLength: operatorConfig == null
                                    ? 6
                                    : int.parse(
                                        operatorConfig.maxLengthForAmount),
                                //   new TextFormField(maxLength: lenghtCurrecy??6,
                                keyboardType: TextInputType.phone,
                                controller: inVoiceAmmountController,
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  color: Colors.black54,
                                  fontSize: 15.0,
                                ),
                                decoration: InputDecoration(
                                  labelText:
                                      'Device Purchase value (${operatorConfig == null ? "" : operatorConfig.currency})*',
                                  hintText: 'Please enter invoice amount',
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
                                    borderSide:
                                        BorderSide(color: Colors.lightBlue),
                                  ),
                                ),
                                validator: (value) {
                                  var mystring;
                                  var minAmount;
                                  if (operatorConfig.maxInvoiceAmount
                                      .contains(",")) {
                                    mystring = operatorConfig.maxInvoiceAmount
                                        .replaceAll(new RegExp(r","), "");
                                  } else {
                                    mystring = operatorConfig.maxInvoiceAmount;
                                  }
                                  if (operatorConfig.minInvoiceAmount
                                      .contains(",")) {
                                    minAmount = operatorConfig.minInvoiceAmount
                                        .replaceAll(new RegExp(r","), "");
                                  } else {
                                    minAmount = operatorConfig.minInvoiceAmount;
                                  }
                                  print('MyReplaced Value ==== $mystring');
                                  if (value.isEmpty) {
                                    return 'Invoice Amount*';
                                  } else {
                                    if (operatorConfig != null &&
                                        (int.parse(value) <
                                                int.parse(minAmount) ||
                                            int.parse(value) >
                                                int.parse(mystring))) {
                                      return 'Invoice amount should be between ${operatorConfig.minInvoiceAmount} -  ${operatorConfig.maxInvoiceAmount} (${operatorConfig.currency})';
                                    } else {
                                      return null;
                                    }
                                  }
                                  return null;
                                },
                              )),
                          new Visibility(
                              visible: flagVisibleInvoiceDate,
                              child: InkWell(
                                  onTap: onDatePickerClick,
                                  child: TextField(
                                    readOnly: true,
                                    controller: inVoiceDateController,
                                    enabled: false,
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      color: Colors.black54,
                                      fontSize: 15.0,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Invoice Month/Year*',
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
                                        borderSide:
                                            BorderSide(color: Colors.lightBlue),
                                      ),
                                    ),
                                  ))),
                          SizedBox(height: 10.0),
                          Visibility(
                            visible: flagVisibleNationalID,
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              maxLength: 17,
                              controller: nationalIDtextController,
                              readOnly: false,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15.0,
                                  fontFamily: 'OpenSans'),
                              decoration: InputDecoration(
                                labelText: 'National ID*',
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
                                  borderSide:
                                      BorderSide(color: Colors.lightBlue),
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter National ID*';
                                } else if (value.length < 10) {
                                  return 'Please enter Valid National ID*';
                                }
                                return null;
//                                else if (value.length > 10 &&
//                                value.length < 17) {
//                                return 'Please enter Valid National ID*';
//                                }

                              },
                              onSaved: (String value) {
                                print(value);
                              },
                            ),
                          ),
                          Visibility(
                            visible: flagVisibleFatherName,
                            child: TextFormField(
                              keyboardType: TextInputType.text,

                              maxLength: 25,
                              controller: mFathereNametextController,
                              readOnly: false,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15.0,
                                  fontFamily: 'OpenSans'),
                              decoration: InputDecoration(
                                labelText: 'Father Name*',
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
                                  borderSide:
                                      BorderSide(color: Colors.lightBlue),
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter Father Name*';
                                }
                                if (value.length <= 2) {
                                  return 'Fathers name should be aleast 3 characters';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                print(value);
                              },
                            ),
                          ),
                          Visibility(
                            visible: spinnerVisibilty,
                            child: InkWell(
                                onTap: onStoreClick,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: storeController,
                                  enabled: false,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 15.0,
                                      fontFamily: 'OpenSans'
                                  ),
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.arrow_drop_down),
                                    labelText: 'Select Store*',
                                    labelStyle: TextStyle(
                                        fontSize: 15.0, color: Colors.blue,fontFamily: 'OpenSans'),
                                    contentPadding: EdgeInsets.all(5),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black54),
                                    ),
                                  ),
                                )),


//                            DropdownButton<String>(
//                              isExpanded: true,
//                              value: dropdownValue,
//                              iconEnabledColor: Colors.lightBlue,
//                              hint: new Text(
//                                "Select Store",
//                                style: TextStyle(
//                                  fontFamily: 'OpenSans SemiBoldItalic',
//                                  color: Colors.lightBlue,
//                                  fontSize: 15.0,
//                                ),
//                              ),
//                              icon: Icon(Icons.arrow_drop_down),
//                              iconSize: 24,
//                              elevation: 16,
//                              style: TextStyle(
//                                  color: Colors.lightBlue, fontSize: 15),
//                              underline: Container(
//                                height: 2,
//                                color: Colors.lightBlue,
//                              ),
//                              onChanged: (String data) {},
//                              items: spinnerItems.map<DropdownMenuItem<String>>(
//                                  (String value) {
//                                return DropdownMenuItem<String>(
//                                  value: value,
//                                  child: Text(value),
//                                );
//                              }).toList(),
//                            ),
                          ),
                          SizedBox(height: 10.0),

                          Visibility(
                              visible: buttonInvoiceUploadVisibility,
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  RaisedButton(
                                    onPressed: clickInvoiceUpload,
                                    color: ColorConstant.ButtonColor,
                                    textColor: ColorConstant.TextColor,
                                    child: Text(uploadImageText),
                                  ),
                                ],
                              )),

                          SizedBox(height: 10.0),



                          _statusTextInvoicet(1),
                          SizedBox(height: 10.0),
                          Visibility(
                            visible: clickButtonVisibility,
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  RaisedButton(
                                    onPressed: onNextClick,
                                    color: ColorConstant.ButtonColor,
                                    textColor: ColorConstant.TextColor,
                                    child: Text('Next'),
                                  ),
                                  // This makes the blue container full width.
                                ],
                              ),
                            ),

                          ),

                          Container(
                              width: 100.0,
                              height: 100.0,
                            child: Image.file(imageFile == null ? "" : imageFile ,),
                          ),

                          SizedBox(height: 10.0),



//                          Visibility(
//                            visible: clickButtonVisibility,
//                            child: SizedBox(
//                              width: double.infinity,
//                              child: Column(
//                                children: <Widget>[
//                                  RaisedButton(
//                                    onPressed: onNextClick,
//                                    color: ColorConstant.ButtonColor,
//                                    textColor: ColorConstant.TextColor,
//                                    child: Text('Next'),
//                                  ),
//                                  // This makes the blue container full width.
//                                ],
//                              ),
//                            ),
//                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: _mPartnerLogo(0),
                          ),

                          SizedBox(
                            height: 10,
                          ),
//                          _mPoweredWidget(),
//                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  )),
            )));
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
      return Container();
    }
  }

  Widget _mPartnerLogo(status) {
    var PackageName = PreferenceUtils.getString(Utils.appPackageName);
    if (PackageName == "com.insurance.atpl.altruist_secure_flutter" ||
        PackageName == "com.insurance.altruistSecureFlutter") {
      return Container(
        height: 40,
        width: double.infinity,
        child: Image.asset(
          'partnered_logos.png',
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _statusText() {
    var PackageName = PreferenceUtils.getString(Utils.appPackageName);
    if (PackageName == "com.insurance.atpl.altruist_secure_flutter".trim() ||
        PackageName == "com.insurance.altruistSecureFlutter".trim()) {
      return Text(
        "To subscribe for MTN Device Insurance, please provide your personal and mobile handset details ( including purchase details)",
        style: TextStyle(
          fontFamily: 'OpenSans',
          color: Colors.black,
          fontSize: 14.0,
        ),
      );
    } else if (PackageName == "com.r3factory".trim() ||
        PackageName == "com.insurance.altruistSecureR3".trim()) {
      return Text(
        "To subscribe for Altruist Secure R3-F , please provide your personal and mobile handset details ( including purchase details)",
        style: TextStyle(
          fontFamily: 'OpenSans',
          color: Colors.black,
          fontSize: 14.0,
        ),
      );
    } else if (PackageName == "com.app.noon_secure".trim() ||
        PackageName == "com.insurance.noonSecure".trim()) {
      return Text(
        "To subscribe for Noon Secure, please provide your personal and mobile handset details ( including purchase details)",
        style: TextStyle(
          fontFamily: 'OpenSans',
          color: Colors.black,
          fontSize: 14.0,
        ),
      );
    } else if (PackageName == "com.app.airtel_tigo_secure".trim()) {
      return Text(
        "To subscribe for Airteltigo Secure, please provide your personal and mobile handset details ( including purchase details)",
        style: TextStyle(
          fontFamily: 'OpenSans',
          color: Colors.black,
          fontSize: 14.0,
        ),
      );
    } else if (PackageName == "com.app.mansardecure_secure".trim()) {
      return Text(
        "To subscribe for Device Protection by AXA Mansard, please provide your personal and mobile handset details ( including purchase details)",
        style: TextStyle(
          fontFamily: 'OpenSans',
          color: Colors.black,
          fontSize: 14.0,
        ),
      );
    } else if (PackageName == "com.app.altruists_secure_bangla".trim() || PackageName == "com.app.altruists-secure-bangla") {
      return Text(
        "To subscribe for Altruist Secure, please provide your personal details and upload picture of your mobile phone invoice.",
        style: TextStyle(
          fontFamily: 'OpenSans',
          color: Colors.black,
          fontSize: 14.0,
        ),
      );
    } else {
      return Text(
        "",
        style: TextStyle(
          fontFamily: 'OpenSans',
          color: Colors.black,
          fontSize: 14.0,
        ),
      );
    }
  }

//  Widget _statusText(status) {
//    //  print("Splash Status ====== $status");
//    if (status == 0) {
//
//    } else if (status == 1) {
//
//    } else if (status == 2) {
//
//    } else if (status == 3) {
//
//    } else if (status == 4) {
//
//    }
//  }

  Widget _statusTextInvoicet(status) {
    if (status == 0) {
      return Text(
        "*Invoice month and amount should be shared as per your original purchase invoice for this handset. In case of any mismatch, your claim can be rejected later.",
        style: TextStyle(
          fontFamily: 'OpenSans',
          color: Colors.black,
          fontSize: 14.0,
        ),
      );
    } else if (status == 1) {
      return Text("");
    } else if (status == 2) {
      return Text("");
    } else if (status == 3) {
      return Text("");
    } else if (status == 4) {
      return Text("");
    }
  }
}
