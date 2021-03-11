import 'dart:io';
import 'dart:math';

import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/apis/apis_client.dart';
import 'package:altruist_secure_flutter/models/requests/AgreeValueRequest/AgreeValueRequest.dart';
import 'package:altruist_secure_flutter/models/requests/PaymentRequest/PaymentRequest.dart';
import 'package:altruist_secure_flutter/models/requests/callbackrequest/CallbackRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/claims/FetchClaimRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/coupenRequest/CoupenRequest.dart';
import 'package:altruist_secure_flutter/models/requests/currencyInfo/CurrencyInfoRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/customer_info/CustomerInfoRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/diagnostic_list/DiagnosticListRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/display_products/DisplayProductsRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/get_HE/HERequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/helpcenter/HelpCenterRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/profile_update_info/profileupdate_info.dart';
import 'package:altruist_secure_flutter/models/requests/profileget_info_request/profileget_info.dart';
import 'package:altruist_secure_flutter/models/requests/qr_code_request/QRCodeRequest.dart';
import 'package:altruist_secure_flutter/models/requests/qrcode_scan_request/qrcodescan_status.dart';
import 'package:altruist_secure_flutter/models/requests/register/RegisterRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/saveUpdateUserDeviceInfo/SaveUserDeviceInfoRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/save_diagnostics/SaveDiagnoseRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/send_otp/SendOtpRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/splash/SplashRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/subscription_otp/SubscriptionOtpRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/verify_otp/VerifyOtpRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/verify_subscription_otp/VerifySubscriptionRequestModel.dart';
import 'package:altruist_secure_flutter/models/responses/AgreeValueResponse/AgreeValueResponse.dart';
import 'package:altruist_secure_flutter/models/responses/HEUrlResponse/HeUrlResponse.dart';
import 'package:altruist_secure_flutter/models/responses/ImageApprovalResponse/imageApprovalResponse.dart';
import 'package:altruist_secure_flutter/models/responses/PaymentStatusResponse/PaymentStatusRespose.dart';
import 'package:altruist_secure_flutter/models/responses/PofileGetResponse/profileGetInfoResponse.dart';
import 'package:altruist_secure_flutter/models/responses/callbackrequest/CallbackResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/claims/FetchClaimResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/claims/RaiseClaimResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/coupenResponse/CoupenResponse.dart';
import 'package:altruist_secure_flutter/models/responses/cuntryinfo/CuntryResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/currencyInfo/CurrencyInfoResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/customer_info/CustomerInfoResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/damageresponse/damageresponse.dart';
import 'package:altruist_secure_flutter/models/responses/diagnostic_list/DiagnosticListResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/display_products/DisplayProductsResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/emialresponse/emailResponse.dart';
import 'package:altruist_secure_flutter/models/responses/get_HE/HEResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/heResponse/HeInfoResponse.dart';
import 'package:altruist_secure_flutter/models/responses/heResponse/HeResponse.dart';
import 'package:altruist_secure_flutter/models/responses/helpcenter/HelpCenterResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/invoiceUpload/InvoiceResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/qr_code_response/QRCodeResponse.dart';
import 'package:altruist_secure_flutter/models/responses/qr_scan_status_response/qr_status_response_status.dart';
import 'package:altruist_secure_flutter/models/responses/register/RegisterResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/saveUpdateUserDeviceInfo/SaveUserDeviceInfoResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/save_diagnostics/SaveDiagnoseResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/send_otp/SendOtpResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/splash/SplashResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/storeResponse/StoreResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/subscription_otp/SubscriptionOtpResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/unsubScriptionResponse/unSubScriptionResponse.dart';
import 'package:altruist_secure_flutter/models/responses/uploadIDProofs/IDProofsResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/uploadVideo/UploadVideoResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/verify_otp/VerifyOtpResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/verify_subscription_otp/VerifySubscriptionOtpResponseModel.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ApisRepository {
  final ApisClient apiClient;

//  String jwtToken = PreferenceUtils.getString(Utils.JWT_TOKEN);

//  String jwtToken =
//      "eyJ0eXBlIjoiSldUIiwia2lkIjoiMTU4NTEzOTMwMTYzMyIsImFsZyI6IlJTNTEyIn0.eyJpc3MiOiJBbHRfU2VjdXJlX1ZhbGlkYXRlX1Rva2VuIiwiZXhwIjoxNjE2Njc1Mjg5LCJqdGkiOiJjNFV4RnFyS2ZoUUpLZE52X19KN3VBIiwiaWF0IjoxNTg1MTM5Mjg5LCJuYmYiOjE1ODUxMzkxNjksInN1YiI6IjkxNzUwODA2MDc2NyJ9.QHXQWHoVkQOliGJVNqtCBY5CligUjyHqSIAzI_rjEib3JvHRWs2OiQu4wv6bNBgeofiV70vzv8PzLFDQH1jRzFBHexiRDqDGxE-GGNqZJnKQACjB_73cTTrRgHB3hZVX-xJlz1ka1yBNODEtBa8UdrIWVTX8QRIFNhPYcwt9mLagLS6FRHZSh_tvdejcDaFpISs-vB_3eD1spzSnUYgVprf6wWvYngCZqgwovqfjJcxpPH8ryK1Bmrvu9GPET0L7im14rGHWtzclUuDw7tds-c8Z3zF5smYmgYlptqm7qZQjYwAOtwZy6f4hehuLM5qpvLjDMYoOGP5rtQAPlrJsWg";

  ApisRepository() : this.apiClient = ApisClient(httpClient: http.Client());

  Future<SendOtpResponseModel> sendOtp(
      SendOtpRequestModel bodyJsonString) async {
    var sendOtp;
    if (PreferenceUtils.getString(Utils.appPackageName) == "com.app.mansardecure_secure") {
      sendOtp = ApisClient.sendOtpV10;
    } else {
      sendOtp = ApisClient.sendOtp;
    }

    final response = await this
        .apiClient
        .postRequest(sendOtp, body: bodyJsonString.toJson());
    if (response.statusCode != 200) {
      throw Exception('error in send otp');
    }
    return sendOtpResponseModelFromJson(response.body);
  }

  Future<VerifyOtpResponseModel> verifyOtp(
      VerifyOtpRequestModel bodyJsonString) async {
    var verifyOtp;
    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      verifyOtp = ApisClient.verifyOtpV10;
    } else {
      verifyOtp = ApisClient.verifyOtp;
    }

    final response = await this
        .apiClient
        .postRequest(verifyOtp, body: bodyJsonString.toJson());
    if (response.statusCode != 200) {
      throw Exception('error in verify otp');
    }
    return verifyOtpResponseModelFromJson(response.body);
  }

  Future<QrCodeResponse> qrCode(QRCodeRequest bodyJsonString) async {
    final response = await this
        .apiClient
        .postRequest(ApisClient.QrCode, body: bodyJsonString.toJson());
    if (response.statusCode != 200) {
      throw Exception('error in qr Code');
    }
    return qrCodeResponseFromJson(response.body);
  }

  Future<QrCodeScanStatusResponse> qrCodeScanStatus(
      QrCodeScanRequest bodyJsonString) async {
    final response = await this
        .apiClient
        .postRequest(ApisClient.qrCodeScanSatus, body: bodyJsonString.toJson());
    if (response.statusCode != 200) {
      throw Exception('error in qr Code');
    }
    return qrCodeScanStatusFromJson(response.body);
  }

//  Future<PaymentResponse> paymentScanStatus(
//      PaymentRequest bodyJsonString) async {
//    final response = await this
//        .apiClient
//        .postRequest(ApisClient.paymentSatus, body: bodyJsonString.toJson());
//    if (response.statusCode != 200) {
//      throw Exception('error in Payment Code');
//    }
//    return paymentResponseFromJson(response.body);
//  }

  Future<PaymentResponse> paymentScanStatus(
      PaymentRequest bodyJsonString, String jwtToken) async {
    final response = await this.apiClient.postRequestWithHeader(
        ApisClient.paymentSatus, jwtToken,
        body: bodyJsonString.toJson());
    print("Payment Response $response");
    if (response.statusCode != 200) {
      throw Exception('error in diagnose App List');
    }
    return paymentResponseFromJson(response.body);
  }

  Future<CoupenResponse> CoupenVerifyApi(
      CoupenRequest bodyJsonString, String jwtToken) async {
    final response = await this.apiClient.postRequestWithHeader(
        ApisClient.CoupenVerify, jwtToken,
        body: bodyJsonString.toJson());
    print("CoupenResponse Response $response");
//    if (response.statusCode != 200) {
//     // throw Exception('error in diagnose App List');
//    }
    return coupenResponseFromJson(response.body);
  }

  Future<RegisterResponseModel> register(
      RegisterRequestModel bodyJsonString) async {


    var register;
    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      register = ApisClient.registerV10;
    } else {
      register = ApisClient.register;
    }

    final response = await this
        .apiClient
        .postRequest(register, body: bodyJsonString.toJson());
    if (response.statusCode != 200) {
      throw Exception('error in register');
    }
    return registerResponseModelFromJson(response.body);
  }

  Future<HeResponseModel> getHE(HeRequestModel bodyJsonString) async {
    final response = await this
        .apiClient
        .postRequest(ApisClient.getHE, body: bodyJsonString.toJson());
    if (response.statusCode != 200) {
      throw Exception('error in get HE');
    }
    return heResponseModelFromJson(response.body);
  }

  Future<DiagnosticListResponseModel> diagnosticAppList(
      DiagnosticListRequestModel bodyJsonString, String jwtToken) async {
    var diagnosticList;
    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      diagnosticList = ApisClient.diagnosticListV10;
    } else {
      diagnosticList = ApisClient.diagnosticList;
    }

    final response = await this.apiClient.postRequestWithHeader(
        diagnosticList, jwtToken,
        body: bodyJsonString.toJson());
    if (response.statusCode != 200) {
      throw Exception('error in diagnose App List');
    }
    return diagnosticListResponseModelFromJson(response.body);
  }

  Future<ProfileGetInfoResponse> getuserInfor(
      ProfileGetInfo bodyJsonString, String jwtToken) async {
    var getuseinfo;
    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      getuseinfo = ApisClient.getuseinfoV10;
    } else {
      getuseinfo = ApisClient.getuseinfo;
    }

    final response = await this.apiClient.postRequestWithHeader(
        getuseinfo, jwtToken,
        body: bodyJsonString.toJson());
    print("UsergetProfile Response $response");
    if (response.statusCode != 200) {
      throw Exception('error in diagnose App List');
    }
    return getinforesponse(response.body);
  }

  Future<ProfileGetInfoResponse> mUpdateUserInfor(
      ProfileUpdateRequest bodyJsonString, String jwtToken) async {
    var userupdateinfo;
    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      userupdateinfo = ApisClient.userupdateinfoV10;
    } else {
      userupdateinfo = ApisClient.userupdateinfo;
    }

    final response = await this.apiClient.postRequestWithHeader(
        userupdateinfo, jwtToken,
        body: bodyJsonString.toJson());
    print("UsergetProfile Response $response");
    if (response.statusCode != 200) {
      throw Exception('error in diagnose App List');
    }
    return getinforesponse(response.body);
  }

  Future<SaveDiagnoseResponseModel> saveDiagnoseAppList(
      SaveDiagnoseRequestModel bodyJsonString, String jwtToken) async {
    var saveDiagnosticList;
    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      saveDiagnosticList = ApisClient.saveDiagnosticListV10;
    } else {
      saveDiagnosticList = ApisClient.saveDiagnosticList;
    }
    final response = await this.apiClient.postRequestWithHeader(
        saveDiagnosticList, jwtToken,
        body: bodyJsonString.toJson());
    if (response.statusCode != 200) {
      throw Exception('error in Save diagnose app list');
    }
    return saveDiagnoseResponseModelFromJson(response.body);
  }

  Future<DisplayProductsResponseModel> displayProducts(
      DisplayProductsRequestModel bodyJsonString) async {
    final response = await this.apiClient.postRequestWithHeader(
        ApisClient.showProducts, "jwtToken",
        body: bodyJsonString.toJson());
    if (response.statusCode != 200) {
      throw Exception('error in display products');
    }
    return displayProductsResponseModelFromJson(response.body);
  }

  Future<CustomerInfoResponseModel> customerInfo(
      CustomerInfoRequestModel bodyJsonString, String jwtToken) async {
    var customeInfo;
    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      customeInfo = ApisClient.customeInfoV10;
    } else {
      customeInfo = ApisClient.customeInfo;
    }
    final response = await this.apiClient.postRequestWithHeader(
        customeInfo, jwtToken,
        body: bodyJsonString.toJson());
    if (response.statusCode != 200) {
      return customerInfoResponseModelFromJson(response.body);
//      throw Exception('error in customer info');
    }
    return customerInfoResponseModelFromJson(response.body);
  }

  Future<SubscriptionOtpResponseModel> subscriptionOtp(
      SubscriptionOtpRequestModel bodyJsonString) async {
    final response = await this.apiClient.postRequestWithHeader(
        ApisClient.subscriptionOtp, "jwtToken",
        body: bodyJsonString.toJson());
    if (response.statusCode != 200) {
      throw Exception('error in subscription otp');
    }
    return subscriptionOtpResponseModelFromJson(response.body);
  }

  Future<VerifySubscriptionOtpResponseModel> verifySubscriptionOtp(
      VerifySubscriptionRequestModel bodyJsonString) async {
    final response = await this.apiClient.postRequestWithHeader(
        ApisClient.verifySubscriptionOtp, "jwtToken",
        body: bodyJsonString.toJson());
    if (response.statusCode != 200) {
      throw Exception('error in verify subscription otp');
    }
    return verifySubscriptionOtpResponseModelFromJson(response.body);
  }

  Future<SaveUserDeviceInfoResponseModel> saveUpdateUserDeviceInfo(
      SaveUserDeviceInfoRequestModel bodyJsonString, String jwtToken) async {
    var saveUpdateUserDeviceInfo;
    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      saveUpdateUserDeviceInfo = ApisClient.saveUpdateUserDeviceInfoV10;
    } else {
      saveUpdateUserDeviceInfo = ApisClient.saveUpdateUserDeviceInfo;
    }

    final response = await this.apiClient.postRequestWithHeader(
        saveUpdateUserDeviceInfo, jwtToken,
        body: bodyJsonString.toJson());
    if (response.statusCode != 200) {
      throw Exception('error in verify subscription otp');
    }
    return saveUserDeviceInfoResponseModelFromJson(response.body);
  }



  Future<AgreeValueResponse> mAgreeCall(
      AgreeRequest bodyJsonString) async {
    final response = await this.apiClient.postRequest(
        ApisClient.agreeValueUrl, body: bodyJsonString.toJson());
    if (response.statusCode != 200) {
      throw Exception('error in verify subscription otp');
    }
    return agreeValueResponseFromJson(response.body);
  }






  Future<HelpCenterResponseModel> helpCenterContactDetails(
      HelpCenterRequestModel bodyJsonString, String jwtToken) async {
    final response = await this.apiClient.postRequestWithHeader(
        ApisClient.helpCenterContactDetails, jwtToken,
        body: bodyJsonString.toJson());
    if (response.statusCode != 200) {
      throw Exception('error in fetching contact details');
    }
    return helpCenterResponseModelFromJson(response.body);
  }

  Future<CallbackResponseModel> customerCallBackRequest(
      CallbackRequestModel bodyJsonString, String jwtToken) async {
    final response = await this.apiClient.postRequestWithHeader(
        ApisClient.customerCallbackRequest, jwtToken,
        body: bodyJsonString.toJson());
    if (response.statusCode != 200) {
      throw Exception('error in customer callback request');
    }
    return callbackResponseModelFromJson(response.body);
  }

  Future<InvoiceResponseModel> uploadInvoiceDoc(String filename, File imageFile,
      String userId, String source, String jwtToken) async {


    var uploadInvoiceDetails;
    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      uploadInvoiceDetails = ApisClient.uploadInvoiceDetailsV10;
    } else {
      uploadInvoiceDetails = ApisClient.uploadInvoiceDetails;
    }
    final response = await this.apiClient.multipartRequestInvoice(
        uploadInvoiceDetails,
        jwtToken,
        imageFile,
        filename,
        userId,
        source);
    if (response.statusCode != 200) {
      throw Exception('error in upload invoice');
    }
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    return invoiceResponseModelFromJson(responseString);
  }

  Future<IdProofsResponseModel> uploadIdProofs(
      String filename,
      String fileNameBack,
      File imageFile,
      File backFile,
      String userId,
      String source,
      String jwtToken) async {
    var uploadIDProofs;
    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      uploadIDProofs = ApisClient.uploadIDProofsV10;
    } else {
      uploadIDProofs = ApisClient.uploadIDProofs;
    }
    final response = await this.apiClient.multipartRequestIDProofs(
        uploadIDProofs,
        jwtToken,
        imageFile,
        backFile == null ? null : backFile,
        filename,
        fileNameBack,
        userId,
        source);
    if (response.statusCode != 200) {
      throw Exception('error in upload id proofs');
    }
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    return idProofsResponseModelFromJson(responseString);
  }

  Future<IdProofsResponseModel> uploadIdBackProofs(
      String filename,
      String fileNameBack,
      File backFile,
      String userId,
      String source,
      String jwtToken) async {

    var uploadBackIDProofs;
    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      uploadBackIDProofs = ApisClient.uploadBackIDProofsV10;
    } else {
      uploadBackIDProofs = ApisClient.uploadBackIDProofs;
    }

    final response = await this.apiClient.multipartRequestBackIDProofs(
        uploadBackIDProofs,
        jwtToken,
        backFile == null ? null : backFile,
        filename,
        fileNameBack,
        userId,
        source);
    if (response.statusCode != 200) {
      throw Exception('error in upload id proofs');
    }
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    return idProofsResponseModelFromJson(responseString);
  }

  Future<DamageScreenResponse> uploadIdDamageScreen(String filename,
      File damagedScreen, String userId, String source, String jwtToken) async {
    var damageScreen;
    if (PreferenceUtils.getString(Utils.appPackageName) ==
        "com.app.mansardecure_secure") {
      damageScreen = ApisClient.damageScreenV10;
    } else {
      damageScreen = ApisClient.damageScreen;
    }
    final response = await this.apiClient.multipartRequestDamage(
        damageScreen,
        jwtToken,
        damagedScreen == null ? null : damagedScreen,
        filename,
        userId,
        source);
    if (response.statusCode != 200) {
      throw Exception('error in upload id proofs');
    }
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    return damageScreesResponse(responseString);
  }

  Future<UploadVideoResponseModel> uploadVideoFile(String filename,
      File videoFile, String userId, String source, String jwtToken) async {
    final response = await this.apiClient.multipartRequestVideoUpload(
        ApisClient.uploadVideoFile,
        jwtToken,
        videoFile,
        filename,
        userId,
        source);
    if (response.statusCode != 200) {
      throw Exception('error in upload video');
    }
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    return uploadVideoResponseModelFromJson(responseString);
  }

  Future<CurrencyInfoResponseModel> getCurrencyInfo(
      CurrencyInfoRequestModel bodyJsonString, String jwtToken) async {
    final response = await this.apiClient.postRequestWithHeader(
        ApisClient.currencyInfo, jwtToken,
        body: bodyJsonString.toJson());
    if (response.statusCode != 200) {
      throw Exception('error in currency info');
    }
    return currencyInfoResponseModelFromJson(response.body);
  }

  Future<CuntryResponseModel> getCuntryInfo(String url) async {
    final response = await this.apiClient.getRequest(url);
    print("response of Country Lsit $response");
    if (response.statusCode != 200) {
      throw Exception('error in cuntry info');
    }
    return getcuntryRes(response.body);
  }



  Future<ImageApprovalResponse> getImageInfoApi(String url) async {
    print("Get Request Url $url");
    final response = await this.apiClient.getRequest(url);
    print("Get Request Url   response $response");
    return imageApprovalResponseFromJson(response.body);
  }


  Future<DamageScreenResponse> getDamageScreenStatus(String url) async {
    final response = await this.apiClient.getRequest(url);
    print("Damage Screen Status =======  $response");
//    if (response.statusCode != 200) {
//      throw Exception('error in cuntry info');
//    }

    if (response.statusCode != 200) {
      throw Exception('error in Damage Screen');
    }

    return damageScreesResponse(response.body);
  }

  Future<EmailResponce> getmailRequestApi(String url) async {
    final response = await this.apiClient.getRequest(url);
    print("response of  Email $response");
    if (response.statusCode != 200) {
      throw Exception('error in cuntry info');
    }
    return emailRespose(response.body);
  }

  Future<HeInfoResponse> getHEInfoRequestApi(String url) async {
    final response = await this.apiClient.getRequest(url);
    print("response of  getHEInfoRequestApi  ${response.toString()}");
//    if (response.statusCode != 200) {
//      throw Exception('error in cuntry info');
//    }
    return heInfoResponseFromJson(response.body);
  }

  Future<UnSubscriptionResponse> getUnSubApi(String url, String jwtToken) async {
    final response = await this.apiClient.getRequestForUnsbscribe(url,jwtToken);
    print("response of unsubApi  ${response.toString()}");
//    if (response.statusCode != 200) {
//      throw Exception('error in cuntry info');
//    }
    return unSubscriptionResponseFromJson(response.body);
  }

  Future<HeResponse> getHERequestApi(String url) async {
    final response = await this.apiClient.getRequest(url);
    print("response of  getHERequestApi  ${response.toString()}");
//    if (response.statusCode != 200) {
//      throw Exception('error in cuntry info');
//    }
    return heResponseFromJson(response.body);
  }

  Future<HeUrlResponse> getHEUrlRequestApi(String url) async {
    final response = await this.apiClient.getRequest(url);
    print("response of  getHEInfoRequestApi  ${response.toString()}");
//    if (response.statusCode != 200) {
//      throw Exception('error in cuntry info');
//    }
    return heUrlResponseFromJson(response.body);
  }

  Future<FetchClaimResponseModel> fetchClaimList(
      FetchClaimRequestModel bodyJsonString, String jwtToken) async {
    final response = await this.apiClient.postRequestWithHeader(
        ApisClient.fetchClaimList, jwtToken,
        body: bodyJsonString.toJson());
    if (response.statusCode != 200) {
      throw Exception('error in currency info');
    }
    return fetchClaimResponseModelFromJson(response.body);
  }

  Future<RaiseClaimResponseModel> raiseClaim(
      String filename,
      File docFile,
      String userId,
      String source,
      String jwtToken,
      String claimTypeId,
      String customerRemarks,
      String postalCode) async {
    final response = await this.apiClient.multipartRequestRaiseClaim(
        ApisClient.raiseClaim,
        jwtToken,
        docFile,
        filename,
        userId,
        source,
        claimTypeId,
        customerRemarks,
        postalCode);
    if (response.statusCode != 200) {
      throw Exception('error in raise claim');
    }
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    return raiseClaimResponseModelFromJson(responseString);
  }

  Future<SplashResponseModel> updateSplashInfo(
      SplashRequestModel bodyJsonString, String jwtToken) async {
    final response = await this.apiClient.postRequestWithHeader(
        ApisClient.updateSplash, jwtToken,
        body: bodyJsonString.toJson());
    if (response.statusCode != 200) {
      throw Exception('error in updateSplashInfo');
    }
    return splashResponseModelFromJson(response.body);
  }

  Future<StoreResponseModel> getStoreInfo(String url) async {
    final response = await this.apiClient.getRequest(url);
    print("Store list response : === $response");
    if (response.statusCode != 200) {
      throw Exception('error in store info');
    }
    return storeResponseModelFromJson(response.body);
  }
}
