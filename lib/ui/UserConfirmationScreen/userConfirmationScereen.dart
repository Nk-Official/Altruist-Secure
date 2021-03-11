import 'dart:math';
import 'package:altruist_secure_flutter/SubScriptionWebPage/UI/subscriptionWePage.dart';
import 'package:altruist_secure_flutter/TestList/UI/TaskList.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/apis/apis.dart';
import 'package:altruist_secure_flutter/blocs/saveUpdateUserDeviceInfo/bloc.dart';
import 'package:altruist_secure_flutter/models/requests/AgreeValueRequest/AgreeValueRequest.dart';
import 'package:altruist_secure_flutter/models/requests/saveUpdateUserDeviceInfo/SaveUserDeviceInfoRequestModel.dart';
import 'package:altruist_secure_flutter/ui/UserConfirmationScreen/userConfirmationScreenXml.dart';
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

class UserConfirmationScereen extends StatefulWidget {
  @override
  UserConfirmationScereenState createState() => UserConfirmationScereenState();
}

class UserConfirmationScereenState extends State<UserConfirmationScereen> {
  String userEmail,
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
  bool mSponserText_;
  AgreeRequest request;

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

    _bloc.add(FetchCustomerInfoEvent());
    deviceName = PreferenceUtils.getString(Utils.MobileBrand);
    deviceModel = PreferenceUtils.getString(Utils.MobileModel);
    // deviceIemiNumber = PreferenceUtils.getString(Utils.MobileID);
    deviceOS = PreferenceUtils.getString(Utils.MobileOS);
    deviceType = PreferenceUtils.getString(Utils.DeviceType);

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
            if (state is InitialSplashBlocState) {
              if (state.isLoading == false && !state.isSuccess) {
                //  mToast("Api Fail");
              } else if (state.isLoading == false && state.isSuccess) {
                firstName = state
                    .customerInfoResponseModel.deviceDetails.customerFirstName;
                lastName = state
                    .customerInfoResponseModel.deviceDetails.customerLastName;
                userEmail = state.customerInfoResponseModel.deviceDetails.email;
                deviceIemiNumber =
                    state.customerInfoResponseModel.deviceDetails.imieNumber;
                userInvoiceAmount =
                    state.customerInfoResponseModel.deviceDetails.invoiceAmount;
                userInvoiceDate =
                    state.customerInfoResponseModel.deviceDetails.invoiceDate;
                nationalID =
                    state.customerInfoResponseModel.deviceDetails.nationalId;
                fatherName =
                    state.customerInfoResponseModel.deviceDetails.fatherName;
                userPhoneNumber =
                    state.customerInfoResponseModel.deviceDetails.mobileNumber;

                var nameUser = firstName + " " + lastName;
                _nameTextController = TextEditingController(text: nameUser);
                _emailTextController = TextEditingController(text: userEmail);
                _mobileNumberTextController =
                    TextEditingController(text: userPhoneNumber);
                _deviceNameTextController =
                    TextEditingController(text: deviceName);
                _deviceModelTextController =
                    TextEditingController(text: deviceModel);
                _deviceImeiTextController =
                    TextEditingController(text: deviceIemiNumber);

                // _deviceImeiTextController = TextEditingController(text: "");
                _invoiceAmountTextController =
                    TextEditingController(text: userInvoiceAmount);
                _invoiceDateTextController =
                    TextEditingController(text: userInvoiceDate);
                _nationalIDtextController =
                    TextEditingController(text: nationalID);
                _mFathereNametextController =
                    TextEditingController(text: fatherName);

                request = AgreeRequest(
                    countryId: PreferenceUtils.getString(
                      Utils.COUNTRY_ID,
                    ),
                    invoiceAmount: int.parse(userInvoiceAmount),
                    invoiceDate: userInvoiceDate);
                _bloc.add(AgreeValueEvent(agreeRequest: request));
              }
            }
            else if (state is InitialSaveUpdateUserDeviceInfoState) {
              if (state.isLoading == false && !state.isSuccess) {
                AppUtils.showSnackBar(context, state.message);
                mToast(state.message);
              } else if (state.isLoading == false && state.isSuccess) {
                mToast(state.message);
                EventTracker.logEvent("USER_REGISTRATION_DONE");
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        // builder: (context) => NewHomeDashBoard(""),
                        builder: (context) => Subscription(),
                        settings: RouteSettings(name: 'Subscription')));
              }
            }
            else if (state is AgreeValueInfoState) {
              if (state.isLoading == false && !state.isSuccess) {
                AppUtils.showSnackBar(context, state.message);
                mToast(state.message);
              } else if (state.isLoading == false && state.isSuccess) {
                if (state.agreeValueResponse != null &&
                    state.agreeValueResponse.statusDescription.errorCode ==
                        "200") {


                }

                setState(() {
                  agreeValueTextController_ = TextEditingController(
                      text: state.agreeValueResponse.agreeValue);
                });
              }
            }
          },
          child: BlocBuilder(
            bloc: _bloc,
            builder: (context, SaveUpdateUserDeviceInfoState state) {
              if (state is InitialSplashBlocState) {
                if (state.isLoading) {
                  isLoadingProgress = state.isLoading;
                } else {
                  isLoadingProgress = false;
                }
              }
              else if (state is InitialSaveUpdateUserDeviceInfoState) {
                if (state.isLoading) {
                  isLoadingProgress = state.isLoading;
                } else {
                  isLoadingProgress = false;
                }
              }
              else if (state is AgreeValueInfoState) {
                if (state.isLoading) {
                  isLoadingProgress = state.isLoading;
                } else {
                  isLoadingProgress = false;
                }
              }
              return ModalProgressHUD(
                color: Colors.black,
                inAsyncCall: isLoadingProgress,
                child: userConfirmationScreenXml(
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
                        if (imeiValue.isEmpty) {
                          mToast("Please enter IMEI number");
                        } else {
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
                                    deviceModel:
                                        _deviceModelTextController.text,
                                    imieNumber: _deviceImeiTextController.text,
                                    deviceOs: deviceType,
                                    deviceOsVersion: deviceOS,
                                    invoiceAmount:
                                        _invoiceAmountTextController.text,
                                    invoiceDate:
                                        _invoiceDateTextController.text,
                                    fatherName:
                                        _mFathereNametextController.text,
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
                      }
                    }
                    else {
                      // iOS-specific code
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
              //      }
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
