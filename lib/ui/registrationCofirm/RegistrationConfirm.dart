import 'dart:math';
import 'package:altruist_secure_flutter/ProfileManagement/profileManagementProcess.dart';
import 'package:altruist_secure_flutter/TestList/UI/TaskList.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/apis/apis.dart';
import 'package:altruist_secure_flutter/blocs/saveUpdateUserDeviceInfo/save_update_user_device_info_bloc.dart';
import 'package:altruist_secure_flutter/blocs/saveUpdateUserDeviceInfo/save_update_user_device_info_event.dart';
import 'package:altruist_secure_flutter/blocs/saveUpdateUserDeviceInfo/save_update_user_device_info_state.dart';
import 'package:altruist_secure_flutter/models/requests/AgreeValueRequest/AgreeValueRequest.dart';
import 'package:altruist_secure_flutter/models/requests/saveUpdateUserDeviceInfo/SaveUserDeviceInfoRequestModel.dart';
import 'package:altruist_secure_flutter/ui/registrationCofirm/RegistrationConfirmationForm.dart';
import 'package:altruist_secure_flutter/utils/StringConstants.dart';
import 'package:altruist_secure_flutter/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:io' show Platform;
import 'package:imei_plugin/imei_plugin.dart';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class RegistrationConfirm extends StatefulWidget {
  String userFirstName,
      userEmail,
      userPhoneNumber,
      userInvoiceAmount,
      userInvoiceDate,
      deviceIemiNumber,
      currency,
      firstName,
      lastName,
      nationalID,
      fatherName;

  RegistrationConfirm(
      this.userFirstName,
      this.userEmail,
      this.userPhoneNumber,
      this.userInvoiceAmount,
      this.userInvoiceDate,
      this.deviceIemiNumber,
      this.currency,
      this.firstName,
      this.lastName,
      this.nationalID,
      this.fatherName);

  @override
  _RegistrationConfirmState createState() => _RegistrationConfirmState(
      userFirstName,
      userEmail,
      userPhoneNumber,
      userInvoiceAmount,
      userInvoiceDate,
      deviceIemiNumber,
      currency,
      firstName,
      lastName,
      this.nationalID,
      this.fatherName);
}

class _RegistrationConfirmState extends State<RegistrationConfirm> {
  String userFirstName,
      userEmail,
      userPhoneNumber,
      userInvoiceAmount,
      userInvoiceDate,
      deviceModel,
      deviceName,
      deviceOS,
      deviceType,
      currencyInfo,
      deviceIemiNumber;
  String _platformImei = 'Unknown';
  String uniqueId = "Unknown";
  bool imeiEditableFlag;
  String lastName, firstName, nationalID, fatherName;

  _RegistrationConfirmState(
      this.userFirstName,
      this.userEmail,
      this.userPhoneNumber,
      this.userInvoiceAmount,
      this.userInvoiceDate,
      this.deviceIemiNumber,
      this.currencyInfo,
      this.firstName,
      this.lastName,
      this.nationalID,
      this.fatherName);

  SaveUpdateUserDeviceInfoBloc _bloc;
  TextEditingController _nameTextController;
  TextEditingController _mobileNumberTextController;
  TextEditingController _emailTextController;
  TextEditingController _deviceNameTextController;
  TextEditingController _deviceModelTextController;
  TextEditingController _deviceImeiTextController;
  TextEditingController _invoiceAmountTextController;
  TextEditingController _invoiceDateTextController;
  TextEditingController _nationalIDtextController;
  TextEditingController _mFathereNametextController;
  TextEditingController agreeValueTextController_;
  bool _flagVisibleNationalID;
  bool _flagVisibleFatherName;
  bool imeioption_ = true;
  bool flagVisibleInvoiceAmmount_ = true;
  bool flagVisibleAgreeValue_ = true;
  bool flagVisibleDate_ = false;
  var AndroidSdk;
  bool isLoadingProgress = false;
  bool mSponserText_ = false;

  @override
  void initState() {
    super.initState();
    PreferenceUtils.init();

    if (Platform.isAndroid) {
      if (PreferenceUtils.getInteger(Utils.AndroidSDK) >= 29) {
        if (deviceIemiNumber != null) {
          this.deviceIemiNumber = deviceIemiNumber;
        } else {
          deviceIemiNumber = "";
        }
      } else {
        initPlatformState();
      }
      imeiEditableFlag = false;
    } else {
      // iOS-specific code
      imeiEditableFlag = false;
      //   deviceIemiNumber = "";
    }
    //  print('deviceIemiNumber ===== $deviceIemiNumber');
    if (deviceIemiNumber != null) {
      this.deviceIemiNumber = deviceIemiNumber;
    } else {
      deviceIemiNumber = "";
    }

    _bloc = SaveUpdateUserDeviceInfoBloc(apisRepository: ApisRepository());
    deviceName = PreferenceUtils.getString(Utils.MobileBrand);
    deviceModel = PreferenceUtils.getString(Utils.MobileModel);
    // deviceIemiNumber = PreferenceUtils.getString(Utils.MobileID);
    deviceOS = PreferenceUtils.getString(Utils.MobileOS);
    deviceType = PreferenceUtils.getString(Utils.DeviceType);
    var nameUser = firstName + " " + lastName;
    print("userFirstName $firstName");
    print("lastName $lastName");
    print("UserName $nameUser");
    _nameTextController = TextEditingController(text: nameUser);
    _emailTextController = TextEditingController(text: userEmail);
    _mobileNumberTextController = TextEditingController(text: userPhoneNumber);
    _deviceNameTextController = TextEditingController(text: deviceName);
    _deviceModelTextController = TextEditingController(text: deviceModel);
    _deviceImeiTextController = TextEditingController(text: deviceIemiNumber);

    // _deviceImeiTextController = TextEditingController(text: "");
    _invoiceAmountTextController =
        TextEditingController(text: userInvoiceAmount);
    _invoiceDateTextController = TextEditingController(text: userInvoiceDate);
    _nationalIDtextController = TextEditingController(text: nationalID);
    _mFathereNametextController = TextEditingController(text: fatherName);

    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      flagVisibleInvoiceAmmount_ = false;
      flagVisibleDate_ = false;
    }
    if (PreferenceUtils.getString(Utils.OPERATORCODE) == "62001") {
      flagVisibleInvoiceAmmount_ = false;
      flagVisibleDate_ = false;
    }

    if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "254") {
      _flagVisibleNationalID = true;
      _flagVisibleFatherName = false;
    } else if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "88") {
      _flagVisibleNationalID = true;
      _flagVisibleFatherName = true;
      imeioption_ = false;
      flagVisibleInvoiceAmmount_ = false;
      flagVisibleAgreeValue_ = false;
    } else if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "233") {
      _flagVisibleNationalID = false;
      _flagVisibleFatherName = false;
      imeioption_ = true;
      flagVisibleInvoiceAmmount_ = true;
      flagVisibleAgreeValue_ = true;
    } else {
      imeioption_ = true;
      _flagVisibleNationalID = false;
      _flagVisibleFatherName = false;
    }

    if (PreferenceUtils.getString(Utils.appPackageName) ==
            "com.insurance.atpl.altruist_secure_flutter" ||
        PreferenceUtils.getString(Utils.appPackageName) ==
            "com.insurance.altruistSecureFlutter") {
      mSponserText_ = true;
    } else {
      mSponserText_ = false;
    }

    setState(() {
      if (Platform.isAndroid) {
        imeiEditableFlag = false;
        AndroidSdk = PreferenceUtils.getInteger(Utils.AndroidSDK);
        if (AndroidSdk >= 29) {
          setState(() {});
        } else {
          setState(() {});
        }
      } else {
        // iOS-specific code
        imeioption_ = true;
        imeiEditableFlag = false;
      }
    });

    ////Call Api For Agree Value////////

    AgreeRequest request;
    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      request = AgreeRequest(
          countryId: PreferenceUtils.getString(
            Utils.COUNTRY_ID,
          ),
          invoiceAmount: 20000,
          invoiceDate: "");
    } else {
      if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "233") {
        request = AgreeRequest(
            countryId: PreferenceUtils.getString(
              Utils.COUNTRY_ID,
            ),
            invoiceAmount: int.parse(userInvoiceAmount),
            invoiceDate: "");
      } else if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "88") {
        request = AgreeRequest(
            countryId: PreferenceUtils.getString(
              Utils.COUNTRY_ID,
            ),
            invoiceAmount: int.parse("20000"),
            invoiceDate: "04-2021");
      } else {
        request = AgreeRequest(
            countryId: PreferenceUtils.getString(
              Utils.COUNTRY_ID,
            ),
            invoiceAmount: int.parse(userInvoiceAmount),
            invoiceDate: userInvoiceDate);
      }
    }
    if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "88") {
      _bloc.add(AgreeValueEvent(agreeRequest: request));
    } else {
      _bloc.add(AgreeValueEvent(agreeRequest: request));
    }
  }

  Future<void> initPlatformState() async {
    String platformImei;
    String idunique;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      idunique = await ImeiPlugin.getImei();
      print('idunique ====  $idunique');
      deviceIemiNumber = idunique;
      setState(() {});
    } on PlatformException {
      platformImei = 'Failed to get platform version.';
    }
    if (!mounted) return;
    _platformImei = platformImei;
    uniqueId = idunique;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: BlocListener(
          bloc: _bloc,
          listener:
              (BuildContext context, SaveUpdateUserDeviceInfoState state) {
            if (state is InitialSaveUpdateUserDeviceInfoState) {
              if (state.isLoading == false && !state.isSuccess) {
                AppUtils.showSnackBar(context, state.message);
                mToast(state.message);
              } else if (state.isLoading == false && state.isSuccess) {
                mToast(state.message);
//              _ackAlert(context);
                EventTracker.logEvent("USER_REGISTRATION_DONE");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      // builder: (context) => ProfileMain(),
                      builder: (context) => ListTest(),
                      settings: RouteSettings(name: 'ListTest')),
                );
              }
            }
            if (state is AgreeValueInfoState) {
              if (state.isLoading == false && !state.isSuccess) {
                AppUtils.showSnackBar(context, state.message);
                mToast(state.message);
              } else if (state.isLoading == false && state.isSuccess) {
                if (state.agreeValueResponse != null &&
                    state.agreeValueResponse.statusDescription.errorCode ==
                        "200") {}

                //   flagVisibleAgreeValue_ = true;
//              agreeValueTextController_ = TextEditingController(
//                  text: state.agreeValueResponse.agreeValue);

                if (PreferenceUtils.getString(Utils.appPackageName) ==
                    "com.app.mansardecure_secure") {
                  agreeValueTextController_ = TextEditingController(
                      text: state.agreeValueResponse.agreeValue + " (Naira) ");
                } else {
                  agreeValueTextController_ = TextEditingController(
                      text: state.agreeValueResponse.agreeValue);
                }
                setState(() {});
              }
            }
          },
          child: BlocBuilder(
            bloc: _bloc,
            builder: (context, SaveUpdateUserDeviceInfoState state) {
              if (state is InitialSaveUpdateUserDeviceInfoState) {
                if (state.isLoading) {
                  isLoadingProgress = state.isLoading;
                } else {
                  isLoadingProgress = false;
                }
              } else if (state is AgreeValueInfoState) {
                if (state.isLoading) {
                  isLoadingProgress = state.isLoading;
                } else {
                  isLoadingProgress = false;
                }
              }
              return ModalProgressHUD(
                color: Colors.black,
                inAsyncCall: isLoadingProgress,
                child: RegistrationConfirmationForm(
                  nameTextController: _nameTextController,
                  mobileNumberTextController: _mobileNumberTextController,
                  emailTextController: _emailTextController,
                  deviceNameTextController: _deviceNameTextController,
                  deviceModelTextController: _deviceModelTextController,
                  deviceImeiTextController: _deviceImeiTextController,
                  invoiceAmountTextController: _invoiceAmountTextController,
                  invoiceDateTextController: _invoiceDateTextController,
                  nationalIDtextController: _nationalIDtextController,
                  mFathereNametextController: _mFathereNametextController,
                  currency: currencyInfo,
                  imeiEditableFlag: imeiEditableFlag,
                  firstName: firstName,
                  lastName: lastName,
                  flagVisibleNationalID: _flagVisibleNationalID,
                  flagVisibleFatherName: _flagVisibleFatherName,
                  imeioption: imeioption_,
                  flagVisibleInvoiceAmmount: flagVisibleInvoiceAmmount_,
                  flagVisibleDate: flagVisibleDate_,
                  agreeValueTextController: agreeValueTextController_,
                  flagVisibleAgreeValue: flagVisibleAgreeValue_,
                  onSubmitClick: () {
                    var imeiValue = _deviceImeiTextController.text;
                    //  print("Iemi text value $imeiValue");
                    if (Platform.isAndroid) {
                      if (AndroidSdk >= 29) {
                        EventTracker.logEvent(
                            "REGISTRATION_CONFIRM_CLICK_EVENT");
                        var saveUserDeviceInfoRequestModel =
                            SaveUserDeviceInfoRequestModel(
                                userId:
                                    PreferenceUtils.getString(Utils.USER_ID),
                                source: StringConstants.SOURCE,
                                deviceDetails: DeviceDetails(
                                  currency: currencyInfo,
                                  customerFirstName: firstName,
                                  customerMiddleName: "",
                                  customerLastName: lastName,
                                  mobileNumber:
                                      _mobileNumberTextController.text,
                                  email: _emailTextController.text,
                                  deviceName: _deviceNameTextController.text,
                                  deviceModel: _deviceModelTextController.text,
                                  imieNumber: _deviceImeiTextController.text,
                                  deviceOs: deviceType,
                                  deviceOsVersion: deviceOS,
                                  invoiceAmount:
                                      _invoiceAmountTextController.text,
                                  invoiceDate: _invoiceDateTextController.text,
                                  fatherName: _mFathereNametextController.text,
                                  nationalId: _nationalIDtextController.text,
                                  marketValue:
                                      _invoiceAmountTextController.text,
                                  sumAssuredValue:
                                      agreeValueTextController_.text,
                                ));

                        _bloc.add(SaveUpdateUserDeviceInfoClickEvent(
                            saveUserDeviceInfoRequestModel:
                                saveUserDeviceInfoRequestModel));
                      } else {
//                        if (imeiValue.isEmpty) {
//                          mToast("Please enter IMEI number");
//                        } else {
                        EventTracker.logEvent(
                            "REGISTRATION_CONFIRM_CLICK_EVENT");
                        var saveUserDeviceInfoRequestModel =
                            SaveUserDeviceInfoRequestModel(
                                userId:
                                    PreferenceUtils.getString(Utils.USER_ID),
                                source: StringConstants.SOURCE,
                                deviceDetails: DeviceDetails(
                                  currency: currencyInfo,
                                  customerFirstName: firstName,
                                  customerMiddleName: "",
                                  customerLastName: lastName,
                                  mobileNumber:
                                      _mobileNumberTextController.text,
                                  email: _emailTextController.text,
                                  deviceName: _deviceNameTextController.text,
                                  deviceModel: _deviceModelTextController.text,
                                  imieNumber: _deviceImeiTextController.text,
                                  deviceOs: deviceType,
                                  deviceOsVersion: deviceOS,
                                  invoiceAmount:
                                      _invoiceAmountTextController.text,
                                  invoiceDate: _invoiceDateTextController.text,
                                  fatherName: _mFathereNametextController.text,
                                  nationalId: _nationalIDtextController.text,
                                  marketValue:
                                      _invoiceAmountTextController.text,
                                  sumAssuredValue:
                                      agreeValueTextController_.text,
                                ));

                        _bloc.add(SaveUpdateUserDeviceInfoClickEvent(
                            saveUserDeviceInfoRequestModel:
                                saveUserDeviceInfoRequestModel));
                        //   }
                      }
                    } else {
//                      // iOS-specific code
//                      if (imeiValue.isEmpty) {
//                        mToast("Please enter IMEI number");
//                      } else {
                        EventTracker.logEvent(
                            "REGISTRATION_CONFIRM_CLICK_EVENT");
                        var saveUserDeviceInfoRequestModel =
                            SaveUserDeviceInfoRequestModel(
                                userId:
                                    PreferenceUtils.getString(Utils.USER_ID),
                                source: StringConstants.SOURCE,
                                deviceDetails: DeviceDetails(
                                  currency: currencyInfo,
                                  customerFirstName: firstName,
                                  customerMiddleName: "",
                                  customerLastName: lastName,
                                  mobileNumber:
                                      _mobileNumberTextController.text,
                                  email: _emailTextController.text,
                                  deviceName: _deviceNameTextController.text,
                                  deviceModel: _deviceModelTextController.text,
                                  imieNumber: _deviceImeiTextController.text,
                                  deviceOs: deviceType,
                                  deviceOsVersion: deviceOS,
                                  invoiceAmount:
                                      _invoiceAmountTextController.text,
                                  invoiceDate: _invoiceDateTextController.text,
                                  fatherName: _mFathereNametextController.text,
                                  nationalId: _nationalIDtextController.text,
                                  marketValue:
                                      _invoiceAmountTextController.text,
                                  sumAssuredValue:
                                      agreeValueTextController_.text,
                                ));

                        _bloc.add(SaveUpdateUserDeviceInfoClickEvent(
                            saveUserDeviceInfoRequestModel:
                                saveUserDeviceInfoRequestModel));
                      }
                 //   }
                  },
                ),
              );
            },
          ),
        ));
  }

  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }
}
