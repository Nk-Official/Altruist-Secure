import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/models/responses/currencyInfo/CurrencyInfoResponseModel.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';

class EditRegistrationProcessForm extends StatelessWidget {
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
  final OperatorConfig operatorConfig;
  bool imeiEditableFlag;
  bool flagVisibleImei;
  bool flagVisibleNationalID;
  bool flagVisibleFatherName;
  bool flagVisibleInvoiceAmmount;
  bool flagVisibleInvoiceDate;
  bool spinnerVisibilty;
  String dropdownValue;
  List<String> spinnerItems;

  EditRegistrationProcessForm(
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
      this.flagVisibleInvoiceAmmount,
      this.flagVisibleInvoiceDate,
      this.dropdownValue,
      this.spinnerItems,this.spinnerVisibilty})
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

                          Visibility(
                            visible:spinnerVisibilty ,
                            child:DropdownButton<String>(
                              value: dropdownValue,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.black, fontSize: 18),
                              underline: Container(
                                height: 2,
                                color: Colors.black,
                              ),
                              items: spinnerItems
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),

                          ),




                          SizedBox(
                            height: 20,
                          ),
                          new TextFormField(
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
                                return 'First name should be aleast 3 characters';
                              }
                              return null;
                            },
                          ),
                          new TextFormField(
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
                            controller: userEmailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.black54,
                              fontSize: 15.0,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Email-ID*',
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
                            readOnly: true,
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
                                    'Device IMEI (Dial *#06# To Get IMEI Number) ',
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
                          new Visibility(
                              visible: flagVisibleInvoiceAmmount,
                              child: TextFormField(
                                maxLength: operatorConfig == null
                                    ? 5
                                    : operatorConfig.maxInvoiceAmount.length,
                                keyboardType: TextInputType.phone,
                                controller: inVoiceAmmountController,
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  color: Colors.black54,
                                  fontSize: 15.0,
                                ),
                                decoration: InputDecoration(
                                  labelText:
                                      'Invoice Amount (${operatorConfig == null ? "" : operatorConfig.currency})*',
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
                                  if (operatorConfig.maxInvoiceAmount
                                      .contains(",")) {
                                    mystring = operatorConfig.maxInvoiceAmount
                                        .replaceAll(new RegExp(r","), "");
                                  } else {
                                    mystring = operatorConfig.maxInvoiceAmount;
                                  }
                                  print('MyReplaced Value ==== $mystring');
                                  print(
                                      'peratorConfig.maxInvoiceAmount Value ==== ${operatorConfig.maxInvoiceAmount}');
                                  if (value.isEmpty) {
                                    return 'Invoice Amount*';
                                  } else {
                                    if (operatorConfig != null &&
                                        (int.parse(value) >
                                            int.parse(mystring))) {
                                      return 'Invoice amount should be less then ${operatorConfig.maxInvoiceAmount} (${operatorConfig.currency})';
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
                                } else if (value.length > 10 &&
                                    value.length < 17) {
                                  return 'Please enter Valid National ID*';
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
                                  return 'Father name should be aleast 3 characters';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                print(value);
                              },
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "*Invoice month and amount should be shared per your original purchase invoice for this handset. In case of any mismatch, your claims can be rejected later.",
                            style: new TextStyle(
                              fontFamily: 'OpenSans',
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 10.0),
                          SizedBox(
                            width: double.infinity,
                            child: Column(
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
                        ],
                      ),
                    ),
                  )),
            )));
  }

//  Widget _statusText(status) {
//    //  print("Splash Status ====== $status");
//    if (status == 0) {
//      return Text(
//        "To subscribe for MTN Device Insurance, please provide your personal and mobile handset details ( including purchase details)",
//        style: TextStyle(
//          fontFamily: 'OpenSans',
//          color: Colors.black,
//          fontSize: 14.0,
//        ),
//      );
//    } else if (status == 1) {
//      return Text(
//        "To subscribe for Altruist Secure R3-F , please provide your personal and mobile handset details ( including purchase details)",
//        style: TextStyle(
//          fontFamily: 'OpenSans',
//          color: Colors.black,
//          fontSize: 14.0,
//        ),
//      );
//    } else if (status == 2) {
//      return Text(
//        "To subscribe for Noon Secure, please provide your personal and mobile handset details ( including purchase details)",
//        style: TextStyle(
//          fontFamily: 'OpenSans',
//          color: Colors.black,
//          fontSize: 14.0,
//        ),
//      );
//    }
//    else if (status == 3) {
//      return Text(
//        "To subscribe for Airteltigo Secure, please provide your personal and mobile handset details ( including purchase details)",
//        style: TextStyle(
//          fontFamily: 'OpenSans',
//          color: Colors.black,
//          fontSize: 14.0,
//        ),
//      );
//    }
//    else if (status == 4) {
//      return Text(
//        "To subscribe for Device Protection by AXA Mansard, please provide your personal and mobile handset details ( including purchase details)",
//        style: TextStyle(
//          fontFamily: 'OpenSans',
//          color: Colors.black,
//          fontSize: 14.0,
//        ),
//      );
//    }
//  }

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
    } else if (PackageName == "com.app.altruists_secure_bangla".trim() ||
        PackageName == "com.app.altruists-secure-bangla".trim()) {
      return Text(
        "To subscribe for Altruist Secure, please provide your personal and mobile handset details ( including purchase details)",
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
}
