import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/ui/homeNewScreen/NewHomeDashboard.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'dart:core';
import 'package:email_validator/email_validator.dart';

class ProfileManagementFormScreen extends StatelessWidget {
  String verificationId;
  int mobileNumberLength;
  int mCountryCodeLength;
  final GlobalKey<FormState> formKey;
  TextEditingController userAlternativeNumberController =
      TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userDOBController = TextEditingController();
  TextEditingController userAddressController = TextEditingController();
  TextEditingController userGenderController = TextEditingController();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController mobileNumberTextController = TextEditingController();
  TextEditingController deviceNameTextController = TextEditingController();
  TextEditingController deviceModelTextController = TextEditingController();
  TextEditingController deviceImeiTextController = TextEditingController();
  TextEditingController invoiceAmountTextController = TextEditingController();
  TextEditingController invoiceDateTextController = TextEditingController();
  TextEditingController nationalIDtextController = TextEditingController();
  TextEditingController mFathereNametextController = TextEditingController();
  TextEditingController mAlternativeCountryController = TextEditingController();
  bool flagVisibleNationalID;
  bool flagVisibleFatherName;
  bool flagVisibleInvoiceMonth;
  bool flagVisibleInvoiceValue;


  String dropdownValue = 'Select Your Gender';
  List<String> spinnerItems = [
    'Select Your Gender',
    'Male',
    'Female',
    'Others'
  ];
  DateTime selectedDate;
  var SelectedDOB;
  final GestureTapCallback onDOBClick;
  final GestureTapCallback onSubmitClick;
  final GestureTapCallback onGenderClick;

  ProfileManagementFormScreen(
      {Key key,
      this.formKey,
      this.userAlternativeNumberController,
      this.userEmailController,
      this.userDOBController,
      this.userAddressController,
      this.dropdownValue,
      this.onDOBClick,
      this.onSubmitClick,
      this.userGenderController,
      this.onGenderClick,
      this.nameTextController,
      this.mobileNumberTextController,
      this.deviceNameTextController,
      this.deviceModelTextController,
      this.deviceImeiTextController,
      this.invoiceAmountTextController,
      this.invoiceDateTextController,
      this.nationalIDtextController,
      this.mFathereNametextController,
      this.flagVisibleNationalID,
      this.flagVisibleFatherName,
      this.mobileNumberLength,
      this.mAlternativeCountryController,this.flagVisibleInvoiceMonth,this.flagVisibleInvoiceValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstant.AppBarColor,
          automaticallyImplyLeading: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: ColorConstant.TextColor),
              onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewHomeDashBoard(""),
                  ))),
          title: Text(
            'Profile Management',
            style: TextStyle(
                color: ColorConstant.TextColor,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans'),
          ),
        ),
        body: Card(
            elevation: 10,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Personal Details',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans'),
                        ),
                        TextFormField(
                          controller: nameTextController,
                          readOnly: true,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15.0,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Name',
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black54,
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black87,
                            ),
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
                          ),
                          decoration: InputDecoration(
                            labelText: 'Mobile',
                            labelStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 16.0,
                            ),
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
                        new TextFormField(
                          controller: userEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15.0,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Email-Id',
                            hintText: "Please Enter Email Id",
                            hintStyle: TextStyle(
                                fontSize: 15.0, color: Colors.black54),
                            labelStyle: TextStyle(
                                fontSize: 16.0, color: Colors.black87),
                            contentPadding: EdgeInsets.all(5),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black54),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter Email-Id';
                            }
                            if (!EmailValidator.validate(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.0),

                        Visibility(
                          visible: flagVisibleNationalID,
                          child: TextFormField(
                            controller: nationalIDtextController,
                            readOnly: true,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15.0,
                            ),
                            decoration: InputDecoration(
                              labelText: 'National ID',
                              hintText: "Please enter your National ID",
                              hintStyle: TextStyle(
                                  fontSize: 15.0, color: Colors.black54),
                              labelStyle: TextStyle(
                                  fontSize: 16.0, color: Colors.black87),
                              contentPadding: EdgeInsets.all(5),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
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
                        SizedBox(height: 10.0),

                        Visibility(
                          visible: flagVisibleFatherName,
                          child: TextFormField(
                            controller: mFathereNametextController,
                            readOnly: true,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15.0,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Father Name',
                              hintText: "Please enter your Father Name",
                              hintStyle: TextStyle(
                                  fontSize: 15.0, color: Colors.black54),
                              labelStyle: TextStyle(
                                  fontSize: 16.0, color: Colors.black87),
                              contentPadding: EdgeInsets.all(5),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
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

                        new TextFormField(
                          controller: userAddressController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15.0,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Address',
                            hintText: "Enter your address",
                            hintStyle: TextStyle(
                                fontSize: 15.0, color: Colors.black54),
                            labelStyle: TextStyle(
                                fontSize: 16.0, color: Colors.black87),
                            contentPadding: EdgeInsets.all(5),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black54),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: mAlternativeCountryController,
                          readOnly: true,
                          // initialValue: "Sumit",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15.0,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: 'Country Code',
                            hintStyle: TextStyle(
                                fontSize: 15.0, color: Colors.black54),
                            labelStyle: TextStyle(
                                fontSize: 16.0, color: Colors.black87),
                            contentPadding: EdgeInsets.all(5),
                            //
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.black54),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: userAlternativeNumberController,
                          maxLength: mobileNumberLength,
                          // initialValue: "Sumit",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15.0,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            hintText:
                            "Enter your alternative mobile number",
                            labelText: 'Alternative number',
                            hintStyle: TextStyle(
                                fontSize: 15.0, color: Colors.black54),
                            labelStyle: TextStyle(
                                fontSize: 16.0, color: Colors.black87),
                            contentPadding: EdgeInsets.all(5),
                            //
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.black54),
                            ),
                          ),
                        ),
//                        Row(
//                          mainAxisSize: MainAxisSize.min,
//                          children: <Widget>[
//                            Expanded(
//
//                              child: Wrap(children: <Widget>[
//
//                              ]),
//                            ),
//
//                            Expanded(
//                              child: Wrap(children: <Widget>[
//
//
//
//                              ]),
//                            ),
//                          ],
//                        ),
//
////                        new Row(
////                          children: [
////
////                          ],
////                        ),

                        SizedBox(height: 10.0),

                        InkWell(
                            onTap: onDOBClick,
//                            onTap: () {
//                            //  FocusScope.of(context).requestFocus(new FocusNode());
//                              //_selectDate(context);
//                              //  handleReadOnlyInputClick(context);
////                              showMonthPicker(
////                                context: context,
////                                firstDate: DateTime(DateTime.now().year,
////                                    DateTime.now().month - 6, DateTime.now().day),
////                                lastDate: DateTime(DateTime.now().year, DateTime.now().month,
////                                    DateTime.now().day),
////                                initialDate: DateTime.now(),
////                              ).then((date) {
////                                if (date != null) {
//////                                  setState(() {
//////                                    selectedDate = date;
//////                                    log("Seleted Date $selectedDate  ");
//////                                    convertDateFromString(selectedDate.toString());
//////                                  });
////                                }
////                              });
//                            },
                            child: TextField(
                              readOnly: true,
                              controller: userDOBController,
                              enabled: false,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 15.0,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Date of Birth',
                                hintText: "DD/MM/YY",
                                hintStyle: TextStyle(
                                    fontSize: 15.0, color: Colors.black54),
                                labelStyle: TextStyle(
                                    fontSize: 16.0, color: Colors.black87),
                                contentPadding: EdgeInsets.all(5),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black54),
                                ),
                              ),
                            )),
                        SizedBox(height: 10.0),

                        InkWell(
                            onTap: onGenderClick,
                            child: TextField(
                              readOnly: true,
                              controller: userGenderController,
                              enabled: false,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 15.0,
                              ),
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.arrow_drop_down),
                                labelText: 'Select Gender',
                                hintText: "Gender",
                                hintStyle: TextStyle(
                                    fontSize: 15.0, color: Colors.black54),
                                labelStyle: TextStyle(
                                    fontSize: 16.0, color: Colors.black87),
                                contentPadding: EdgeInsets.all(5),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black54),
                                ),
                              ),
                            )),
                        SizedBox(height: 10.0),

                        Text(
                          'Device Details',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans'),
                        ),

                        TextFormField(
                          controller: deviceNameTextController,
                          readOnly: true,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15.0,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Device Name',
                            labelStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 16.0,
                            ),
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
                          ),
                          decoration: InputDecoration(
                            labelText: 'Device Model',
                            labelStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 16.0,
                            ),
                            contentPadding: EdgeInsets.all(5),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black54),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: deviceImeiTextController,
                          readOnly: true,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15.0,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Device IMEI',
                            labelStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 16.0,
                            ),
                            contentPadding: EdgeInsets.all(5),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black54),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Visibility(
                          visible: flagVisibleInvoiceValue,
                          child:TextFormField(
                            controller: invoiceAmountTextController,
                            readOnly: true,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15.0,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Invoice Amount' +
                                  '(' +
                                  PreferenceUtils.getString(
                                      Utils.CURRENCYFORPREFRENCE) +
                                  ')',
                              labelStyle: TextStyle(
                                color: Colors.black87,
                                fontSize: 16.0,
                              ),
                              contentPadding: EdgeInsets.all(5),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10.0),
                        Visibility(
                          visible:flagVisibleInvoiceMonth ,
                          child:TextFormField(
                            controller: invoiceDateTextController,
                            readOnly: true,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15.0,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Invoice Month/Year',
                              labelStyle: TextStyle(
                                color: Colors.black87,
                                fontSize: 16.0,
                              ),
                              contentPadding: EdgeInsets.all(5),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10.0),

//
//                        SizedBox(
//                          width: double.infinity,
//                          child: Column(
//                            children: <Widget>[
//                              RaisedButton(
//                                onPressed: onSubmitClick,
//                                color: Colors.lightBlueAccent,
//                                textColor: Colors.white,
//                                child: Text('SUBMIT'),
//                              ),
//                              // This makes the blue container full width.
//                            ],
//                          ),
//                        ),
                        Container(
                          margin: new EdgeInsets.symmetric(horizontal: 10.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(3.2),
                              ),
                              color: ColorConstant.ButtonColor,
                              onPressed: onSubmitClick,
                              child: Text(
                                "SUBMIT",
                                style: new TextStyle(
                                    fontSize: 16,
                                    color: ColorConstant.TextColor,
                                    fontFamily: 'Raleway'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            )));
  }
}
