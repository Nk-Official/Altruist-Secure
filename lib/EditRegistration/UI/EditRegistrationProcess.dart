import 'dart:developer';
import 'dart:io';
import 'package:altruist_secure_flutter/EditRegistration/UI/EditRegistrationForm.dart';
import 'package:altruist_secure_flutter/RegistrationForm/UI/Registration.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/apis/apis.dart';
import 'package:altruist_secure_flutter/blocs/login_process/bloc.dart';
import 'package:altruist_secure_flutter/blocs/login_process/otp_login_process_bloc.dart';
import 'package:altruist_secure_flutter/models/responses/currencyInfo/CurrencyInfoResponseModel.dart';
import 'package:altruist_secure_flutter/ui/registrationCofirm/RegistrationConfirm.dart';
import 'package:altruist_secure_flutter/utils/app_utils.dart';
import 'package:altruist_secure_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import 'package:date_format/date_format.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class EditRegistrationProcess extends StatefulWidget {
  String userFirstName,
      userEmail,
      userPhoneNumber,
      userInvoiceAmount,
      userInvoiceDate,
      firstName,
      lastName,
      IemiNumber,
      nationalIDtextController,
      mFathereNametextController;

  EditRegistrationProcess(
    this.firstName,
    this.lastName,
    this.userEmail,
    this.userPhoneNumber,
    this.IemiNumber,
    this.userInvoiceAmount,
    this.userInvoiceDate,
    this.nationalIDtextController,
    this.mFathereNametextController,
  );

  @override
  _RegistrationProcessState createState() => _RegistrationProcessState(
      firstName,
      lastName,
      userEmail,
      userPhoneNumber,
      IemiNumber,
      userInvoiceAmount,
      userInvoiceDate,
      nationalIDtextController,
      mFathereNametextController);
}

class _RegistrationProcessState extends State<EditRegistrationProcess> {
  OtpLoginProcessBloc _bloc;
  TextEditingController _userFirstNameController;
  TextEditingController _userLastNameController;
  TextEditingController _userEmailController;
  TextEditingController _phoneNumberController;
  TextEditingController _inVoiceAmmountController;
  TextEditingController _inVoiceDateController;
  TextEditingController _lastNameController;
  TextEditingController _deviceImeiTextController;
  TextEditingController _nationalIDtextController;
  TextEditingController _mFathereNametextController;
  GlobalKey<FormState> _formKey;
  DateTime selectedDate;
  String verificationId;
  var mCountryCode;
  var registerDate;
  var UserNumber;
  var IemiNumber;
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
      sdkInt,
      userFirstName,
      userEmail,
      userPhoneNumber,
      userInvoiceAmount,
      userInvoiceDate,
      deviceIemiNumber = "";

  int AndroidSdk;
  bool isphysicaldevice;
  AndroidDeviceInfo androidDeviceInfo;
  IosDeviceInfo iosDeviceInfo;
  String appBarName = "User Registration Form";
  OperatorConfig operatorConfig;
  String firstName,
      lastName,
      nationalIDtextController,
      mFathereNametextController;
  bool _imeiEditableFlag;
  bool _flagVisibleImei;
  bool _flagVisibleNationalID;
  bool _flagVisibleFatherName;
  bool flagVisibleInvoiceAmmount_ = true;
  bool flagVisibleInvoiceDate_ = true;
  bool spinnerVisibilty_ = true;

  List<String> spinnerItems = [
    'Select Store',
    'Store 1',
    'Store 2',
    'Store 3',
    'Store 4',
    'Store 5'
  ];

  _RegistrationProcessState(
    this.firstName,
    this.lastName,
    this.userEmail,
    this.userPhoneNumber,
    this.IemiNumber,
    this.userInvoiceAmount,
    this.userInvoiceDate,
    this.nationalIDtextController,
    this.mFathereNametextController,
  );

  @override
  void initState() {
    super.initState();
    //getDeviceinfo();
    if (Platform.isAndroid) {
      initPlatformState();
    } else {
      // iOS-specific code
    }

    if (PreferenceUtils.getString(Utils.OPERATORCODE) == "62001") {
      flagVisibleInvoiceAmmount_ = false;
      flagVisibleInvoiceDate_ = false;
    }
    if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "254") {
      _flagVisibleNationalID = true;
      _flagVisibleFatherName = false;
    } else if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "88") {
      _flagVisibleNationalID = true;
      _flagVisibleFatherName = true;
      _flagVisibleImei = false;
      _imeiEditableFlag = false;
      flagVisibleInvoiceAmmount_ = false;
      flagVisibleInvoiceDate_ = false;
    } if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "233") {
      _flagVisibleNationalID = false;
      _flagVisibleFatherName = false;
      _flagVisibleImei = false;
      _imeiEditableFlag = false;
      flagVisibleInvoiceAmmount_ = false;
      flagVisibleInvoiceDate_ = false;
      spinnerVisibilty_ = false;
//      spinnerVisibilty_ = false;
//      clickButtonVisibility_ = true;
//      buttonInvoiceUploadVisibility_ = false;
    }else {
      _flagVisibleNationalID = false;
      _flagVisibleFatherName = false;
      _imeiEditableFlag = true;
      _flagVisibleImei = true;
    }

    if (Platform.isAndroid) {

      AndroidSdk = PreferenceUtils.getInteger(Utils.AndroidSDK);
      if (AndroidSdk >= 29) {
        setState(() {
          _imeiEditableFlag = false;
        });
      }

      Future.delayed(Duration(seconds: 5), () async {
        initPlatformState();
      });
    } else {
      // iOS-specific code
      _flagVisibleImei = true;
      _imeiEditableFlag = false;
    }
//    setState(() {
//      if (Platform.isAndroid) {
//        _imeiEditableFlag = false;
//        _flagVisibleImei = false;
//        //  imeiEditableFlag = true;
//      } else {
//        _imeiEditableFlag = false;
//        _flagVisibleImei = true;
//        // iOS-specific code
//      }
//    });

    _bloc = OtpLoginProcessBloc(apisRepository: ApisRepository());

    if(PreferenceUtils.getString(Utils.appPackageName) == "com.app.mansardecure_secure"){
      flagVisibleInvoiceAmmount_ = false;
      flagVisibleInvoiceDate_ = false;
    }
    _formKey = GlobalKey<FormState>();
    UserNumber = PreferenceUtils.getString(Utils.UserNumber);
    _userFirstNameController = TextEditingController(text: firstName);
    _userLastNameController = TextEditingController(text: lastName);
    _userEmailController = TextEditingController(text: userEmail);
    _phoneNumberController = TextEditingController(text: userPhoneNumber);
    _phoneNumberController.text = userPhoneNumber;
    _deviceImeiTextController = TextEditingController(text: IemiNumber);
    _inVoiceAmmountController = TextEditingController(text: userInvoiceAmount);
    _inVoiceDateController = TextEditingController(text: userInvoiceDate);
    _nationalIDtextController =
        TextEditingController(text: nationalIDtextController);
    _mFathereNametextController =
        TextEditingController(text: mFathereNametextController);
    registerDate = _inVoiceDateController.text.toString();

    if(PreferenceUtils.getString(Utils.appPackageName) == "com.insurance.atpl.altruist_secure_flutter" ||
        PreferenceUtils.getString(Utils.appPackageName) == "com.insurance.altruistSecureFlutter"){
      if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "233") {
//        if(PreferenceUtils.getString(Utils.OPERATORCODE) == "62001") {
//
//        }
        _bloc.add(FetchCurrencyInfoEvent());
      }
    }else{

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
      deviceIemiNumber = idunique;
      print('deviceIemiNumber ====  $deviceIemiNumber');
    } on Exception {
      platformImei = 'Failed to get platform version.';
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    var title = appBarName;
    return  Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: ColorConstant.AppBarColor,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: new TextStyle(
              fontSize: 17,
              color: ColorConstant.TextColor,
              fontFamily: 'OpenSans'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener(
        bloc: _bloc,
        listener: (BuildContext context, OtpLoginProcessState state) {
          if (state is IntialCurrencyInfoState) {
            if (state.isLoading == false && !state.isSuccess) {
              AppUtils.showSnackBar(context, state.message);
            } else if (state.isLoading == false && state.isSuccess) {
//              AppUtils.showSnackBar(context, state.message);
              if (state.operatorConfig != null) {
                operatorConfig = state.operatorConfig;
                PreferenceUtils.setString(
                    Utils.CURRENCYFORPREFRENCE, operatorConfig.currency);
              }
            }
          }
        },
        child: BlocBuilder(
          bloc: _bloc,
          builder: (context, OtpLoginProcessState state) {
            return ModalProgressHUD(
              color: Colors.black,
              inAsyncCall:
                  state is IntialCurrencyInfoState && state.isLoading != null
                      ? state.isLoading
                      : false,
              child: EditRegistrationProcessForm(
                formKey: _formKey,
                imeiEditableFlag: _imeiEditableFlag,
                flagVisibleImei: _flagVisibleImei,
                userFirstNameController: _userFirstNameController,
                userLastNameController: _userLastNameController,
                userEmailController: _userEmailController,
                phoneNumberController: _phoneNumberController,
                deviceImeiTextController: _deviceImeiTextController,
                inVoiceAmmountController: _inVoiceAmmountController,
                inVoiceDateController: _inVoiceDateController,
                flagVisibleNationalID: _flagVisibleNationalID,
                flagVisibleFatherName: _flagVisibleFatherName,
                nationalIDtextController: _nationalIDtextController,
                mFathereNametextController: _mFathereNametextController,
                flagVisibleInvoiceAmmount: flagVisibleInvoiceAmmount_,
                flagVisibleInvoiceDate: flagVisibleInvoiceDate_,
                spinnerItems: spinnerItems,
                  spinnerVisibilty:spinnerVisibilty_,
                onDatePickerClick: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  //  handleReadOnlyInputClick(context);

                  showMonthPicker(
                    context: context,
                    firstDate: DateTime(DateTime.now().year,
                        DateTime.now().month - 12, DateTime.now().day),
                    lastDate: DateTime(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day),
                    initialDate: DateTime.now(),
                  ).then((date) {
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                        log("Seleted Date $selectedDate  ");
                        convertDateFromString(selectedDate.toString());
                      });
                    }
                  });
                },
                onNextClick: () {
                  EventTracker.logEvent("ON_REGISTRATION_NEXT_CLICK");
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    if (registerDate == null) {
                      mToast(Utils.InvoiceDate);
                    } else {
                      var userFirstName =
                          _userFirstNameController.text.toString();
                      var userLastName =
                          _userLastNameController.text.toString();
                      var userEmail = _userEmailController.text.toString();
                      var userPhoneNumber =
                          _phoneNumberController.text.toString();

                      var userInvoiceAmount =
                          _inVoiceAmmountController.text.toString();
                      var userInvoiceDate =
                          _inVoiceDateController.text.toString();
                      if (Platform.isAndroid) {
                        deviceIemiNumber =
                            _deviceImeiTextController.text.toString();
                      } else {
                        deviceIemiNumber =
                            _deviceImeiTextController.text.toString();
                      }

                      PreferenceUtils.setString(Utils.IMEI,deviceIemiNumber);

                      var nationalID;
                      var fatherName;

                      if (_nationalIDtextController.text.toString() != null) {
                        nationalID = _nationalIDtextController.text.toString();
                      } else {
                        nationalID = "";
                      }

                      if (_mFathereNametextController.text.toString() != null) {
                        fatherName =
                            _mFathereNametextController.text.toString();
                      } else {
                        fatherName = "";
                      }

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationConfirm(
                                userFirstName,
                                userEmail,
                                userPhoneNumber,
                                userInvoiceAmount,
                                userInvoiceDate,
                                deviceIemiNumber,
                                operatorConfig == null
                                    ? ""
                                    : operatorConfig.currency,
                                userFirstName,
                                userLastName,
                                nationalID,
                                fatherName),
                            settings:
                                RouteSettings(name: 'RegistrationConfirm')),
                      );
                    }
                  }
                },
                operatorConfig: operatorConfig == null ? null : operatorConfig,
              ),
            );
          },
        ),
    ));
  }

  void handleReadOnlyInputClick(mContext) {
    log('Callender Method Called');
    showBottomSheet(
        context: mContext,
        builder: (BuildContext context) => Container(
              width: MediaQuery.of(context).size.width,
              child: MonthPicker(
                selectedDate: DateTime.now(),
                firstDate: DateTime(DateTime.now().year,
                    DateTime.now().month - 12, DateTime.now().day),
                lastDate: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day),
                onChanged: (val) {
                  convertDateFromString(val.toString());
                  Navigator.pop(context);
                },
              ),
            ));
  }

//  void convertDateFromString(String strDate) {
//    DateTime todayDate = DateTime.parse(strDate);
//    print(todayDate);
//    setState(() {
//      registerDate = (formatDate(todayDate, [yyyy, '-', mm, '-', dd]));
//      log('register Date $registerDate');
//      _inVoiceDateController.text = registerDate;
//    });
//  }

  void convertDateFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);
    print(todayDate);
    setState(() {
      //  registerDate = (formatDate(todayDate, [yyyy, '-', mm, '-', dd]));
      registerDate = (formatDate(todayDate, [mm, '-', yyyy]));
      log('register Date $registerDate');
      _inVoiceDateController.text = registerDate;
    });
  }

  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }
}
