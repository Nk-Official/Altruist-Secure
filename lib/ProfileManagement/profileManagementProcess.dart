import 'dart:developer';
import 'dart:io';
import 'package:altruist_secure_flutter/ProfileManagement/profileManagementForm.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/apis/apis.dart';
import 'package:altruist_secure_flutter/blocs/customerInfo/bloc.dart';
import 'package:altruist_secure_flutter/models/requests/profile_update_info/profileupdate_info.dart';
import 'package:altruist_secure_flutter/models/requests/profileget_info_request/profileget_info.dart';
import 'package:altruist_secure_flutter/ui/homeNewScreen/NewHomeDashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:io' show Platform;
import 'package:toast/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:date_format/date_format.dart';
import 'package:sweetalert/sweetalert.dart';

class ProfileMain extends StatefulWidget {
  @override
  _ProfileMainState createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> {
  CustomeInfoBloc _bloc;
  bool isLoadingProgress = false;
  TextEditingController _alternativeNumberTextController;
  TextEditingController _emailTextController;
  TextEditingController _dobTextController;
  TextEditingController _addressTextController;
  TextEditingController _userGenderController;
  TextEditingController _nameTextController;
  TextEditingController _mobileNumberTextController;
  TextEditingController _deviceNameTextController;
  TextEditingController _deviceModelTextController;
  TextEditingController _deviceImeiTextController;
  TextEditingController _invoiceAmountTextController;
  TextEditingController _invoiceDateTextController;
  TextEditingController _nationalIDtextController;
  TextEditingController _mFathereNametextController;
  TextEditingController _mCountryCodeController;
  bool _flagVisibleNationalID;
  bool _flagVisibleFatherName;
  bool flagVisibleInvoiceMonth_;
  bool flagVisibleInvoiceValue_;

  String Gender;
  String dropdownValue = 'Select Your Gender';
  List<String> spinnerItems = ['Male', 'Female', 'Others'];
  DateTime selectedDate;
  var SelectedDOB;
  GlobalKey<FormState> _formKey;
  var seletedGender;
  int mobileNumberLength_;

  String deviceModel,
      deviceName,
      deviceOS,
      deviceType,
      currencyInfo,
      deviceIemiNumber;

  @override
  void initState() {
    super.initState();
    PreferenceUtils.init();
    _formKey = GlobalKey<FormState>();
    selectedDate = DateTime.now();
    _emailTextController = TextEditingController();

    deviceName = PreferenceUtils.getString(Utils.MobileBrand);
    deviceModel = PreferenceUtils.getString(Utils.MobileModel);
    // deviceIemiNumber = PreferenceUtils.getString(Utils.MobileID);
    deviceOS = PreferenceUtils.getString(Utils.MobileOS);
    deviceType = PreferenceUtils.getString(Utils.DeviceType);





    var nameUser = PreferenceUtils.getString(Utils.USERNAME);
    print("UserName $nameUser");
    _nameTextController = TextEditingController(text: nameUser);
    _emailTextController =
        TextEditingController(text: PreferenceUtils.getString(Utils.USEREMAIL));
    _mobileNumberTextController = TextEditingController(
        text: PreferenceUtils.getString(Utils.MOBILENUMBER));
    _deviceNameTextController = TextEditingController(
        text: PreferenceUtils.getString(Utils.DEVICENAME));
    _deviceModelTextController = TextEditingController(
        text: PreferenceUtils.getString(Utils.DEVICEMODEL));

    _deviceImeiTextController = TextEditingController(
        text: PreferenceUtils.getString(Utils.DEVICEIMEI));

    // _deviceImeiTextController = TextEditingController(text: "");
    _invoiceAmountTextController = TextEditingController(
        text: PreferenceUtils.getString(Utils.INVOICEAMOUNT));
    _invoiceDateTextController = TextEditingController(
        text: PreferenceUtils.getString(Utils.INVOICEDATE));
    _nationalIDtextController = TextEditingController(
        text: PreferenceUtils.getString(Utils.USERNAMTIONALID));
    _mFathereNametextController = TextEditingController(
        text: PreferenceUtils.getString(Utils.USERFATHERNAME));

    if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "254") {
      _flagVisibleNationalID = true;
      _flagVisibleFatherName = false;
    } else if (PreferenceUtils.getString(Utils.COUNTRY_ID) == "88") {
      _flagVisibleNationalID = true;
      _flagVisibleFatherName = true;
    } else {
      _flagVisibleNationalID = false;
      _flagVisibleFatherName = false;
    }

    if(PreferenceUtils.getString(Utils.MOBILE_NUMBER_LENTH)!=null){
      mobileNumberLength_ = int.parse(PreferenceUtils.getString(Utils.MOBILE_NUMBER_LENTH));
    }else{
      mobileNumberLength_ = 10;
    }

    if(PreferenceUtils.getString(Utils.COUNTRY_ID)!=null){
      _mCountryCodeController =  TextEditingController(text: "+" + PreferenceUtils.getString(Utils.COUNTRY_ID));
    }else{
      _mCountryCodeController =  TextEditingController(text: "+" +PreferenceUtils.getString(Utils.COUNTRY_ID));
    }


    if(PreferenceUtils.getString(Utils.appPackageName) == "com.app.mansardecure_secure"){
      flagVisibleInvoiceMonth_ = false;
      flagVisibleInvoiceValue_ = false;
    }else{
      flagVisibleInvoiceMonth_ = true;
      flagVisibleInvoiceValue_ = true;
    }
    setState(() {});

    _bloc = CustomeInfoBloc(apisRepository: ApisRepository());
    var getProfileRequestModel = ProfileGetInfo(
        userId: int.parse(PreferenceUtils.getString(Utils.USER_ID)));
    _bloc.add(GetUserDetailsEvent(profileGetInfo: getProfileRequestModel));

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewHomeDashBoard(""))),
        child: Scaffold(
      resizeToAvoidBottomPadding: false,
      body: BlocListener(
        bloc: _bloc,
        listener: (BuildContext context, CustomeInfoState state) {
          if (state is CustomeInfoState) {
            if (state is InitialuserGetInfoState) {
              print("Get Profile Response Called ");
              if (state.isLoading == false && !state.isSuccess) {
                //  AppUtils.showSnackBar(context, state.message);
                //     AppUtils.showSnackBar(context, state.message);
              } else if (state.isLoading == false && state.isSuccess) {
                //  AppUtils.showSnackBar(context, state.message);
                var alternativeNumber;
                var email;
                var dob;
                var address;
                var gender;

                var emailinside = state.profileGetInfoResponse.user.email;
                print("Email  $emailinside");

                if (state.profileGetInfoResponse.user.alternativeNumber !=
                    null) {
                  alternativeNumber =
                      state.profileGetInfoResponse.user.alternativeNumber;
                } else {
                  alternativeNumber = "";
                }
                if (state.profileGetInfoResponse.user.email != null) {
                  email = state.profileGetInfoResponse.user.email;
                } else {
                  email = "";
                }

                if (state.profileGetInfoResponse.user.dob != null) {
                  dob = state.profileGetInfoResponse.user.dob;
                } else {
                  dob = "";
                }
                if (state.profileGetInfoResponse.user.address != null) {
                  address = state.profileGetInfoResponse.user.address;
                } else {
                  address = "";
                }

                if (state.profileGetInfoResponse.user.gender != null) {
                  gender = state.profileGetInfoResponse.user.gender;
                } else {
                  gender = "";
                }

                _alternativeNumberTextController =
                    TextEditingController(text: alternativeNumber);
                _emailTextController = TextEditingController(text: email);
                _dobTextController = TextEditingController(text: dob);
                _addressTextController = TextEditingController(text: address);
                _userGenderController = TextEditingController(text: gender);
                // Gender = gender;
                setState(() {});
              }
            } else if (state is InitialuserUpdateInfoState) {
              if (state.isLoading == false && !state.isSuccess) {
                //    AppUtils.showSnackBar(context, state.message);
              } else if (state.isLoading == false && state.isSuccess) {
                //  AppUtils.showSnackBar(context, state.message);
                mDialogSuccess("", "Information updated successfully");

//                var getProfileRequestModel = ProfileGetInfo(
//                    userId:
//                        int.parse(PreferenceUtils.getString(Utils.USER_ID)));
//                _bloc.add(GetUserDetailsEvent(
//                    profileGetInfo: getProfileRequestModel));
              }
            }
          }
        },
        child: BlocBuilder(
          bloc: _bloc,
          builder: (context, CustomeInfoState state) {
            if (state is InitialuserGetInfoState) {
              if (state.isLoading) {
                isLoadingProgress = state.isLoading;
              } else {
                isLoadingProgress = false;
              }
            } else if (state is InitialuserUpdateInfoState) {
              if (state.isLoading) {
                isLoadingProgress = state.isLoading;
              } else {
                isLoadingProgress = false;
              }
            }
            return ModalProgressHUD(
              color: Colors.black,
              inAsyncCall: isLoadingProgress,
              child: ProfileManagementFormScreen(
                formKey: _formKey,
                userAlternativeNumberController:
                    _alternativeNumberTextController,
                userEmailController: _emailTextController,
                userDOBController: _dobTextController,
                userAddressController: _addressTextController,
                userGenderController: _userGenderController,
                nameTextController: _nameTextController,
                mobileNumberTextController: _mobileNumberTextController,
                deviceNameTextController: _deviceNameTextController,
                deviceModelTextController: _deviceModelTextController,
                deviceImeiTextController: _deviceImeiTextController,
                invoiceAmountTextController: _invoiceAmountTextController,
                invoiceDateTextController: _invoiceDateTextController,
                nationalIDtextController: _nationalIDtextController,
                mFathereNametextController: _mFathereNametextController,
                flagVisibleNationalID: _flagVisibleNationalID,
                flagVisibleFatherName: _flagVisibleFatherName,
                mobileNumberLength: mobileNumberLength_,
                mAlternativeCountryController:_mCountryCodeController ,
                flagVisibleInvoiceMonth: flagVisibleInvoiceMonth_,
                flagVisibleInvoiceValue:flagVisibleInvoiceValue_ ,
                onDOBClick: () {
                  _selectDate(context);
                },
                onSubmitClick: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    var alternativeNumber;
                    var email;
                    var dob;
                    var address;
                    var gender;

                    var emailinside = _emailTextController.text.toString();
                    if (_alternativeNumberTextController.text.toString() !=
                        null) {
                      alternativeNumber =
                          _alternativeNumberTextController.text.toString();
                    } else {
                      alternativeNumber = "";
                    }
                    if (_emailTextController.text.toString() != null) {
                      email = _emailTextController.text.toString();
                    } else {
                      email = "";
                    }

                    if (_dobTextController.text.toString() != null) {
                      dob = _dobTextController.text.toString();
                    } else {
                      dob = "";
                    }
                    if (_addressTextController.text.toString() != null) {
                      address = _addressTextController.text.toString();
                    } else {
                      address = "";
                    }
                    if (_userGenderController.text.toString() != null) {
                      Gender = _userGenderController.text.toString();
                    } else {
                      Gender = "";
                    }

                    var getProfileRequestModel = ProfileUpdateRequest(
                        userId:
                            int.parse(PreferenceUtils.getString(Utils.USER_ID)),
                        address: address,
                        alternativeNumber: alternativeNumber,
                        email: email,
                        dob: dob,
                        gender: Gender);
                    _bloc.add(UpDateEvent(
                        mProfileUpdateRequest: getProfileRequestModel));
//                    if (state.user.gender != null) {
//                      gender = state.user.gender;
//                    } else {
//                      gender = "";
//                    }
                  }
                },
                onGenderClick: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Container(
                            height: 150.0,
                            width: 50.0,
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: spinnerItems.length,


                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                    title: Text(spinnerItems[index]

                                    ),
                                    onTap: () {
//                                      mCountryCode_ =  itemList[index].countryCode;
                                      Navigator.pop(context, true);
                                      setState(() {
                                        seletedGender =
                                            spinnerItems[index].toString();
                                        print("Country Code $seletedGender");
                                        _userGenderController =
                                            TextEditingController(
                                                text: seletedGender);
                                      });
                                    },);

                              },
                              separatorBuilder: (context, index) {
                                return Divider();
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
      ),
    ));
  }

  void mToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

//  Future<Null> _selectDate(BuildContext context) async {
//    var currentYear = DateTime.now().year;
//    print("currentYear ====  $currentYear");
//    final DateTime picked = await showDatePicker(
//        context: context,
//        initialDate: DateTime.now(),
//        firstDate: DateTime.now(),
//        lastDate: DateTime(currentYear));
//    if (picked != null && picked != selectedDate)
//      setState(() {
//        selectedDate = picked;
//        SelectedDOB = picked;
//      });
//  }

  Future<Null> _selectDate(BuildContext context) async {
    var lastDate = DateTime.now().year;
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day);
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      SelectedDOB = picked;
      convertDateFromString(selectedDate.toString());
    }
  }

  void convertDateFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);
    print(todayDate);
    setState(() {
      var registerDate = (formatDate(todayDate, [yyyy, '-', mm, '-', dd]));
      log('DOB Date $registerDate');
      _dobTextController = TextEditingController(text: registerDate.toString());
    });
  }

  void mDialogSuccess(String title, String Discription) {
    SweetAlert.show(context,
        title: title, subtitle: Discription, style: SweetAlertStyle.success);

    Future.delayed(const Duration(milliseconds: 2000), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => NewHomeDashBoard(""),
            settings: RouteSettings(name: 'headPhoneTest')),
      );
    });
  }
}
