import 'dart:async';
import 'package:altruist_secure_flutter/apis/apis.dart';
import 'package:altruist_secure_flutter/models/requests/qr_code_request/QRCodeRequest.dart';
import 'package:altruist_secure_flutter/models/responses/PaymentStatusResponse/PaymentStatusRespose.dart';
import 'package:altruist_secure_flutter/models/responses/PofileGetResponse/profileGetInfoResponse.dart';
import 'package:altruist_secure_flutter/models/responses/callbackrequest/CallbackResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/coupenResponse/CoupenResponse.dart';
import 'package:altruist_secure_flutter/models/responses/customer_info/CustomerInfoResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/helpcenter/HelpCenterResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/invoiceUpload/InvoiceResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/qr_code_response/QRCodeResponse.dart';
import 'package:altruist_secure_flutter/models/responses/qr_scan_status_response/qr_status_response_status.dart';
import 'package:altruist_secure_flutter/models/responses/unsubScriptionResponse/unSubScriptionResponse.dart';
import 'package:altruist_secure_flutter/models/responses/uploadIDProofs/IDProofsResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/uploadVideo/UploadVideoResponseModel.dart';
import 'package:altruist_secure_flutter/utils/StringConstants.dart';
import 'package:altruist_secure_flutter/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/models/responses/damageresponse/damageresponse.dart';

class CustomeInfoBloc extends Bloc<CustomeInfoEvent, CustomeInfoState> {
  final ApisRepository apisRepository;

  CustomeInfoBloc({this.apisRepository});

  @override
  CustomeInfoState get initialState => InitialCustomeInfoState();

  @override
  Stream<CustomeInfoState> mapEventToState(
    CustomeInfoEvent event,
  ) async* {
    if (event is FetchCustomeInfoEvent) {
      yield* _mapCustomInfoEventState(event);
    } else if (event is CustomerCallbackRequestEvent) {
      yield* _mapCallbackRequestState(event);
    } else if (event is HelpCenterEvent) {
      yield* _mapHelpCenterState(event);
    } else if (event is UploadInvoiceEvent) {
      yield* _mapUploadInvoiceEventState(event);
    } else if (event is UploadIDProofsEvent) {
      yield* _mapUploadIDProofsEventState(event);
    } else if (event is UploadBackIDProofsEvent) {
      yield* _mapUploadBackIDProofsEventState(event);
    } else if (event is UploadDamageScreenEvent) {
      yield* _mapUploadDamageEventState(event);
    } else if (event is UploadVideoEvent) {
      yield* _mapUploadVideoEventState(event);
    } else if (event is GetUserDetailsEvent) {
      yield* _mapGetUserInfo(event);
    } else if (event is UpDateEvent) {
      yield* _mapUpdateUserInfo(event);
    } else if (event is DamageStatusEvent) {
      yield* _mapDamageStatusInfo(event);
    } else if (event is QRCodeEvent) {
      yield* _mQrCode(event);
    } else if (event is QRCodeStatusEvent) {
      yield* _mQrCodeScanStatus(event);
    } else if (event is PaymentStatusEvent) {
      yield* _mPaymentStatus(event);
    } else if (event is CoupenRequestStatusEvent) {
      yield* _mCoupenVerifyStatus(event);
    } else if (event is UnSubscriptionEvent) {
      yield* _mEventStateUnSubscribe(event);
    }
  }

  Stream<CustomeInfoState> _mapCustomInfoEventState(
      FetchCustomeInfoEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    CustomerInfoResponseModel response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialCustomeInfoState(
          isLoading: true, isSuccess: false, message: "");
      response = await apisRepository.customerInfo(
          event.customerInfoRequestModel,
          PreferenceUtils.getString(Utils.JWT_TOKEN));
      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
      } else {
        errorMessage = response.statusDescription.errorMessage;
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      yield InitialCustomeInfoState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
          customerInfoResponseModel: response);
    } else {
      yield InitialCustomeInfoState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }

  Stream<CustomeInfoState> _mapCallbackRequestState(
      CustomerCallbackRequestEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    CallbackResponseModel response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialCallbackRequestState(
          isLoading: true, isSuccess: false, message: "");
      response = await apisRepository.customerCallBackRequest(
          event.callbackRequestModel,
          PreferenceUtils.getString(Utils.JWT_TOKEN));
      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
      } else {
        errorMessage = response.statusDescription.errorMessage;
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      yield InitialCallbackRequestState(
        isLoading: false,
        isSuccess: true,
        message: response.statusDescription.errorMessage,
      );
    } else {
      yield InitialCallbackRequestState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }

  Stream<CustomeInfoState> _mapHelpCenterState(HelpCenterEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    HelpCenterResponseModel response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialHelpCenterState(
          isLoading: true, isSuccess: false, message: "");
      response = await apisRepository.helpCenterContactDetails(
          event.helpCenterRequestModel,
          PreferenceUtils.getString(Utils.JWT_TOKEN));
      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
      } else {
        errorMessage = response.statusDescription.errorMessage;
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      yield InitialHelpCenterState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
          helpLines: response.helpLines);
    } else {
      yield InitialHelpCenterState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }

  Stream<CustomeInfoState> _mapUploadInvoiceEventState(
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

  Stream<CustomeInfoState> _mapUploadIDProofsEventState(
      UploadIDProofsEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    IdProofsResponseModel response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialuploadIDProofState(
          isLoading: true, isSuccess: false, message: "");
      var filename = "image.jpg";
      var filenameBack = "imageBack.jpg";
      response = await apisRepository.uploadIdProofs(
          filename,
          filenameBack,
          event.idProof,
          event.idProofBack == null ? null : event.idProofBack,
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
      yield InitialuploadIDProofState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
          deviceDetails: response.deviceDetails);
    } else {
      yield InitialuploadIDProofState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }

  Stream<CustomeInfoState> _mapUploadBackIDProofsEventState(
      UploadBackIDProofsEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    IdProofsResponseModel response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialuploadIDBackProofState(
          isLoading: true, isSuccess: false, message: "");
      var filename = "image.jpg";
      var filenameBack = "imageBack.jpg";
      response = await apisRepository.uploadIdBackProofs(
          filename,
          filenameBack,
          event.idProofBack == null ? null : event.idProofBack,
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
      yield InitialuploadIDBackProofState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
          deviceDetails: response.deviceDetails);
    } else {
      yield InitialuploadIDBackProofState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }

  Stream<CustomeInfoState> _mapUploadDamageEventState(
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

  Stream<CustomeInfoState> _mapUploadVideoEventState(
      UploadVideoEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    UploadVideoResponseModel response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialuploadVideoState(
          isLoading: true, isSuccess: false, message: "");
      var filename = "video.mp4";
      response = await apisRepository.uploadVideoFile(
          filename,
          event.videoFile,
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
      yield InitialuploadVideoState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
          deviceDetails: response.deviceDetails);
    } else {
      yield InitialuploadVideoState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }

  Stream<CustomeInfoState> _mapGetUserInfo(GetUserDetailsEvent event) async* {
    print("Get User info api called");
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    ProfileGetInfoResponse response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialuserGetInfoState(
          isLoading: true, isSuccess: false, message: "");
      response = await apisRepository.getuserInfor(
          event.profileGetInfo, PreferenceUtils.getString(Utils.JWT_TOKEN));
      print("_mapGetUserInfo Response $response");

      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
      } else {
        errorMessage = response.statusDescription.errorMessage;
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      yield InitialuserGetInfoState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
          profileGetInfoResponse: response);
    } else {
      yield InitialuserGetInfoState(
          isLoading: false,
          isSuccess: false,
          message: errorMessage,
          profileGetInfoResponse: response);
    }
  }

  Stream<CustomeInfoState> _mapUpdateUserInfo(UpDateEvent event) async* {
    print("Update User info api called");
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    ProfileGetInfoResponse response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialuserUpdateInfoState(
          isLoading: true, isSuccess: false, message: "");
      response = await apisRepository.mUpdateUserInfor(
          event.mProfileUpdateRequest,
          PreferenceUtils.getString(Utils.JWT_TOKEN));
      print("_mapUpdateUserInfo Response $response");

      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
      } else {
        errorMessage = response.statusDescription.errorMessage;
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      yield InitialuserUpdateInfoState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
          profileGetInfoResponse: response);
    } else {
      yield InitialuserUpdateInfoState(
          isLoading: false,
          isSuccess: false,
          message: errorMessage,
          profileGetInfoResponse: response);
    }
  }

  Stream<CustomeInfoState> _mapDamageStatusInfo(
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

  Stream<CustomeInfoState> _mQrCode(QRCodeEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    QrCodeResponse response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield OrCodeScreenState(isLoading: true, isSuccess: false, message: "");
      // var userId = int.parse(PreferenceUtils.getString(Utils.USER_ID));
      //  userId = 354;
      //  var qrCodeRequest = QRCodeRequest(userId: userId);
      print("QR Code Request ${event.qrCodeRequest}");
      response = await apisRepository.qrCode(event.qrCodeRequest);
      if (response != null && response.errorCode == 200) {
        errorMessage = response.errorMessage;
      } else {
        errorMessage = response.errorMessage;
      }
    }
    if (response != null && response.errorCode == 200) {
      yield OrCodeScreenState(
          isLoading: false,
          isSuccess: true,
          message: response.errorMessage,
          qrCodeResponse: response);
    } else {
      yield OrCodeScreenState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }

  Stream<CustomeInfoState> _mQrCodeScanStatus(QRCodeStatusEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    QrCodeScanStatusResponse response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield OrCodeSccanStatusState(
          isLoading: true, isSuccess: false, message: "");
      // var userId = int.parse(PreferenceUtils.getString(Utils.USER_ID));
      //  userId = 354;
      //  var qrCodeRequest = QRCodeRequest(userId: userId);
      print("QR Code  Scan Request ${event.qrCodeScanRequest}");
      response = await apisRepository.qrCodeScanStatus(event.qrCodeScanRequest);
      if (response != null && response.errorCode == 200) {
        errorMessage = response.errorMessage;
      } else {
        errorMessage = response.errorMessage;
      }
    }

    if (response != null && response.errorCode == 200) {
      yield OrCodeSccanStatusState(
        isLoading: false,
        isSuccess: true,
        message: response.errorMessage,
      );
    } else {
      yield OrCodeSccanStatusState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }

  Stream<CustomeInfoState> _mPaymentStatus(PaymentStatusEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    PaymentResponse response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield PaymentStatusState(isLoading: true, isSuccess: false, message: "");
      // var userId = int.parse(PreferenceUtils.getString(Utils.USER_ID));
      //  userId = 354;
      //  var qrCodeRequest = QRCodeRequest(userId: userId);
      print("Payment  Request ${event.paymentRequest}");
      response = await apisRepository.paymentScanStatus(
          event.paymentRequest, PreferenceUtils.getString(Utils.JWT_TOKEN));
      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
      } else {
        errorMessage = response.statusDescription.errorMessage;
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      yield PaymentStatusState(
        message: response.statusDescription.errorMessage,
        isLoading: false,
        isSuccess: true,
        SubscriptionDate: response.subscription.subscriptionDate.toString(),
        LastChargeDate: response.subscription.lastChargeDate.toString(),
        NextChargeDate: response.subscription.nextChargeDate.toString(),
        PackTypeDate: response.subscription.packType,
        PaidAmount: response.subscription.paidAmount,
        TotalAmount: response.subscription.totalAmount,
        TransactionID: response.purchaseTransaction[0].respPayId,
        BillPartnerName: response.purchaseTransaction[0].billPartnerName,
        PaymentStatus: response.subscription.status,
      );
    } else {
      yield PaymentStatusState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }

  Stream<CustomeInfoState> _mCoupenVerifyStatus(
      CoupenRequestStatusEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    CoupenResponse response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield CoupenVerifyStatusState(
          isLoading: true, isSuccess: false, message: "");
      print("CoupenRequest ${event.coupenRequest}");
      response = await apisRepository.CoupenVerifyApi(
          event.coupenRequest, PreferenceUtils.getString(Utils.JWT_TOKEN));

      print("Coupen Response is ====   ${response.toJson()}");
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      yield CoupenVerifyStatusState(
          message: response.statusDescription.errorMessage,
          isLoading: false,
          isSuccess: true,
          coupenResponse: response);
    } else {
      yield CoupenVerifyStatusState(
          message: response.statusDescription.errorMessage,
          isLoading: false,
          isSuccess: false,
          coupenResponse: response);
    }
  }

  Stream<CustomeInfoState> _mEventStateUnSubscribe(
      UnSubscriptionEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    UnSubscriptionResponse response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      String Url = event.url;
      String token = PreferenceUtils.getString(Utils.JWT_TOKEN);
      print('Url === $Url    ====  token ===  $token');
      yield UnSubscribeState(isLoading: true, isSuccess: false, message: "");
      response = await apisRepository.getUnSubApi(event.url, token);
      print('UnSubscribe Response: ${response.statusDescription.errorCode}');

      if (response != null) {
        yield UnSubscribeState(
            message: "",
            isLoading: false,
            isSuccess: true,
            unSubscriptionResponse: response);
      } else {
        yield UnSubscribeState(
            isLoading: false,
            isSuccess: false,
            message: errorMessage,
            unSubscriptionResponse: response);
      }
    }
  }
}
