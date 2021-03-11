import 'dart:async';
import 'package:altruist_secure_flutter/apis/apis.dart';
import 'package:altruist_secure_flutter/models/requests/customer_info/CustomerInfoRequestModel.dart';
import 'package:altruist_secure_flutter/models/responses/AgreeValueResponse/AgreeValueResponse.dart';
import 'package:altruist_secure_flutter/models/responses/ImageApprovalResponse/imageApprovalResponse.dart';
import 'package:altruist_secure_flutter/models/responses/customer_info/CustomerInfoResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/damageresponse/damageresponse.dart';
import 'package:altruist_secure_flutter/models/responses/saveUpdateUserDeviceInfo/SaveUserDeviceInfoResponseModel.dart';
import 'package:altruist_secure_flutter/utils/StringConstants.dart';
import 'package:altruist_secure_flutter/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';

class SaveUpdateUserDeviceInfoBloc
    extends Bloc<SaveUpdateUserDeviceInfoEvent, SaveUpdateUserDeviceInfoState> {
  final ApisRepository apisRepository;

  SaveUpdateUserDeviceInfoBloc({this.apisRepository});

  @override
  SaveUpdateUserDeviceInfoState get initialState =>
      InitialSaveUpdateUserDeviceInfoState();

  @override
  Stream<SaveUpdateUserDeviceInfoState> mapEventToState(
    SaveUpdateUserDeviceInfoEvent event,
  ) async* {
    if (event is SaveUpdateUserDeviceInfoClickEvent) {
      yield* _mapSaveUpdateUserDeviceInfoState(event);
    }else if (event is AgreeValueEvent) {
      yield* _mapAgreeValueInfoState(event);
    }else if(event is ImageInfoEvent){
      yield* _mapFetchuserImageStatus(event);
    }else if(event is UploadDamageScreenEvent){
      yield* _mapUploadDamageEventState(event);
    }else if(event is FetchCustomerInfoEvent){
      yield* _mapCustomInfoEventState(event);
    }
  }

  Stream<SaveUpdateUserDeviceInfoState> _mapSaveUpdateUserDeviceInfoState(
      SaveUpdateUserDeviceInfoClickEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    SaveUserDeviceInfoResponseModel response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialSaveUpdateUserDeviceInfoState(
          isLoading: true, isSuccess: false, message: "");
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



  Stream<SaveUpdateUserDeviceInfoState> _mapFetchuserImageStatus(ImageInfoEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    ImageApprovalResponse response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialImageInfotState(isLoading: true, isSuccess: false, message: "");
      response = await apisRepository.getImageInfoApi(event.url);


      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
      } else {
        errorMessage = response.statusDescription.errorMessage;
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      yield   InitialImageInfotState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
      imageApprovalResponse: response);
    } else {
      yield InitialImageInfotState(
          isLoading: false, isSuccess: false, message: errorMessage,imageApprovalResponse: response);
    }
  }



  Stream<SaveUpdateUserDeviceInfoState> _mapAgreeValueInfoState(
      AgreeValueEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    AgreeValueResponse response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield AgreeValueInfoState(isLoading: true, isSuccess: false, message: "");
      response = await apisRepository.mAgreeCall(event.agreeRequest);
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      yield AgreeValueInfoState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,agreeValueResponse: response);
    } else {
      yield AgreeValueInfoState(
          isLoading: false, isSuccess: false, message: errorMessage,agreeValueResponse: response);
    }
  }

  Stream<SaveUpdateUserDeviceInfoState> _mapUploadDamageEventState(
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



  Stream<SaveUpdateUserDeviceInfoState> _mapCustomInfoEventState(
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
          customerInfoResponseModel: response);
    } else if (response != null &&
        response.statusDescription.errorCode == 401) {
      yield InitialSplashBlocState(
        isLoading: false,
        isSuccess: true,
          message: response.statusDescription.errorMessage,
          customerInfoResponseModel: response
      );
    } else {
      yield InitialSplashBlocState(
          isLoading: false, isSuccess: true, message: response.statusDescription.errorMessage,
          customerInfoResponseModel: response);
    }
  }

}
