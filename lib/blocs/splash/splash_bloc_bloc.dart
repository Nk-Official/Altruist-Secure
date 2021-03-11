import 'dart:async';
import 'package:altruist_secure_flutter/RegistrationForm/UI/Registration.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/apis/apis_repository.dart';
import 'package:altruist_secure_flutter/models/requests/customer_info/CustomerInfoRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/splash/SplashRequestModel.dart';
import 'package:altruist_secure_flutter/models/responses/HEUrlResponse/HeUrlResponse.dart';
import 'package:altruist_secure_flutter/models/responses/customer_info/CustomerInfoResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/heResponse/HeInfoResponse.dart';
import 'package:altruist_secure_flutter/models/responses/heResponse/HeResponse.dart';
import 'package:altruist_secure_flutter/models/responses/register/RegisterResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/splash/SplashResponseModel.dart';
import 'package:altruist_secure_flutter/utils/StringConstants.dart';
import 'package:altruist_secure_flutter/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import './bloc.dart';

class SplashBlocBloc extends Bloc<SplashBlocEvent, SplashBlocState> {
  final ApisRepository apisRepository;

  SplashBlocBloc({this.apisRepository});

  @override
  SplashBlocState get initialState => InitialSplashBlocState();

  @override
  Stream<SplashBlocState> mapEventToState(
    SplashBlocEvent event,
  ) async* {
    if (event is FetchCustomerInfoEvent) {
      yield* _mapCustomInfoEventState(event);
    } else if (event is UpdateSplashInfoEvent) {
      yield* _mapUpdateSplashInfoEventState(event);
    } else if (event is CustomerHERequestEvent) {
      yield* _mapCustomerHERequestEventState(event);
    } else if (event is HERequestEvent) {
      yield* _mapuserHEinfoRequestEventState(event);
    } else if (event is CustomerHEUrlEvent) {
      yield* _mapuserHEUrlEventState(event);
    } else if (event is RegisterUserEvent) {
      yield* _mapRegisterUserClickState(event);
    }
  }

  Stream<SplashBlocState> _mapCustomInfoEventState(
      FetchCustomerInfoEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    CustomerInfoResponseModel response;
    //PreferenceUtils.init();
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialSplashBlocState(
          isLoading: true, isSuccess: false, message: "");

      print(
          'User ID in starting  Inside api=== ${PreferenceUtils.getString(Utils.USER_ID)}');
      print(
          'User JWT_TOKEN  Inside api === ${PreferenceUtils.getString(Utils.JWT_TOKEN)}');
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

    print('User Satus Error Code === ${errorMessage}');
    if (response != null && response.statusDescription.errorCode == 200) {
      yield InitialSplashBlocState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
          subscriptions: response.subscriptions,
          deviceDiagnosResults: response.deviceDiagnosResults,
          deviceDetails: response.deviceDetails,
          user: response.user);
    } else if (response != null &&
        response.statusDescription.errorCode == 401) {
      yield InitialSplashBlocState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
          subscriptions: response.subscriptions,
          deviceDiagnosResults: response.deviceDiagnosResults,
          deviceDetails: response.deviceDetails,
          user: response.user);
    } else {
      yield InitialSplashBlocState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
          subscriptions: response.subscriptions,
          deviceDiagnosResults: response.deviceDiagnosResults,
          deviceDetails: response.deviceDetails,
          user: response.user);
    }
  }

  Stream<SplashBlocState> _mapUpdateSplashInfoEventState(
      UpdateSplashInfoEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    SplashResponseModel response;
    PreferenceUtils.init();
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
//      yield InitialSplashBlocState(
//          isLoading: true, isSuccess: false, message: "");
      response = await apisRepository.updateSplashInfo(
          SplashRequestModel(
              source: StringConstants.SOURCE,
              userId: PreferenceUtils.getString(Utils.USER_ID),
              versionCode: event.appVersion,
              fcmToken: event.fcmToken),
          PreferenceUtils.getString(Utils.JWT_TOKEN));
      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
      } else {
        errorMessage = response.statusDescription.errorMessage;
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      PreferenceUtils.setString(Utils.APP_VERSION, response.versionCode);
//      yield InitialSplashBlocState(
//          isLoading: false, isSuccess: true, versionCode: response.versionCode);
    } else {
//      yield InitialSplashBlocState(
//          isLoading: false, isSuccess: true, message: errorMessage);
    }
  }

  Stream<SplashBlocState> _mapCustomerHERequestEventState(
      CustomerHERequestEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    HeResponse response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialHEStatusScreenState(
        isLoading: true,
        isSuccess: false,
        message: "",
      );
      print('Heurl mCountryCode: ${event.mCountryCode}');
      var Heurl =
          Utils.HEUrl + event.mCountryCode + "/" + event.mCountryOperatorCode;
      // var Heurl = Utils.HEUrl + "233/" + "62001";
      print('Heurl Url: $Heurl');
      response = await apisRepository.getHERequestApi(Heurl);
      print('Heurl response : ${response.toString()}');
      print('Heurl response Code: ${response.status}');
      if (response.status != null && response.status == true) {
        //  errorMessage = response.status as String;
      } else {
        //errorMessage = response.status as String;
      }
      if (response.status != null) {
        yield InitialHEStatusScreenState(
            message: "",
            isLoading: false,
            isSuccess: true,
            heStatus: response.status,
            url: response.heUrl);
      } else {
        yield InitialHEStatusScreenState(
            isLoading: false,
            isSuccess: false,
            message: errorMessage,
            heStatus: response.status,
            url: response.heUrl);
      }
    }
  }

  Stream<SplashBlocState> _mapuserHEinfoRequestEventState(
      HERequestEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    HeInfoResponse response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialHEInfoScreenState(
          isLoading: true, isSuccess: false, message: "");
      var Heurl = Utils.HEInfoUrl;
      response = await apisRepository.getHEInfoRequestApi(Heurl);
      print('Heurl Info response imei: ${response.imei}');
      print('Heurl Info response msisdn: ${response.msisdn}');
      if (response.msisdn != null && response.imei != null) {
        //  errorMessage = response.status as String;
      } else {
        //errorMessage = response.status as String;
      }
      if (response.msisdn != null && response.imei != null) {
        yield InitialHEInfoScreenState(
            message: "",
            isLoading: false,
            isSuccess: true,
            heInfoResponse: response);
      } else {
        yield InitialHEInfoScreenState(
            isLoading: false, isSuccess: false, message: errorMessage);
      }
    }
  }

  Stream<SplashBlocState> _mapuserHEUrlEventState(
      CustomerHEUrlEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    HeUrlResponse response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialHEUrlcreenState(
        isLoading: true,
        isSuccess: false,
        status: 0,
      );
      var Heurl = event.url;
      response = await apisRepository.getHEUrlRequestApi(Heurl);
      print('Heurl response : ${response.toString()}');
      if (response.msisdn != null && response.imei != null) {
        //  errorMessage = response.status as String;
      } else {
        //errorMessage = response.status as String;
      }
      if (response.msisdn != null && response.imei != null) {
        yield InitialHEUrlcreenState(
            isLoading: false,
            isSuccess: true,
            status: response.statusCode,
            heUrlResponseRe: response);
      } else {
        yield InitialHEUrlcreenState(
            isLoading: false,
            isSuccess: false,
            status: response.statusCode,
            heUrlResponseRe: response);
      }
    }
  }

  Stream<SplashBlocState> _mapRegisterUserClickState(
      RegisterUserEvent event) async* {
    PreferenceUtils.init();
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
      PreferenceUtils.setString(
          Utils.JWT_TOKEN, response.user.userTokenDetails.jwtToken);
      PreferenceUtils.setString(Utils.USER_ID, response.user.id.toString());
      PreferenceUtils.setString(Utils.MSISDN, response.user.msisdn);
      PreferenceUtils.setString(Utils.ISLOGIN, "true");

      yield InitialOtpLoginProcessState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage);
    } else {
      yield InitialOtpLoginProcessState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }
}
