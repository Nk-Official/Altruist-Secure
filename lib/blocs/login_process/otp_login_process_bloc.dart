import 'dart:async';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/apis/apis.dart';
import 'package:altruist_secure_flutter/models/requests/currencyInfo/CurrencyInfoRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/customer_info/CustomerInfoRequestModel.dart';
import 'package:altruist_secure_flutter/models/responses/coupenResponse/CoupenResponse.dart';
import 'package:altruist_secure_flutter/models/responses/cuntryinfo/CuntryResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/currencyInfo/CurrencyInfoResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/customer_info/CustomerInfoResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/damageresponse/damageresponse.dart';
import 'package:altruist_secure_flutter/models/responses/emialresponse/emailResponse.dart';
import 'package:altruist_secure_flutter/models/responses/invoiceUpload/InvoiceResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/register/RegisterResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/saveUpdateUserDeviceInfo/SaveUserDeviceInfoResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/send_otp/SendOtpResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/storeResponse/StoreResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/uploadIDProofs/IDProofsResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/verify_otp/VerifyOtpResponseModel.dart';
import 'package:altruist_secure_flutter/utils/StringConstants.dart';
import 'package:altruist_secure_flutter/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpLoginProcessBloc
    extends Bloc<OtpLoginProcessEvent, OtpLoginProcessState> {
  final ApisRepository apisRepository;

  OtpLoginProcessBloc({this.apisRepository});

  @override
  OtpLoginProcessState get initialState => InitialOtpLoginProcessState();

  @override
  Stream<OtpLoginProcessState> mapEventToState(
    OtpLoginProcessEvent event,
  ) async* {
    if (event is RegisterUserEvent) {
      yield* _mapRegisterUserClickState(event);
    } else if (event is SendOtpEvent) {
      yield* _mapSendOtpClickEvent(event);
    } else if (event is VerifyOtpEvent) {
      yield* _mapVerifyOtpClickEvent(event);
    } else if (event is FetchCustomerInfoEvent) {
      yield* _mapCustomInfoEventState(event);
    } else if (event is FetchCurrencyInfoEvent) {
      yield* _mapCurrencyInfoEventState(event);
    } else if (event is FetchCountryEvent) {
      yield* _mapCuntryEventState(event);
    } else if (event is EmailEvent) {
      yield* _mapEmailEventState(event);
    }else if (event is UploadInvoiceEvent) {
      yield* _mapUploadInvoiceEventState(event);
    }else if (event is DamageStatusEvent) {
      yield* _mapDamageStatusInfo(event);
    }else if (event is UploadDamageScreenEvent) {
      yield* _mapUploadDamageEventState(event);
    }else if (event is SaveUpdateUserDeviceInfoClickEvent) {
      yield* _mapSaveUpdateUserDeviceInfoState(event);
    }else if (event is FetchStoreEvent) {
      yield* _mapStoreEventState(event);
    }
  }

  Stream<OtpLoginProcessState> _mapCustomInfoEventState(
      FetchCustomerInfoEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    CustomerInfoResponseModel response;
    PreferenceUtils.init();
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialUserLoginlocState(
          isLoading: true, isSuccess: false, message: "");
      response = await apisRepository.customerInfo(
          CustomerInfoRequestModel(
              source: StringConstants.SOURCE,
              userId: PreferenceUtils.getString(Utils.USER_ID)),
          PreferenceUtils.getString(Utils.JWT_TOKEN));
      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
      } else {
        errorMessage = response.statusDescription.errorMessage;
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      yield InitialUserLoginlocState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
          subscriptions: response.subscriptions,
          deviceDiagnosResults: response.deviceDiagnosResults,
          deviceDetails: response.deviceDetails);
    } else {
      yield InitialUserLoginlocState(
          isLoading: false, isSuccess: true, message: errorMessage);
    }
  }


  Stream<OtpLoginProcessState> _mapRegisterUserClickState(
      RegisterUserEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    RegisterResponseModel response;
    if (event.otp == "") {
      errorMessage = StringConstants.ENTER_VALID_OTP;
    } else if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialOtpLoginProcessState(
          isLoading: true, isSuccess: false, message: "");
      response = await apisRepository.register(event.registerRequestModel);
      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
      } else {
        errorMessage = response.statusDescription.errorMessage;
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
//      final prefs = await SharedPreferences.getInstance();
      PreferenceUtils.init();
//      SharedPrefs sharedPrefUtils = SharedPrefs(prefs: prefs);
      PreferenceUtils.setString(
          Utils.JWT_TOKEN, response.user.userTokenDetails.jwtToken);
      PreferenceUtils.setString(Utils.USER_ID, response.user.id.toString());
      PreferenceUtils.setString(Utils.MSISDN, response.user.msisdn);
      PreferenceUtils.setString(Utils.ISLOGIN, "true");
//      PreferenceUtils.setString(Utils.COUNTRY_ID, response.user.countryId);
//      sharedPrefUtils.setValue(
//          sharedPrefUtils.JWT_TOKEN, response.user.userTokenDetails.jwtToken);
//      sharedPrefUtils.setValue(sharedPrefUtils.USER_ID, response.user.id);
//      sharedPrefUtils.setValue(sharedPrefUtils.MSISDN, response.user.msisdn);
//      sharedPrefUtils.setValue(sharedPrefUtils.ISLOGIN, true);
//      sharedPrefUtils.setValue(
//          sharedPrefUtils.COUNTRY_ID, response.user.countryId);

      yield InitialOtpLoginProcessState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage);
    } else {
      yield InitialOtpLoginProcessState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }

  Stream<OtpLoginProcessState> _mapSendOtpClickEvent(
      SendOtpEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    SendOtpResponseModel response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialOtpLoginProcessState(
          isLoading: true, isSuccess: false, message: "");
      response = await apisRepository.sendOtp(event.sendOtpRequestModel);
      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
      } else {
        errorMessage = response.statusDescription.errorMessage;
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      yield InitialOtpLoginProcessState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
          transactionId: response.transactionId);
    } else {
      yield InitialOtpLoginProcessState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }

  Stream<OtpLoginProcessState> _mapVerifyOtpClickEvent(
      VerifyOtpEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    VerifyOtpResponseModel response;
    if (event.otp == "") {
      errorMessage = StringConstants.ENTER_VALID_OTP;
    } else if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialOtpLoginProcessState(
          isLoading: true, isSuccess: false, message: "");
      response = await apisRepository.verifyOtp(event.verifyOtpRequestModel);
      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
      } else {
        errorMessage = response.statusDescription.errorMessage;
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      PreferenceUtils.setString(
          Utils.JWT_TOKEN, response.user.userTokenDetails.jwtToken);
      PreferenceUtils.setString(Utils.USER_ID, response.user.id.toString());
      PreferenceUtils.setString(Utils.MSISDN, response.user.msisdn);
      PreferenceUtils.setString(Utils.ISLOGIN, "true");
      var isLogin = PreferenceUtils.getString(Utils.ISLOGIN);
      print("Save Prefrence Value:   $isLogin ");
      // print("response.user.id.toString():  ${response.user.id.toString()}");
      // print("USER_ID in api ===  ${PreferenceUtils.getString(Utils.USER_ID)}");

//      PreferenceUtils.setString(Utils.COUNTRY_ID, response.user.countryId);
//      SharedPrefs sharedPrefUtils = SharedPrefs(prefs: prefs);
//      sharedPrefUtils.setValue(
//          sharedPrefUtils.JWT_TOKEN, response.user.userTokenDetails.jwtToken);
//      sharedPrefUtils.setValue(sharedPrefUtils.USER_ID, response.user.id);
//      sharedPrefUtils.setValue(sharedPrefUtils.MSISDN, response.user.msisdn);
//      sharedPrefUtils.setValue(sharedPrefUtils.ISLOGIN, true);
//      sharedPrefUtils.setValue(
//          sharedPrefUtils.COUNTRY_ID, response.user.countryId);

      yield InitialOtpLoginProcessState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage);
    } else {
      yield InitialOtpLoginProcessState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }

  Stream<OtpLoginProcessState> _mapCurrencyInfoEventState(
      FetchCurrencyInfoEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    CurrencyInfoResponseModel response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      var Model = "";
      if (PreferenceUtils.getString(Utils.MobileModel) != null &&
          !PreferenceUtils.getString(Utils.MobileModel).isEmpty) {
        Model = PreferenceUtils.getString(Utils.MobileModel).trim();
      } else {
        Model = "";
      }

      var TecCode;
      if (PreferenceUtils.getString(Utils.TECCODE) != null ) {
        TecCode = PreferenceUtils.getString(Utils.TECCODE);
      } else {
        TecCode = "";
      }

      var OperatorCode;
      if (PreferenceUtils.getString(Utils.OPERATORCODE) != null) {
        OperatorCode = PreferenceUtils.getString(Utils.OPERATORCODE);
      } else {
        OperatorCode = "";
      }

      var technicalModel;
      if (PreferenceUtils.getString(Utils.MobileTec) != null) {
        technicalModel = PreferenceUtils.getString(Utils.MobileTec);
      } else {
        technicalModel = "";
      }

      print("Model Name $Model");
      yield IntialCurrencyInfoState(
          isLoading: true, isSuccess: false, message: "");
      response = await apisRepository.getCurrencyInfo(
          CurrencyInfoRequestModel(
            userId: PreferenceUtils.getString(Utils.USER_ID),
            source: StringConstants.SOURCE,
            operatorCode: OperatorCode,
            countryId: PreferenceUtils.getString(Utils.COUNTRY_ID),
            deviceModelName: Model,
            tacCode: TecCode,
            technicalModel: technicalModel,

          ),
          PreferenceUtils.getString(Utils.JWT_TOKEN));
      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
      } else {
        errorMessage = response.statusDescription.errorMessage;
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      yield IntialCurrencyInfoState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
          operatorConfig: response.operatorConfig,errorCode:response.statusDescription.errorCode);
    } else {
      yield IntialCurrencyInfoState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,errorCode:response.statusDescription.errorCode );
    }
  }

  Stream<OtpLoginProcessState> _mapCuntryEventState(
      FetchCountryEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    CuntryResponseModel response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield IntialCuntryInfoState(
          isLoading: true, isSuccess: false, message: "");
      response = await apisRepository.getCuntryInfo(Utils.CountryUrl_);
      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
        print("Cuntry erroMessage in 200 $errorMessage");
      } else {
        errorMessage = response.statusDescription.errorMessage;
        print("Cuntry erroMessage in  $errorMessage");
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      print("Cuntry erroMessage   $response");
      yield IntialCuntryInfoState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
          countryList: response.countryList);
    } else {
      yield IntialCuntryInfoState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }

  Stream<OtpLoginProcessState> _mapEmailEventState(EmailEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    EmailResponce response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield EailInfoState(isLoading: true, isSuccess: false, message: "");
      var url = Utils.EmailUrl_ +
          PreferenceUtils.getString(Utils.USER_ID) +
          '/' +
          PreferenceUtils.getString(Utils.EmailFlag) +
          "/source/" +
          StringConstants.SOURCE +
          "?jwtToken=" +
          PreferenceUtils.getString(Utils.JWT_TOKEN);
      print('Email Url $url');
      response = await apisRepository.getmailRequestApi(url);
      if (response != null && response.errorCode == 200) {
        errorMessage = response.errorMessage;
        print("Email erroMessage in 200 $errorMessage");
      } else {
        errorMessage = response.errorMessage;
        print("Email erroMessage in  $errorMessage");
      }
    }
    if (response != null && response.errorCode == 200) {
      print("Email erroMessage   $response");
      yield EailInfoState(
          isLoading: false, isSuccess: true, message: response.errorMessage);
    } else {
      yield EailInfoState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }

  Stream<OtpLoginProcessState> _mapUploadInvoiceEventState(
      UploadInvoiceEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    InvoiceResponseModel response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialInvoiceUploadeState(
          isLoading: true, isSuccess: false, message: "");
      var filename = "image.jpg";
      response = await apisRepository.uploadInvoiceDoc(
          filename,
          event.invoiceFile,
          event.userId,
          event.source,
          PreferenceUtils.getString(Utils.JWT_TOKEN));
      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
      } else {
        errorMessage = response.statusDescription.errorMessage;
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      yield InitialInvoiceUploadeState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
          deviceDetails: response.deviceDetails);
    } else {
      yield InitialInvoiceUploadeState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }



  Stream<OtpLoginProcessState> _mapDamageStatusInfo(
      DamageStatusEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    DamageScreenResponse response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialDamageStatusScreenState(
          isLoading: true, isSuccess: false, message: "");

      var userId = PreferenceUtils.getString(Utils.USER_ID);
      var token = PreferenceUtils.getString(Utils.JWT_TOKEN);
      var JWT_TOKEN_QRCODE = PreferenceUtils.getString(Utils.JWT_TOKEN_QRCODE);
      var DamageScreenUrl_;

      if (PreferenceUtils.getString(Utils.appPackageName) ==
          "com.app.mansardecure_secure") {
        DamageScreenUrl_ = Utils.DamageScreenUrlV10;
      } else {
        DamageScreenUrl_ = Utils.DamageScreenUrl;
      }
      var DamageScreenUrl = DamageScreenUrl_ +
          userId +
          "/source/" +
          StringConstants.SOURCE +
          "/qrcodetoken/" +
          JWT_TOKEN_QRCODE +
          "?jwtToken=" +
          token;

      print('DamageScreenUrl Url: $DamageScreenUrl');
      response = await apisRepository.getDamageScreenStatus(DamageScreenUrl);
      print('DamageScreenUrl response : ${response.toString()}');
      print(
          'DamageScreenUrl response Code: ${response.statusDescription.errorCode}');
      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
      } else {
        errorMessage = response.statusDescription.errorMessage;
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      yield InitialDamageStatusScreenState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
          deviceDetailsUploads: response);
    } else if (response != null &&
        response.statusDescription.errorCode == 201) {
      print(
          'DamageScreenUrl Error Code: ${response.statusDescription.errorCode}');
      yield InitialDamageStatusScreenState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
          errorCode: "201");
    } else {
      yield InitialDamageStatusScreenState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }




  Stream<OtpLoginProcessState> _mapUploadDamageEventState(
      UploadDamageScreenEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    DamageScreenResponse response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialuploadDamageScreenState(
          isLoading: true, isSuccess: false, message: "");
      var filename = "image.jpeg";
      response = await apisRepository.uploadIdDamageScreen(
          filename,
          event.damagedScreen == null ? null : event.damagedScreen,
          event.userId,
          event.source,
          PreferenceUtils.getString(Utils.JWT_TOKEN));
      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
      } else {
        errorMessage = response.statusDescription.errorMessage;
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      yield InitialuploadDamageScreenState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
          deviceDetailsUploads: response);
    } else {
      yield InitialuploadDamageScreenState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }



  Stream<OtpLoginProcessState> _mapSaveUpdateUserDeviceInfoState(
      SaveUpdateUserDeviceInfoClickEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    SaveUserDeviceInfoResponseModel response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialSaveUpdateUserDeviceInfoState(
          isLoading: true, isSuccess: false, message: "");
      String mRE=  event.saveUserDeviceInfoRequestModel.toJson().toString();
      String mRE_=  event.saveUserDeviceInfoRequestModel.toString();
      print("Register Request ====== $mRE");
      print("Register Request mRE_ ====== $mRE_");
      response = await apisRepository.saveUpdateUserDeviceInfo(event.saveUserDeviceInfoRequestModel, PreferenceUtils.getString(Utils.JWT_TOKEN));
      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
      } else {
        errorMessage = response.statusDescription.errorMessage;
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      yield InitialSaveUpdateUserDeviceInfoState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage);
    } else {
      yield InitialSaveUpdateUserDeviceInfoState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }


  Stream<OtpLoginProcessState> _mapStoreEventState(
      FetchStoreEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    StoreResponseModel response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield IntialStoreInfoState(
          isLoading: true, isSuccess: false, message: "");
      response = await apisRepository.getStoreInfo(Utils.StoreUrl);
      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
        print("Store erroMessage in 200 $errorMessage");
      } else {
        errorMessage = response.statusDescription.errorMessage;
        print("Store erroMessage in $errorMessage");
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      print("Store erroMessage $response");
      yield IntialStoreInfoState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
          storeList: response.storeList);
    } else {
      yield IntialStoreInfoState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }



}
