import 'dart:developer';
import 'dart:io';
import 'package:altruist_secure_flutter/RegistrationForm/UI/Registration.dart';
import 'package:altruist_secure_flutter/TestList/UI/TaskList.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/analytics/EventTracker.dart';
import 'package:altruist_secure_flutter/apis/apis.dart';
import 'package:altruist_secure_flutter/blocs/login_process/bloc.dart';
import 'package:altruist_secure_flutter/blocs/login_process/otp_login_process_bloc.dart';
import 'package:altruist_secure_flutter/models/requests/saveUpdateUserDeviceInfo/SaveUserDeviceInfoRequestModel.dart';
import 'package:altruist_secure_flutter/models/responses/currencyInfo/CurrencyInfoResponseModel.dart';
import 'package:altruist_secure_flutter/ui/registrationCofirm/RegistrationConfirm.dart';
import 'package:altruist_secure_flutter/ui/registrationProcess/RegistrationProcessForm.dart';
import 'package:altruist_secure_flutter/ui/registrationProcess/StoreModel.dart';
import 'package:altruist_secure_flutter/utils/StringConstants.dart';
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
import 'package:flutter/services.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweetalert/sweetalert.dart';

class RegistrationProcess extends StatefulWidget {
  String firstName, lastName, mobileNumber, email;

  RegistrationProcess(
      String firstName, String lastName, String mobileNumber, String email) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.mobileNumber = mobileNumber;
    this.email = email;

    print("First Name  ===  $firstName");
    print("mobileNumber  ===  $mobileNumber");
  }

  @override
  _RegistrationProcessState createState() => _RegistrationProcessState(
      this.firstName, this.lastName, this.mobileNumber, this.email);
}

class _RegistrationProcessState extends State<RegistrationProcess> {
  OtpLoginProcessBloc _bloc;
  TextEditingController _userFirstNameController;
  TextEditingController _userLastNameController;
  TextEditingController _userEmailController;
  TextEditingController _phoneNumberController;
  TextEditingController _inVoiceAmmountController;
  TextEditingController _deviceImeiTextController;
  TextEditingController _inVoiceDateController;
  TextEditingController _nationalIDtextController;
  TextEditingController _mFathereNametextController;
  GlobalKey<FormState> _formKey;
  DateTime selectedDate;
  String verificationId;
  var mCountryCode;
  var registerDate;
  var UserNumber;
  String brand,
      id,
      manufacture,
      model,
      type,
      androidid,
      release,
      deviceIemiNumber = "";
  File imageFile_;
  int AndroidSdk;
  bool isphysicaldevice;
  AndroidDeviceInfo androidDeviceInfo;
  IosDeviceInfo iosDeviceInfo;
  String appBarName = "User Registration Form";
  OperatorConfig operatorConfig;
  bool _imeiEditableFlag;
  bool _flagVisibleImei;
  bool _flagVisibleNationalID;
  bool _flagVisibleFatherName;
  int lenghtCurrecy;
  String firstName, lastName, mobileNumber, email;
  bool flagEditableFirstName_ = true;
  bool flagEditableLasttName_ = true;
  bool flagEditableMobilenumber_ = true;
  bool flagEditableEmail_ = true;
  bool flagVisibleInvoiceAmmount_ = true;
  bool flagVisibleInvoiceDate_ = true;
  bool buttonInvoiceUploadVisibility_ = false;
  bool clickButtonVisibility_ = true;
  bool spinnerVisibilty_ = false;
  String dropdownValue = 'Select Store';
  String uploadImageText = Utils.Upload;

  var _pickedImage;
  String userFirstName,
      userEmail,
      userPhoneNumber,
      userInvoiceAmount,
      userInvoiceDate,
      deviceModel,
      deviceName,
      deviceOS,
      deviceType,
      currencyInfo;

  bool isLoadingProgress = false;
  var InvoiceImageUrl;
  TextEditingController _storeController;
  var storeName;
  var selectedStore;
  List<StoreModel> spinnerItems = new List();

  _RegistrationProcessState(
      String firstName, String lastName, String mobileNumber, String email) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.mobileNumber = mobileNumber;
    this.email = email;
    print("lastName Name  ===  $lastName");
  }

  @override
  void initState() {
    super.initState();
    //getDeviceinfo();
    PreferenceUtils.init();
    _bloc = OtpLoginProcessBloc(apisRepository: ApisRepository());
    _formKey = GlobalKey<FormState>();
    UserNumber = PreferenceUtils.getString(Utils.UserNumber);
    _userFirstNameController = TextEditingController();
    _userLastNameController = TextEditingController();
    _userEmailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _phoneNumberController.text = "+" + UserNumber;
    _inVoiceAmmountController = TextEditingController();
    _deviceImeiTextController = TextEditingController();
    _inVoiceDateController = TextEditingController();
    _nationalIDtextController = TextEditingController();
    _mFathereNametextController = TextEditingController();
    _storeController = TextEditingController();

    deviceName = PreferenceUtils.getString(Utils.MobileBrand);
    deviceModel = PreferenceUtils.getString(Utils.MobileModel);
    // deviceIemiNumber = PreferenceUtils.getString(Utils.MobileID);
    deviceOS = PreferenceUtils.getString(Utils.MobileOS);
    deviceType = PreferenceUtils.getString(Utils.DeviceType);
    imageFile_ = File("");
    var countryCode = PreferenceUtils.getString(Utils.COUNTRY_ID);
    print("Country Code ======= $countryCode");
    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      flagVisibleInvoiceAmmount_ = false;
      flagVisibleInvoiceDate_ = false;
    }

    if (Platform.isAndroid) {
      initPlatformState();
      _imeiEditableFlag = true;
      _flagVisibleImei = true;
      _deviceImeiTextController.text = deviceIemiNumber;
      AndroidSdk = PreferenceUtils.getInteger(Utils.AndroidSDK);
      if (AndroidSdk >= 29) {
        setState(() {
          _flagVisibleImei = true;
          _imeiEditableFlag = false;
        });
      }
    } else {
      _flagVisibleImei = true;
      _imeiEditableFlag = false;
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
      spinnerVisibilty_ = true;
      clickButtonVisibility_ = false;
      buttonInvoiceUploadVisibility_ = true;
      uploadImageText = Utils.Upload;
      setState(() {});
    } else if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "233") {
      _flagVisibleNationalID = false;
      _flagVisibleFatherName = false;
      _flagVisibleImei = false;
      _imeiEditableFlag = false;
      flagVisibleInvoiceAmmount_ = false;
      flagVisibleInvoiceDate_ = false;
      spinnerVisibilty_ = false;
      clickButtonVisibility_ = true;
      buttonInvoiceUploadVisibility_ = false;
    } else if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "234") {
      _flagVisibleNationalID = false;
      _flagVisibleFatherName = false;
      _flagVisibleImei = false;
      _imeiEditableFlag = false;
      flagVisibleInvoiceAmmount_ = false;
      flagVisibleInvoiceDate_ = false;
      spinnerVisibilty_ = false;
      clickButtonVisibility_ = true;
      buttonInvoiceUploadVisibility_ = false;
    } else {
      spinnerVisibilty_ = false;
      _flagVisibleNationalID = false;
      _flagVisibleFatherName = false;
      buttonInvoiceUploadVisibility_ = false;
    }

    if (firstName != null) {
      flagEditableFirstName_ = false;
      _userFirstNameController.text = firstName;
    }
    if (lastName != null) {
      flagEditableLasttName_ = false;
      _userLastNameController.text = lastName;
    }
    _phoneNumberController.text = "+" + PreferenceUtils.getString(Utils.MSISDN);
    if (email != null) {
      flagEditableEmail_ = false;
      _userEmailController.text = email;
    }

    if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "233" ||
        PreferenceUtils.getString(Utils.COUNTRY_ID) == "234") {
      _bloc.add(FetchCurrencyInfoEvent());
    }

    if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "233" || PreferenceUtils.getString(Utils.COUNTRY_ID) == "88") {
      _bloc.add(FetchStoreEvent());
    }
//    else {
//
//      if (PreferenceUtils.getString(Utils.appPackageName) == "com.insurance.atpl.altruist_secure_flutter" || PreferenceUtils.getString(Utils.appPackageName) == "com.insurance.altruistSecureFlutter") {
//      if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "233") {
//        _bloc.add(FetchCurrencyInfoEvent());
//      }
//    } else {
//
//    }
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
      print('DeviceImeiNumber ====  $deviceIemiNumber');

      if (AndroidSdk >= 29) {
//       if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "88") {
//        _flagVisibleImei = false;
//        _imeiEditableFlag = false;
//      } else {
//        _flagVisibleNationalID = false;
//        _flagVisibleFatherName = false;
//      }
        setState(() {});
      } else {
        _deviceImeiTextController.text = deviceIemiNumber;
      }
    } on Exception {
      platformImei = 'Failed to get platform version.';
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    var title = appBarName;
    return Scaffold(
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
              }
              else if (state.isLoading == false && state.isSuccess) {
//              AppUtils.showSnackBar(context, state.message);

                //////////////////TecCode Working According to below Conditions//////////////
                print("Operator hashCode  === ${state.errorCode} ");
                if (state.errorCode != 200 ||
                    state.message == "No data found") {
                  _unSuccessPop(state.message);
                  return;
                }
                if (state.operatorConfig != null) {
                  operatorConfig = state.operatorConfig;
                  PreferenceUtils.setString(
                      Utils.CURRENCYFORPREFRENCE, operatorConfig.currency);
                  lenghtCurrecy =
                      int.parse(state.operatorConfig.maxLengthForAmount);
                  _inVoiceAmmountController.text =
                      state.operatorConfig.maxInvoiceAmount;
                  flagVisibleInvoiceAmmount_ = false;
                  flagVisibleInvoiceDate_ = false;
                  _flagVisibleImei = false;
                  _imeiEditableFlag = false;
                  _deviceImeiTextController.text =
                      PreferenceUtils.getString(Utils.IMEI);

//                  if (PreferenceUtils.getString(Utils.OPERATORCODE) == "62001") {
//                    _inVoiceAmmountController.text = state.operatorConfig.maxInvoiceAmount;
//                    flagVisibleInvoiceAmmount_ = false;
//                    flagVisibleInvoiceDate_ = false;
//                    _flagVisibleImei = true;
//                    _imeiEditableFlag = true;
//                    _deviceImeiTextController.text = PreferenceUtils.getString(Utils.IMEI);
//                  }

                  setState(() {});
                }
              }
            } else if (state is InitialSaveUpdateUserDeviceInfoState) {
              if (state.isLoading == false && !state.isSuccess) {
                AppUtils.showSnackBar(context, state.message);
                mToast(state.message);
              } else if (state.isLoading == false && state.isSuccess) {
                mToast(state.message);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListTest(),
                        settings: RouteSettings(name: 'ListTest')));
              }
            }
            else if (state is InitialuploadDamageScreenState) {
              if (state.isLoading == false && !state.isSuccess) {
                //  AppUtils.showSnackBar(context, state.message);
              } else if (state.isLoading == false && state.isSuccess) {
                print(
                    "DamageScreen Status ${state.deviceDetailsUploads.statusDescription.errorCode}");
                if (state.deviceDetailsUploads.statusDescription.errorCode ==
                    200) {
                  _pickedImage = "Success";
                  mToast("Image uploaded successfully");
                  EventTracker.logEvent("INVOICE_IMAGE_UPLOAD_SUCCESS");
                  setState(() {
                    clickButtonVisibility_ = true;
                    // buttonInvoiceUploadVisibility_ = false;
                  });
                }
              }
            }
            else if (state is IntialStoreInfoState) {
              if (state.isLoading == false && !state.isSuccess) {
                AppUtils.showSnackBar(context, state.message);
                storeName = "";
              } else if (state.isLoading == false && state.isSuccess) {
                spinnerItems = new List();
                if (state.storeList != null) {
                  for (int i = 0; i < state.storeList.length; i++) {
                    spinnerItems.add(StoreModel(
                      id: state.storeList[i].id,
                      storeName: state.storeList[i].storeName,
                      storeLocation: state.storeList[i].storeLocation,
                    ));
                  }
                  print("Array List Content ${spinnerItems.length} ");
                  if (spinnerItems != null && spinnerItems.length > 0) {
                    storeName = "Select Store";
                  } else {
                    storeName = "Store Not Found";
                  }
                  setState(() {
                    _storeController.text = (storeName);
                  });
                }
              }
            }
          },
          child: BlocBuilder(
            bloc: _bloc,
            builder: (context, OtpLoginProcessState state) {
              if (state is IntialCurrencyInfoState) {
                if (state.isLoading) {
                  isLoadingProgress = state.isLoading;
                } else {
                  isLoadingProgress = false;
                }
              }
              else if (state is InitialInvoiceUploadeState) {
                if (state.isLoading) {
                  isLoadingProgress = state.isLoading;
                } else {
                  isLoadingProgress = false;
                }
              }
              if (state is InitialuploadDamageScreenState) {
                if (state.isLoading) {
                  isLoadingProgress = state.isLoading;
                } else {
                  isLoadingProgress = false;
                }
              }
              if (state is InitialSaveUpdateUserDeviceInfoState) {
                if (state.isLoading) {
                  isLoadingProgress = state.isLoading;
                } else {
                  isLoadingProgress = false;
                }
              }
              if (state is IntialStoreInfoState) {
                if (state.isLoading) {
                  isLoadingProgress = state.isLoading;
                } else {
                  isLoadingProgress = false;
                }
              }

              return ModalProgressHUD(
                color: Colors.black,
                inAsyncCall: isLoadingProgress,
                child: RegistrationProcessForm(
                  formKey: _formKey,
                  userFirstNameController: _userFirstNameController,
                  userLastNameController: _userLastNameController,
                  userEmailController: _userEmailController,
                  phoneNumberController: _phoneNumberController,
                  inVoiceAmmountController: _inVoiceAmmountController,
                  deviceImeiTextController: _deviceImeiTextController,
                  inVoiceDateController: _inVoiceDateController,
                  imeiEditableFlag: _imeiEditableFlag,
                  flagVisibleImei: _flagVisibleImei,
                  flagVisibleNationalID: _flagVisibleNationalID,
                  flagVisibleFatherName: _flagVisibleFatherName,
                  nationalIDtextController: _nationalIDtextController,
                  mFathereNametextController: _mFathereNametextController,
                  lenghtCurrecy: lenghtCurrecy,
                  flagEditableFirstName: flagEditableFirstName_,
                  flagEditableLasttName: flagEditableLasttName_,
                  flagEditableEmail: flagEditableEmail_,
                  flagEditableMobilenumber: flagEditableMobilenumber_,
                  flagVisibleInvoiceAmmount: flagVisibleInvoiceAmmount_,
                  flagVisibleInvoiceDate: flagVisibleInvoiceDate_,
                  buttonInvoiceUploadVisibility: buttonInvoiceUploadVisibility_,
                  clickButtonVisibility: clickButtonVisibility_,
                  spinnerVisibilty: spinnerVisibilty_,
                  imageFile: imageFile_,
                  uploadImageText: uploadImageText,
                  storeController: _storeController,
                  operatorConfig:
                      operatorConfig == null ? null : operatorConfig,
                  clickInvoiceUpload: () {
                    _pickImage();
                  },
                  onDatePickerClick: () {
                    onDatePickerClick();
                  },
                  onNextClick: () {
                    EventTracker.logEvent("ON_REGISTRATION_NEXT_CLICK");
                    mNextClick();
                  },
                  onStoreClick: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Select Store'),
                            content: Container(
                              height: 170.0,
                              width: 50.0,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: spinnerItems.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                      title:
                                          Text(spinnerItems[index].storeName),
                                      onTap: () {
                                        Navigator.pop(context, true);
                                        setState(() {
                                          selectedStore =
                                              spinnerItems[index].storeName;
                                          print("Country Code $selectedStore");
                                          _storeController =
                                              TextEditingController(
                                                  text: selectedStore);
                                        });
                                      });
                                },
                              ),
                            ),
                          );
                        });
                  },
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
                    DateTime.now().month - 6, DateTime.now().day),
                lastDate: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day),
                onChanged: (val) {
                  convertDateFromString(val.toString());
                  Navigator.pop(context);
                },
              ),
            ));
  }

  void handleReadOnlyInputClick_(context) {
    showBottomSheet(
        context: context,
        builder: (BuildContext context) => Container(
              width: MediaQuery.of(context).size.width,
              child: MonthPicker(
                selectedDate: DateTime.now(),
                firstDate: DateTime(DateTime.now().year,
                    DateTime.now().month - 6, DateTime.now().day),
                lastDate: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day),
                onChanged: (val) {
                  print(val);
                  Navigator.pop(context);
                },
              ),
            ));
  }

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

  void _showDialog() {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(""),
          content: new Text(
              "Dear Customer, this service is not eligible for this device. "),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                exit(0);
              },
            ),
          ],
        );
      },
    );
  }

  void _pickImage() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Select Camera"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Camera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
              ],
            ));

    if (imageSource != null) {
      final file = await ImagePicker.pickImage(source: imageSource);
      uploadImageText = Utils.ReUpload;
      if (file != null) {
        imageFile_ = file;
        setState(() {});
        File image = file;
        if (image != null) {
          print("Damage Image Upload ===  $image");
          _bloc.add(UploadDamageScreenEvent(
              userId: PreferenceUtils.getString(Utils.USER_ID),
              source: StringConstants.SOURCE,
              damagedScreen: image == null ? null : image));
        }
      }
    }
  }

  void mDialogSuccess(String title, String Discription) {
    SweetAlert.show(context,
        title: title, subtitle: Discription, style: SweetAlertStyle.success);
  }

  void mNextClick() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

//                      if (PreferenceUtils.getString(Utils.appPackageName) ==
//                          "com.app.altruists_secure_bangla") {
//                        if (_pickedImage == null || _pickedImage == "") {
//                          mToast("Please Upload Invoice");
//                          return;
//                        }
//                      }

      if (flagVisibleInvoiceDate_ == true && registerDate == null) {
        mToast(Utils.InvoiceDate);
      } else {
        var userFirstName = _userFirstNameController.text.toString();
        var userLastName = _userLastNameController.text.toString();

        print("userFirstName $userFirstName ");
        print("userLastName $userLastName ");

        var userEmail = _userEmailController.text.toString();
        var userPhoneNumber = _phoneNumberController.text.toString();
        var userInvoiceAmount;

        if (_inVoiceAmmountController.text.toString() != null) {
          userInvoiceAmount = _inVoiceAmmountController.text.toString();
        } else {
          userInvoiceAmount = "";
        }
        var userInvoiceDate;
        if (_inVoiceDateController.text.toString() != null) {
          userInvoiceDate = _inVoiceDateController.text.toString();
        } else {
          userInvoiceDate = "";
        }

        var nationalID;

        if (_nationalIDtextController.text.toString() != null) {
          nationalID = _nationalIDtextController.text.toString();
        } else {
          nationalID = "";
        }
        var fatherName;

        if (_mFathereNametextController.text.toString() != null) {
          fatherName = _mFathereNametextController.text.toString();
        } else {
          fatherName = "";
        }
        PreferenceUtils.setString(Utils.IMEI, deviceIemiNumber);
        if (Platform.isAndroid) {
          if (AndroidSdk >= 29) {
            deviceIemiNumber = _deviceImeiTextController.text.toString();
          }
        } else {
          deviceIemiNumber = _deviceImeiTextController.text.toString();
        }
        PreferenceUtils.setString(Utils.IMEI, deviceIemiNumber);

        //   print("deviceIemiNumber $deviceIemiNumber");
        print("IOS Come at end.... ");

        var packageName = PreferenceUtils.getString(Utils.appPackageName);
        print("packageName  ========  $packageName ");
        if (PreferenceUtils.getString(Utils.appPackageName) ==
                "com.app.altruists_secure_bangla".trim() ||
            PreferenceUtils.getString(Utils.appPackageName) ==
                "com.app.altruists-secure-bangla") {
          print("Inside Package Called ");
          var imeiValue = _deviceImeiTextController.text;
          //  print("Iemi text value $imeiValue");
          if (Platform.isAndroid) {
            if (AndroidSdk >= 29) {
              EventTracker.logEvent("REGISTRATION_CONFIRM_CLICK_EVENT");
              print("altruists_secure_bangla userFirstName $userFirstName ");
              print("altruists_secure_bangla userLastName $userLastName ");
              print("altruists_secure_bangla userEmail $userEmail ");
              print(
                  "altruists_secure_bangla userPhoneNumber $userPhoneNumber ");
              var saveUserDeviceInfoRequestModel =
                  SaveUserDeviceInfoRequestModel(
                      userId: PreferenceUtils.getString(Utils.USER_ID),
                      source: StringConstants.SOURCE,
                      deviceDetails: DeviceDetails(
                        currency: "",
                        customerFirstName: userFirstName,
                        customerMiddleName: "",
                        customerLastName: userLastName,
                        mobileNumber: userPhoneNumber,
                        email: userEmail,
                        deviceName: deviceName,
                        deviceModel: deviceModel,
                        imieNumber: "",
                        deviceOs: deviceType,
                        deviceOsVersion: deviceOS,
                        invoiceAmount: "",
                        invoiceDate: "",
                        fatherName: _mFathereNametextController.text,
                        nationalId: _nationalIDtextController.text,
                        marketValue: "",
                        sumAssuredValue: "",
                      ));

              _bloc.add(SaveUpdateUserDeviceInfoClickEvent(
                  saveUserDeviceInfoRequestModel:
                      saveUserDeviceInfoRequestModel));
            } else {
              EventTracker.logEvent("REGISTRATION_CONFIRM_CLICK_EVENT");
              print("altruists_secure_bangla  userFirstName $userFirstName ");
              print("altruists_secure_bangla  userLastName $userLastName ");
              print("altruists_secure_bangla  userEmail $userEmail ");
              print(
                  "altruists_secure_bangla IOS userPhoneNumber $userPhoneNumber ");
              var saveUserDeviceInfoRequestModel =
                  SaveUserDeviceInfoRequestModel(
                      userId: PreferenceUtils.getString(Utils.USER_ID),
                      source: StringConstants.SOURCE,
                      deviceDetails: DeviceDetails(
                        currency: "",
                        customerFirstName: userFirstName,
                        customerMiddleName: "",
                        customerLastName: userLastName,
                        mobileNumber: userPhoneNumber,
                        email: userEmail,
                        deviceName: deviceName,
                        deviceModel: deviceModel,
                        imieNumber: "",
                        deviceOs: deviceType,
                        deviceOsVersion: deviceOS,
                        invoiceAmount: "",
                        invoiceDate: "",
                        fatherName: _mFathereNametextController.text,
                        nationalId: _nationalIDtextController.text,
                        marketValue: "",
                        sumAssuredValue: "",
                      ));

              _bloc.add(SaveUpdateUserDeviceInfoClickEvent(
                  saveUserDeviceInfoRequestModel:
                      saveUserDeviceInfoRequestModel));
            }
          } else if (Platform.isIOS) {
            // iOS-specific code
            EventTracker.logEvent("REGISTRATION_CONFIRM_CLICK_EVENT");
            print("IOS Code Called");
            print("altruists_secure_bangla IOS userFirstName $userFirstName ");
            print("altruists_secure_bangla IOS userLastName $userLastName ");
            print("altruists_secure_bangla IOS userEmail $userEmail ");
            print(
                "altruists_secure_bangla IOS userPhoneNumber $userPhoneNumber ");
            var saveUserDeviceInfoRequestModel = SaveUserDeviceInfoRequestModel(
                userId: PreferenceUtils.getString(Utils.USER_ID),
                source: StringConstants.SOURCE,
                deviceDetails: DeviceDetails(
                  currency: "",
                  customerFirstName: userFirstName,
                  customerMiddleName: "",
                  customerLastName: userLastName,
                  mobileNumber: userPhoneNumber,
                  email: userEmail,
                  deviceName: deviceName,
                  deviceModel: deviceModel,
                  imieNumber: _deviceImeiTextController.text,
                  deviceOs: deviceType,
                  deviceOsVersion: deviceOS,
                  invoiceAmount: "",
                  invoiceDate: "",
                  fatherName: _mFathereNametextController.text,
                  nationalId: _nationalIDtextController.text,
                  marketValue: "",
                  sumAssuredValue: "",
                ));

            _bloc.add(SaveUpdateUserDeviceInfoClickEvent(
                saveUserDeviceInfoRequestModel:
                    saveUserDeviceInfoRequestModel));
          }
        } else {
          print("IOS Bie Pass Called ");
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
                    operatorConfig == null ? "" : operatorConfig.currency,
                    userFirstName,
                    userLastName,
                    nationalID,
                    fatherName),
                settings: RouteSettings(name: 'RegistrationConfirm')),
          );
        }
      }
//                      if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "88") {
//                        var userFirstName =
//                        _userFirstNameController.text.toString();
//                        var userLastName =
//                        _userLastNameController.text.toString();
//
//                        print("userFirstName $userFirstName ");
//                        print("userLastName $userLastName ");
//
//                        var userEmail = _userEmailController.text.toString();
//                        var userPhoneNumber =
//                        _phoneNumberController.text.toString();
//                        var userInvoiceAmount =
//                        _inVoiceAmmountController.text.toString();
//                        var userInvoiceDate =
//                        _inVoiceDateController.text.toString();
//
//                        var nationalID;
//                        var fatherName;
//
//                        if (_nationalIDtextController.text.toString() != null) {
//                          nationalID = _nationalIDtextController.text.toString();
//                        }
//
//                        if (_mFathereNametextController.text.toString() != null) {
//                          fatherName = _mFathereNametextController.text.toString();
//                        } else {
//                          fatherName = "";
//                        }
//
//                        if (Platform.isAndroid) {
//                          if (AndroidSdk >= 29) {
//                            deviceIemiNumber =
//                                _deviceImeiTextController.text.toString();
//                          }
//                        } else {
//                          deviceIemiNumber =
//                              _deviceImeiTextController.text.toString();
//                        }
//                        //   print("deviceIemiNumber $deviceIemiNumber");
//
//                        if(nationalID!=n)
//                        Navigator.pushReplacement(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) => RegistrationConfirm(
//                                  userFirstName,
//                                  userEmail,
//                                  userPhoneNumber,
//                                  userInvoiceAmount,
//                                  userInvoiceDate,
//                                  deviceIemiNumber,
//                                  operatorConfig == null
//                                      ? ""
//                                      : operatorConfig.currency,
//                                  userFirstName,
//                                  userLastName,
//                                  nationalID,
//                                  fatherName),
//                              settings:
//                              RouteSettings(name: 'RegistrationConfirm')),
//                        );
//
//                      }else{

      //}
    }
  }

  void onDatePickerClick() {
    FocusScope.of(context).requestFocus(new FocusNode());
    //  handleReadOnlyInputClick(context);
    showMonthPicker(
      context: context,
      firstDate: DateTime(
          DateTime.now().year, DateTime.now().month - 12, DateTime.now().day),
      lastDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
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
  }

  Future _unSuccessPop(String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {},
          child: Dialog(
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
          ),
        );
      },
    );
  }
}
