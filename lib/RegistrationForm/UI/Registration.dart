import 'dart:core';
import 'dart:developer';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/ui/registrationCofirm/RegistrationConfirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info/device_info.dart';
import 'dart:io' show Platform;
import 'package:email_validator/email_validator.dart';
import 'package:date_format/date_format.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:imei_plugin/imei_plugin.dart';

class Registration extends StatefulWidget {
  @override
  Confirm createState() => Confirm();
}

String appBarName = "User Registration Form";
DateTime initialDate;
DeviceInfoPlugin deviceInfo =
    DeviceInfoPlugin(); // instantiate device info plugin
AndroidDeviceInfo androidDeviceInfo;
IosDeviceInfo iosDeviceInfo;
String _platformImei = 'Unknown';
String uniqueId = "Unknown";

String board,
    brand,
    device,
    hardware,
    host,
    id,
    manufacture,
    model,
    product,
    type,
    androidid,
    release,
    deviceIemiNumber = "";
bool isphysicaldevice;
int sdkInt;
final myController = TextEditingController();

class Confirm extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var title = appBarName;
    return  Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: new TextStyle(
              fontSize: 17, color: Colors.white, fontFamily: 'Raleway'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Page(),
    );
  }
}

class Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegistrationFormState();
  }
}

class RegistrationFormState extends State<Page> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var firebaseAuth;
  TextEditingController _userFirstNameController = TextEditingController();
  TextEditingController _userLastNameController = TextEditingController();
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _inVoiceAmmountController = TextEditingController();
  TextEditingController _inVoiceDateController = TextEditingController();
  DateTime selectedDate;
  String verificationId;
  AuthCredential phoneAuthCredential;
  var mCountryCode;
  var registerDate;
  var UserNumber;

  bool get hasFocus => false;

  @override
  void initState() {
    PreferenceUtils.init();
    UserNumber = PreferenceUtils.getString(Utils.UserNumber);
    _phoneNumberController.text = UserNumber;
    getDeviceinfo();
    if (Platform.isAndroid) {
      initPlatformState();
    } else {
      // iOS-specific code
    }

    if (Platform.isAndroid) {
      Future.delayed(Duration(seconds: 5), () async {
        initPlatformState();
      });
    } else {
      // iOS-specific code
    }

    super.initState();
  }

  Future<void> initPlatformState() async {
    String platformImei;
    String idunique;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      idunique = await ImeiPlugin.getImei();
      deviceIemiNumber = idunique;
      print('deviceIemiNumber ====  $deviceIemiNumber');
    } on PlatformException {
      platformImei = 'Failed to get platform version.';
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    new TextFormField(
                      controller: _userFirstNameController,
                      // initialValue: "Sumit",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: "Please Enter First Name",
                        labelText: 'First Name*',
                        hintStyle:
                            TextStyle(fontSize: 15.0, color: Colors.black54),
                        labelStyle:
                            TextStyle(fontSize: 16.0, color: Colors.lightBlue),
                        contentPadding: EdgeInsets.all(5),
                        //
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue),
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter First Name';
                        }
                        if (value.length <= 2) {
                          return 'User Name should be aleast 3 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.0),
                    new TextFormField(
                      controller: _userLastNameController,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Last Name*',
                        hintText: "Please Enter Last Name",
                        hintStyle:
                            TextStyle(fontSize: 15.0, color: Colors.black54),
                        labelStyle:
                            TextStyle(fontSize: 16.0, color: Colors.lightBlue),
                        contentPadding: EdgeInsets.all(5),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue),
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter Last Name*';
                        }
                        if (value.length <= 2) {
                          return 'User Name should be aleast 3 characters';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        print(value);
                      },
                    ),
                    SizedBox(height: 10.0),
                    new TextFormField(
                      controller: _userEmailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Email-Id*',
                        hintText: "Please Enter Email Id",
                        hintStyle:
                            TextStyle(fontSize: 15.0, color: Colors.black54),
                        labelStyle:
                            TextStyle(fontSize: 16.0, color: Colors.lightBlue),
                        contentPadding: EdgeInsets.all(5),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue),
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Email-Id*';
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
                      controller: _phoneNumberController,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 17.0,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Mobile Number*',
                        hintStyle:
                            TextStyle(fontSize: 15.0, color: Colors.lightBlue),
                        labelStyle:
                            TextStyle(fontSize: 16.0, color: Colors.lightBlue),
                        contentPadding: EdgeInsets.all(5),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    new TextFormField(
                      maxLength: 5,
                      keyboardType: TextInputType.number,
                      controller: _inVoiceAmmountController,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Invoice Amount (USD)*',
                        hintText: 'Please Enter Invoice Amount',
                        hintStyle:
                            TextStyle(fontSize: 15.0, color: Colors.black54),
                        labelStyle:
                            TextStyle(fontSize: 16.0, color: Colors.lightBlue),
                        contentPadding: EdgeInsets.all(5),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue),
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Invoice Amount (USD)*';
                        }
                        return null;
                      },
                    ),
                    InkWell(
                        onTap: () {
                          handleReadOnlyInputClick(context);
                        },
                        child: TextField(
                          readOnly: true,
                          controller: _inVoiceDateController,
                          enabled: false,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15.0,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Invoice Date*',
                            hintStyle: TextStyle(
                                fontSize: 15.0, color: Colors.black54),
                            labelStyle: TextStyle(
                                fontSize: 16.0, color: Colors.lightBlue),
                            contentPadding: EdgeInsets.all(5),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlue),
                            ),
                          ),
                        )),
                    SizedBox(height: 10.0),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                if (registerDate == null) {
                                  mToast(Utils.InvoiceDate);
                                } else {
                                  var userLastName =
                                      _userLastNameController.text.toString();
                                  var userFirstName = _userFirstNameController
                                          .text
                                          .toString() +
                                      " " +
                                      _userLastNameController.text.toString();
                                  var userEmail =
                                      _userEmailController.text.toString();
                                  var userPhoneNumber =
                                      _phoneNumberController.text.toString();
                                  var userInvoiceAmount =
                                      _inVoiceAmmountController.text.toString();
                                  var userInvoiceDate =
                                      _inVoiceDateController.text.toString();

//                                  Navigator.pushReplacement(
//                                    context,
//                                    MaterialPageRoute(
//                                        builder: (context) =>
//                                            RegistrationConfirm(
//                                                userFirstName,
//                                                userEmail,
//                                                userPhoneNumber,
//                                                userInvoiceAmount,
//                                                userInvoiceDate,deviceIemiNumber)),
//                                  );
                                }
                              }
                            },
                            color: Colors.lightBlueAccent,
                            textColor: Colors.white,
                            child: Text('Next'),
                          ),
                          // This makes the blue container full width.
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }

  void getDeviceinfo() async {
    if (Platform.isAndroid) {
      androidDeviceInfo = await deviceInfo
          .androidInfo; // instantiate Android Device Infoformation
      if (androidDeviceInfo != null) {
        brand = androidDeviceInfo.brand;
        manufacture = androidDeviceInfo.manufacturer;
        model = androidDeviceInfo.model;
        release = androidDeviceInfo.version.release;
        //sdkInt = androidDeviceInfo.version.sdkInt as String;
        id = androidDeviceInfo.androidId;
        if (brand == null) {
          PreferenceUtils.setString(Utils.MobileBrand, brand);
        } else {
          PreferenceUtils.setString(Utils.MobileBrand, manufacture);
        }
        if (model != null) {
          PreferenceUtils.setString(Utils.MobileModel, model);
        }
        if (id != null) {
          PreferenceUtils.setString(Utils.MobileID, id);
        }
        if (release != null) {
          PreferenceUtils.setString(Utils.MobileOS, release);
        }

        PreferenceUtils.setString(Utils.DeviceType, "Android");
      }
      log('Device Model : $model');
      log('Device brand : $brand');
      log('release  : $release');

      //  log('sdkInt  : $sdkInt');
    } else if (Platform.isIOS) {
      iosDeviceInfo = await deviceInfo.iosInfo;
      if (iosDeviceInfo != null) {
        brand = "iPhone";
        model = iosDeviceInfo.model;
        id = "";
        var version = iosDeviceInfo.systemVersion;
        PreferenceUtils.setString(Utils.MobileID, id);
        if (brand != null) {
          PreferenceUtils.setString(Utils.MobileBrand, brand);
        }
        if (model != null) {
          PreferenceUtils.setString(Utils.MobileModel, model);
        }

        if (version != null) {
          PreferenceUtils.setString(Utils.MobileOS, version);
        }

        PreferenceUtils.setString(Utils.DeviceType, "IOS");
      }
    }
  }

  void handleReadOnlyInputClick(mContext) {
    log('Callender Method Called');
//    int CurrentYear = DateTime(DateTime.now().year+0,1);
//    int UptoYear = DateTime.now().year - 2;
//    print(DateTime.now().year);
//    print(DateTime.now().month);
//    print(DateTime.now().day);
//    print(DateTime(DateTime.now().year , DateTime.now().month-6, DateTime.now().day));
//    print(DateTime(DateTime.now().year , DateTime.now().month, DateTime.now().day));
    showBottomSheet(
        context: mContext,
        builder: (BuildContext context) => Container(
              width: MediaQuery.of(context).size.width,
              child: MonthPicker(
                selectedDate: DateTime.now(),
                firstDate: DateTime(DateTime.now().year,
                    DateTime.now().month - 6, DateTime.now().day),
//                lastDate: DateTime(DateTime.now().year + 1, 9),
//                firstDate: DateTime(UptoYear),
                lastDate: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day),
                onChanged: (val) {
                  convertDateFromString(val.toString());
                  Navigator.pop(context);
                },
              ),
            ));
  }

  void convertDateFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);
    print(todayDate);
    setState(() {
      registerDate = (formatDate(todayDate, [yyyy, '-', mm, '-', dd]));
      log('register Date $registerDate');
      _inVoiceDateController.text = registerDate;
    });
  }

  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }
}

//class RegisForm extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    return MyCustomFormState();
//  }
//}
//
//
//class MyCustomFormState extends State<RegisForm> {
//
//
//  @override
//  Widget build(BuildContext context) {
//    // Build a Form widget using the _formKey created above.
//    return Form(
//      key: _formKey,
//      child: SingleChildScrollView(
//        child: Column(
//          children: <Widget>[
//            new TextFormField(
//              controller: _userFirstNameController,
//              // initialValue: "Sumit",
//              style: TextStyle(
//                color: Colors.blue,
//                fontSize: 17.0,
//              ),
//              decoration: InputDecoration(
//                hintText: "Please Enter First Name",
//                labelText: 'First Name*',
//                labelStyle: TextStyle(color: Colors.blue),
//                contentPadding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
//                enabledBorder: UnderlineInputBorder(
//                  borderSide: BorderSide(color: Colors.blue),
//                ),
//              ),
//              validator: (value) {
//                if (value.isEmpty) {
//                  return 'Enter First Name';
//                }
//                if (value.length <= 2) {
//                  return 'User Name should be aleast 3 characters';
//                }
//                return null;
//              },
//            ),
//            SizedBox(height: 10.0),
//            new TextFormField(
//              controller: _userLastNameController,
//              style: TextStyle(
//                color: Colors.blue,
//                fontSize: 17.0,
//              ),
//              decoration: InputDecoration(
//                labelText: 'Last Name*',
//                hintText: "Please Enter Last Name",
//                labelStyle: TextStyle(color: Colors.blue),
//                contentPadding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
//                enabledBorder: UnderlineInputBorder(
//                  borderSide: BorderSide(color: Colors.blue),
//                ),
//              ),
//              validator: (value) {
//                if (value.isEmpty) {
//                  return 'Please enter Last Name*';
//                }
//                if (value.length <= 2) {
//                  return 'User Name should be aleast 3 characters';
//                }
//                return null;
//              },
//              onSaved: (String value) {
//                print(value);
//              },
//            ),
//            SizedBox(height: 10.0),
//            new TextFormField(
//              controller: _userEmailController,
//              keyboardType: TextInputType.emailAddress,
//              style: TextStyle(
//                color: Colors.blue,
//                fontSize: 17.0,
//              ),
//              decoration: InputDecoration(
//                labelText: 'Email-Id*',
//                hintText: "Please Enter Email Id",
//                labelStyle: TextStyle(color: Colors.blue),
//                contentPadding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
//                enabledBorder: UnderlineInputBorder(
//                  borderSide: BorderSide(color: Colors.blue),
//                ),
//              ),
//              validator: (value) {
//                if (value.isEmpty) {
//                  return 'Email-Id*';
//                }
//                if (!EmailValidator.validate(value)) {
//                  return 'Please enter a valid email';
//                }
//                return null;
//              },
//            ),
//            SizedBox(height: 10.0),
//            new TextFormField(
//              enabled: false,
//              keyboardType: TextInputType.number,
//              controller: _phoneNumberController,
//              style: TextStyle(
//                color: Colors.blue,
//                fontSize: 17.0,
//              ),
//              decoration: InputDecoration(
//                hintText: 'Enter Mobile Number',
//                labelText: 'Mobile Number*',
//                labelStyle: TextStyle(color: Colors.blue),
//                contentPadding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
//                enabledBorder: UnderlineInputBorder(
//                  borderSide: BorderSide(color: Colors.blue),
//                ),
//              ),
//            ),
//            SizedBox(height: 10.0),
//            new TextFormField(
//              keyboardType: TextInputType.number,
//              controller: _inVoiceAmmountController,
//              style: TextStyle(
//                color: Colors.blue,
//                fontSize: 17.0,
//              ),
//              decoration: InputDecoration(
//                labelText: 'Invoice Amount (USD)*',
//                hintText: 'Please Enter Invoice Amount',
//                labelStyle: TextStyle(color: Colors.blue),
//                contentPadding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
//                enabledBorder: UnderlineInputBorder(
//                  borderSide: BorderSide(color: Colors.blue),
//                ),
//              ),
//              validator: (value) {
//                if (value.isEmpty) {
//                  return 'Invoice Amount (USD)*';
//                }
//                return null;
//              },
//            ),
//            InkWell(
//                onTap: () {
//                  handleReadOnlyInputClick(context);
//                },
//                child: TextField(
//                  controller: _inVoiceDateController,
//                  enabled: false,
//                  style: TextStyle(
//                    color: Colors.blue,
//                    fontSize: 17.0,
//                  ),
//                  decoration: InputDecoration(
//                    labelText: 'Invoice Date*',
//                    labelStyle: TextStyle(color: Colors.blue),
//                    contentPadding:
//                        new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
//                    enabledBorder: UnderlineInputBorder(
//                      borderSide: BorderSide(color: Colors.blue),
//                    ),
//                  ),
//                )),
//            SizedBox(height: 10.0),
//            SizedBox(
//              width: double.infinity,
//              child: Column(
//                children: <Widget>[
//                  RaisedButton(
//                    onPressed: () {
//                      if (_formKey.currentState.validate()) {
//                        _formKey.currentState.save();
//                        if (registerDate == null) {
//                          mToast(Utils.InvoiceDate);
//                        } else {
//                          var userLastName =
//                              _userLastNameController.text.toString();
//                          var userFirstName =
//                              _userFirstNameController.text.toString() +
//                                  " " +
//                                  _userLastNameController.text.toString();
//                          var userEmail = _userEmailController.text.toString();
//                          var userPhoneNumber =
//                              _phoneNumberController.text.toString();
//                          var userInvoiceAmount =
//                              _inVoiceAmmountController.text.toString();
//                          var userInvoiceDate =
//                              _inVoiceDateController.text.toString();
//
//                          Navigator.pushReplacement(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) => RegistrationConfirm(
//                                    userFirstName,
//                                    userEmail,
//                                    userPhoneNumber,
//                                    userInvoiceAmount,
//                                    userInvoiceDate)),
//                          );
//                        }
//                      }
//                    },
//                    color: Colors.blue,
//                    textColor: Colors.white,
//                    child: Text('Next'),
//                  ),
//                  // This makes the blue container full width.
//                ],
//              ),
//            )
//
////            new RaisedButton(
////              onPressed: () {
////                handleReadOnlyInputClick(context);
////              },
////              child: new Text('Click me'),
////            )
//          ],
//        ),
//      ),
//    );
//  }
//
//  void getDeviceinfo() async {
//    if (Platform.isAndroid) {
//      androidDeviceInfo = await deviceInfo
//          .androidInfo; // instantiate Android Device Infoformation
//      if (androidDeviceInfo != null) {
//        brand = androidDeviceInfo.manufacturer;
//        model = androidDeviceInfo.model;
//        release = androidDeviceInfo.version.release;
//        //sdkInt = androidDeviceInfo.version.sdkInt as String;
//        id = androidDeviceInfo.androidId;
//        if (brand != null) {
//          PreferenceUtils.setString(Utils.MobileBrand, brand);
//        }
//        if (model != null) {
//          PreferenceUtils.setString(Utils.MobileModel, model);
//        }
//        if (id != null) {
//          PreferenceUtils.setString(Utils.MobileID, id);
//        }
//        if (release != null) {
//          PreferenceUtils.setString(Utils.MobileOS, release);
//        }
//
//        PreferenceUtils.setString(Utils.DeviceType, "Android");
//      }
//      log('Device Model : $model');
//      log('Device brand : $brand');
//      log('release  : $release');
//
//      //  log('sdkInt  : $sdkInt');
//    } else if (Platform.isIOS) {
//      iosDeviceInfo = await deviceInfo.iosInfo;
//      if (iosDeviceInfo != null) {
//        brand = "iPhone";
//        model = iosDeviceInfo.model;
//        id = "";
//        var version = iosDeviceInfo.systemVersion;
//        PreferenceUtils.setString(Utils.MobileID, id);
//        if (brand != null) {
//          PreferenceUtils.setString(Utils.MobileBrand, brand);
//        }
//        if (model != null) {
//          PreferenceUtils.setString(Utils.MobileModel, model);
//        }
//
//        if (version != null) {
//          PreferenceUtils.setString(Utils.MobileOS, version);
//        }
//
//        PreferenceUtils.setString(Utils.DeviceType, "IOS");
//      }
//    }
//  }
//
//  void handleReadOnlyInputClick(mContext) {
//    log('Callender Method Called');
//    int CurrentYear = DateTime.now().year;
//    int UptoYear = DateTime.now().year - 2;
//    showBottomSheet(
//        context: mContext,
//        builder: (BuildContext context) => Container(
//              width: MediaQuery.of(context).size.width,
//              child: MonthPicker(
//                selectedDate: DateTime(CurrentYear),
//                firstDate: DateTime(UptoYear),
//                lastDate: DateTime.now(),
//                onChanged: (val) {
//                  convertDateFromString(val.toString());
//                  Navigator.pop(context);
//                },
//              ),
//            ));
//  }
//
//  void convertDateFromString(String strDate) {
//    DateTime todayDate = DateTime.parse(strDate);
//    print(todayDate);
//    setState(() {
//      registerDate = (formatDate(todayDate, [yyyy, '-', mm, '-', dd]));
//      log('register Date $registerDate');
//      _inVoiceDateController.text = registerDate;
//    });
//  }
//
//  void mToast(String message) {
//    Toast.show(message, context,
//        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
//  }
//}
