import 'dart:io';
import 'dart:math';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/apis/apis.dart';
import 'package:altruist_secure_flutter/blocs/login_process/bloc.dart';
import 'package:altruist_secure_flutter/blocs/login_process/otp_login_process_bloc.dart';
import 'package:altruist_secure_flutter/models/responses/cuntryinfo/CuntryResponseModel.dart';
import 'package:altruist_secure_flutter/ui/EnterOtpProcess/CountryModel.dart';
import 'package:altruist_secure_flutter/ui/EnterOtpProcess/EnterOtpProcessForm.dart';
import 'package:altruist_secure_flutter/ui/loginProcess/OtpVerification.dart';
import 'package:altruist_secure_flutter/utils/app_utils.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:package_info/package_info.dart';

class EnterOtpProcess extends StatefulWidget {
  @override
  _EnterOtpProcessProcessState createState() => _EnterOtpProcessProcessState();
}

class _EnterOtpProcessProcessState extends State<EnterOtpProcess> {
  OtpLoginProcessBloc _bloc;
  TextEditingController _userFirstNameController;
  TextEditingController _userCountryCode;
  GlobalKey<FormState> _formKey;
  var mCountryCode;
  var registerDate;
  bool isphysicaldevice;
  AndroidDeviceInfo androidDeviceInfo;
  IosDeviceInfo iosDeviceInfo;
  String appBarName_ = "OTP Screen";
  CountryList operatorConfig;
  var mNumber = "";
  var mCountryCode_ = "";
  var mCountryName_ = "";
  var mpolicyWordingLink_ = "";
  int mobileNumberLength_;
  List<CountryModel> itemList = new List();
  PackageInfo packageInfo;
  String packageName;
  String appName;
  String hintName_;
  bool mSponserText_ = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      initPlatformState();
    } else {
      initPlatformStateIOS();
      // iOS-specific code
    }
    _bloc = OtpLoginProcessBloc(apisRepository: ApisRepository());
    _bloc.add(FetchCountryEvent());
    _formKey = GlobalKey<FormState>();
    _userFirstNameController = TextEditingController();
    _userCountryCode = TextEditingController();

    setState(() {});

//     itemListLenght = itemList.length;
//
//    print("Country List length in the starting $itemListLenght");
//
  }

  Future<void> initPlatformStateIOS() async {
    packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    print("App Name ===== $appName");
    print("Package Name  ===== $packageName");
    PreferenceUtils.setString(Utils.appPackageName, packageName);

    if (packageName == "com.insurance.atpl.altruist_secure_flutter" ||
        packageName == "com.insurance.altruistSecureFlutter") {
      mSponserText_ = true;
    } else {
      mSponserText_ = false;
    }
  }

  Future<void> initPlatformState() async {
    packageInfo = await PackageInfo.fromPlatform();
    String platformImei;
    String idunique;

    appName = packageInfo.appName;
    packageName = packageInfo.packageName;

    print("App Name ===== $appName");
    print("Package Name  ===== $packageName");
    PreferenceUtils.setString(Utils.appPackageName, packageName);

    // Platform messages may fail, so we use a try/catch PlatformException.

    if (packageName == "com.insurance.atpl.altruist_secure_flutter" ||
        packageName == "com.insurance.altruistSecureFlutter") {
      mSponserText_ = true;
    } else {
      mSponserText_ = false;
    }
    try {
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      idunique = await ImeiPlugin.getImei();
      var deviceIemiNumber = idunique;
      print('deviceIemiNumber ====  $deviceIemiNumber');
    } on Exception {
      platformImei = 'Failed to get platform version.';
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: BlocListener(
          bloc: _bloc,
          listener: (BuildContext context, OtpLoginProcessState state) {
            if (state is IntialCuntryInfoState) {
              if (state.isLoading == false && !state.isSuccess) {
                AppUtils.showSnackBar(context, state.message);
                mCountryCode_ = "";
                mCountryName_ = "";
              } else if (state.isLoading == false && state.isSuccess) {
                itemList = new List();
                if (state.countryList != null) {
                  for (int i = 0; i < state.countryList.length; i++) {
                    //  print("state.countryList[i].countryCode === ${state.countryList[i].countryCode} ");
                    //   if (appName == "Noon Secure" || appName == "Altruist Secure-R3F") {
                    if (packageName == "com.app.noon_secure" ||
                        packageName == "com.insurance.noonSecure" ||
                        packageName == "com.r3factory" ||
                        packageName == "com.insurance.altruistSecureR3") {
                      if (state.countryList[i].countryCode == "971") {
                        mCountryCode_ = state.countryList[i].countryCode;
                        //      print("Country Code is for Noon Secure  and Altruist Secure-R3F === ${mCountryCode_ }");
                        itemList.add(CountryModel(
                          id: state.countryList[i].id,
                          countryName: state.countryList[i].countryName,
                          countryCode: state.countryList[i].countryCode,
                          status: state.countryList[i].status,
                          mobileNumberLength:
                              state.countryList[i].mobileNumberLength,
                          policyWordingLink:
                              state.countryList[i].policyWordingLink,
                        ));
                      }
                    } else if (packageName ==
                            "com.insurance.atpl.altruist_secure_flutter" ||
                        packageName == "com.insurance.altruistSecureFlutter") {
                      if (state.countryList[i].countryCode == "971") {
                      } else {
                        itemList.add(CountryModel(
                          id: state.countryList[i].id,
                          countryName: state.countryList[i].countryName,
                          countryCode: state.countryList[i].countryCode,
                          status: state.countryList[i].status,
                          mobileNumberLength:
                              state.countryList[i].mobileNumberLength,
                          policyWordingLink:
                              state.countryList[i].policyWordingLink,
                        ));
                      }
                    } else if (packageName == "com.app.mansardecure_secure") {
                      if (state.countryList[i].countryCode == "234" ||
                          state.countryList[i].countryCode == "91") {
                        itemList.add(CountryModel(
                          id: state.countryList[i].id,
                          countryName: state.countryList[i].countryName,
                          countryCode: state.countryList[i].countryCode,
                          status: state.countryList[i].status,
                          mobileNumberLength:
                              state.countryList[i].mobileNumberLength,
                          policyWordingLink:
                              state.countryList[i].policyWordingLink,
                        ));
                      }
                    } else if (packageName ==
                        "com.app.altruist_secure_nigeria") {
                      if (state.countryList[i].countryCode == "234" ||
                          state.countryList[i].countryCode == "91") {
                        itemList.add(CountryModel(
                          id: state.countryList[i].id,
                          countryName: state.countryList[i].countryName,
                          countryCode: state.countryList[i].countryCode,
                          status: state.countryList[i].status,
                          mobileNumberLength:
                              state.countryList[i].mobileNumberLength,
                          policyWordingLink:
                              state.countryList[i].policyWordingLink,
                        ));
                      }
                    } else {
                      if (state.countryList[i].countryCode.trim() == "88" ||
                          state.countryList[i].countryCode.trim() == "91") {
                        itemList.add(CountryModel(
                          id: state.countryList[i].id,
                          countryName: state.countryList[i].countryName,
                          countryCode: state.countryList[i].countryCode,
                          status: state.countryList[i].status,
                          mobileNumberLength:
                              state.countryList[i].mobileNumberLength,
                          policyWordingLink:
                              state.countryList[i].policyWordingLink,
                        ));
                      }
                    }
                  }
                  print("Array List Content ${itemList.length} ");
                  if (itemList != null && itemList.length > 0) {
                    if (PreferenceUtils.getString(Utils.SimCountryCode) !=
                            null &&
                        PreferenceUtils.getString(Utils.SimCountryCode) != "") {
                      hintName_ = "Please Enter Mobile Number";
                      for (int i = 0; i < itemList.length; i++) {
                        var SimCountryCode =
                            PreferenceUtils.getString(Utils.SimCountryCode)
                                .toLowerCase();
                        print('SimCountryCode === $SimCountryCode');
                        if (SimCountryCode == "ng") {
                          if (itemList[i].countryCode == "234") {
                            mCountryCode_ = itemList[i].countryCode;
                            mCountryName_ = itemList[i].countryName;
                            mobileNumberLength_ =
                                itemList[i].mobileNumberLength;
                            mpolicyWordingLink_ = itemList[i].policyWordingLink;
                            PreferenceUtils.setString(
                                Utils.POLICYWORDING, mpolicyWordingLink_);
                          }
                        } else if (SimCountryCode == "ke") {
                          if (itemList[i].countryCode == "254") {
                            mCountryCode_ = itemList[i].countryCode;
                            mCountryName_ = itemList[i].countryName;
                            mobileNumberLength_ =
                                itemList[i].mobileNumberLength;
                            mpolicyWordingLink_ = itemList[i].policyWordingLink;
                            PreferenceUtils.setString(
                                Utils.POLICYWORDING, mpolicyWordingLink_);
                          }
                        } else if (SimCountryCode == "gh") {
                          if (itemList[i].countryCode == "233") {
                            mCountryCode_ = itemList[i].countryCode;
                            mCountryName_ = itemList[i].countryName;
                            mobileNumberLength_ =
                                itemList[i].mobileNumberLength;
                            mpolicyWordingLink_ = itemList[i].policyWordingLink;
                            PreferenceUtils.setString(
                                Utils.POLICYWORDING, mpolicyWordingLink_);
                          }
                        } else if (SimCountryCode == "id") {
                          if (itemList[i].countryCode == "62") {
                            mCountryCode_ = itemList[i].countryCode;
                            mCountryName_ = itemList[i].countryName;
                            mobileNumberLength_ =
                                itemList[i].mobileNumberLength;
                            mpolicyWordingLink_ = itemList[i].policyWordingLink;
                            PreferenceUtils.setString(
                                Utils.POLICYWORDING, mpolicyWordingLink_);
                          }
                        } else if (SimCountryCode == "bd") {
                          if (itemList[i].countryCode == "88") {
                            mCountryCode_ = itemList[i].countryCode;
                            mCountryName_ = itemList[i].countryName;
                            mobileNumberLength_ =
                                itemList[i].mobileNumberLength;
                            mpolicyWordingLink_ = itemList[i].policyWordingLink;
                            hintName_ = "eg 01 xx xx xx xx x";
                            PreferenceUtils.setString(
                                Utils.POLICYWORDING, mpolicyWordingLink_);
                          }
                        } else if (SimCountryCode == "ae") {
                          if (itemList[i].countryCode == "971") {
                            mCountryCode_ = itemList[i].countryCode;
                            mCountryName_ = itemList[i].countryName;
                            mobileNumberLength_ =
                                itemList[i].mobileNumberLength;
                            mpolicyWordingLink_ = itemList[i].policyWordingLink;
                            PreferenceUtils.setString(
                                Utils.POLICYWORDING, mpolicyWordingLink_);
                          }
                        } else if (SimCountryCode == "lk") {
                          if (itemList[i].countryCode == "94") {
                            mCountryCode_ = itemList[i].countryCode;
                            mCountryName_ = itemList[i].countryName;
                            mobileNumberLength_ =
                                itemList[i].mobileNumberLength;
                            mpolicyWordingLink_ = itemList[i].policyWordingLink;
                            PreferenceUtils.setString(
                                Utils.POLICYWORDING, mpolicyWordingLink_);
                          }
                        } else {
                          mCountryCode_ = "";
                          mCountryName_ = "";
                          mobileNumberLength_ = 10;
                        }
                      }
                    } else {
                      mCountryCode_ = "";
                      mCountryName_ = "";
                      mobileNumberLength_ = 10;
                    }
                  } else {
                    hintName_ = "Please Enter Mobile Number";
                    mCountryCode_ = "";
                    mCountryName_ = "";
                    mobileNumberLength_ = 10;
                  }
                  print("mCountryCode_ in the api end  $mCountryCode_");
                  setState(() {
                    PreferenceUtils.setString(Utils.COUNTRY_ID, mCountryCode_);
                    _userCountryCode.text =
                        ("+" + mCountryCode_ + " " + mCountryName_);
                  });
                }
              }
            }

            if (state is EailInfoState) {
              if (state.isLoading == false && !state.isSuccess) {
                AppUtils.showSnackBar(context, state.message);
              } else if (state.isLoading == false && state.isSuccess) {
                AppUtils.showSnackBar(context, state.message);
              }
            }
          },
          child: BlocBuilder(
            bloc: _bloc,
            builder: (context, OtpLoginProcessState state) {
              return ModalProgressHUD(
                color: Colors.black,
                inAsyncCall:
                    state is IntialCuntryInfoState && state.isLoading != null
                        ? state.isLoading
                        : false,
                child: EnterOtpProcessForm(
                  formKey: _formKey,
                  userNumber: _userFirstNameController,
                  userCountryCode: _userCountryCode,
                  mobileNumberLength: mobileNumberLength_,
                  hintName: hintName_,
                  mSponserText: mSponserText_,
                  onCountryCodeClick: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Country Codes'),
                            content: Container(
                              height: 400.0,
                              width: 300.0,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: itemList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                      title: Text("+" +
                                          itemList[index].countryCode +
                                          "   " +
                                          itemList[index].countryName),
                                      onTap: () {
                                        Navigator.pop(context, true);
                                        mCountryCode_ =
                                            itemList[index].countryCode;
                                        mCountryName_ =
                                            itemList[index].countryName;
                                        mobileNumberLength_ =
                                            itemList[index].mobileNumberLength;
                                        mpolicyWordingLink_ =
                                            itemList[index].policyWordingLink;

                                        if (itemList[index].countryCode ==
                                            "88") {
                                          setState(() {
                                            hintName_ = " eg 01 xx xx xx xx x";
                                          });
                                        } else {
                                          setState(() {
                                            hintName_ =
                                                "Please Enter Mobile Number";
                                          });
                                        }

                                        setdataOnClick(
                                            mobileNumberLength_,
                                            mCountryCode_,
                                            mCountryName_,
                                            mpolicyWordingLink_);
                                      });
                                },
                              ),
                            ),
                          );
                        });
                  },
                  onNextClick: () {
                    EventTracker.logEvent("ON_REGISTRATION_NEXT_CLICK");
                    int numberlenght =
                        (_userFirstNameController.text.toString().length);
                    print("numberlenght  === $numberlenght");
                    print(
                        "_userCountryCode.text.toString()  === ${_userCountryCode.text.toString()}");
                    print(
                        "_userCountryCode.text.toString().length  === ${_userCountryCode.text.toString().length}");
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      if (_userFirstNameController.text.toString().isEmpty) {
                        //mToast(Utils.InvoiceDate);
                      } else if (_userCountryCode.text.toString() == null ||
                          _userCountryCode.text.toString().isEmpty) {
                        mToast(Utils.CountryCode);
                      } else if ((_userCountryCode.text.toString().length) <=
                          2) {
                        mToast("Please select country code");
                      } else if (numberlenght < mobileNumberLength_) {
                        mToast("Please enter right number");
                      } else {
                        if (PreferenceUtils.getString(Utils.appPackageName) ==
                                "com.app.altruists_secure_bangla" ||
                            PreferenceUtils.getString(Utils.appPackageName) ==
                                "com.app.altruists-secure-bangla") {
                          String CheckNumber = _userFirstNameController.text
                              .toString()
                              .substring(0, 3);
                          print("Check Number  =====  $CheckNumber");
//                          if (CheckNumber == "013" || CheckNumber == "017") {
//                            mIntent(
//                                mCountryCode_ +
//                                    _userFirstNameController.text.toString(),
//                                _userCountryCode.text.toString());
//                          } else {
//                            //  mDialogPop(Utils.GraminOperatorMessage);
//                            mDailog(Utils.GraminOperatorMessage);
//                          }
                          mIntent(mCountryCode_ + _userFirstNameController.text.toString(), _userCountryCode.text.toString());

                        } else {
                          mIntent(
                              mCountryCode_ +
                                  _userFirstNameController.text.toString(),
                              _userCountryCode.text.toString());
                        }
                      }
                    }
                  },
                  //  operatorConfig: operatorConfig == null ? null : operatorConfig,
                ),
              );
            },
          ),
        ));
  }

  void setdataOnClick(
      int NumberLenght, String CunrtyCode, String CuntryName, String Policy) {
    setState(() {
      mobileNumberLength_ = NumberLenght;
      _userCountryCode.text = ("+" + CunrtyCode + " " + CuntryName);
      // print("Country Code ${_userCountryCode.text.toString()}");
      print("Country mobileNumberLength $mobileNumberLength_");
      print("Country mpolicyWordingLink_ $Policy");
      PreferenceUtils.setString(
          Utils.MOBILE_NUMBER_LENTH, mobileNumberLength_.toString());
      PreferenceUtils.setString(Utils.COUNTRY_ID, CunrtyCode);
      PreferenceUtils.setString(Utils.POLICYWORDING, mpolicyWordingLink_);
    });
  }

  void mIntent(String mNumber, mCountryID) {
    print('Country Code $mCountryID');
    var number = _userFirstNameController.text.toString();
    print(mNumber);
    EventTracker.logEventWithParams("ENTER_NUMBER_SCREEN", mNumber);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => OtpVerification(mNumber, mCountryID, number),
          settings: RouteSettings(name: 'OtpVerification')),
    );
  }

  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

  Future mDialogPop(String message) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetAnimationDuration: const Duration(milliseconds: 100),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            // use container to change width and height
            height: 250,
            width: 200,
            child: Column(
              children: <Widget>[
                FlatButton(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      message,
                      style: TextStyle(
                        color: ColorConstant.SponserTextColor,
                        fontFamily: 'OpenSans',
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void mDailog(textHeading) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              width: 250,
              height: 200,
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  Text(textHeading,
                      style: TextStyle(
                        color: ColorConstant.SponserTextColor,
                        fontFamily: 'OpenSans',
                        fontSize: 16.0,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Ok",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: ColorConstant.ButtonColor,
                  )
                ],
              ),
            ),
          );
        });
  }
}
