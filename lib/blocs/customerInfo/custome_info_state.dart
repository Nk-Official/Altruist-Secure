import 'package:altruist_secure_flutter/models/responses/PofileGetResponse/profileGetInfoResponse.dart';
import 'package:altruist_secure_flutter/models/responses/coupenResponse/CoupenResponse.dart';
import 'package:altruist_secure_flutter/models/responses/customer_info/CustomerInfoResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/damageresponse/damageresponse.dart';
import 'package:altruist_secure_flutter/models/responses/helpcenter/HelpCenterResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/invoiceUpload/InvoiceResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/qr_code_response/QRCodeResponse.dart';
import 'package:altruist_secure_flutter/models/responses/qr_scan_status_response/qr_status_response_status.dart';
import 'package:altruist_secure_flutter/models/responses/unsubScriptionResponse/unSubScriptionResponse.dart';
import 'package:altruist_secure_flutter/models/responses/uploadIDProofs/IDProofsResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/uploadVideo/UploadVideoResponseModel.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CustomeInfoState {}

class InitialCustomeInfoState extends CustomeInfoState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
 // final List<Subscription> subscriptions;
 // final List<DeviceDiagnosResult> deviceDiagnosResults;
//  final DeviceDetails deviceDetails;

//  final User user;
  CustomerInfoResponseModel customerInfoResponseModel;
  InitialCustomeInfoState({
    this.message,
    this.isLoading,
    this.isSuccess,
    this.customerInfoResponseModel,
  //  this.subscriptions,
  //  this.deviceDiagnosResults,
  //  this.deviceDetails,
    //  this.user,
  });
}

class InitialCallbackRequestState extends CustomeInfoState {
  final String message;
  final bool isLoading;
  final bool isSuccess;

  InitialCallbackRequestState({this.message, this.isLoading, this.isSuccess});
}

class InitialHelpCenterState extends CustomeInfoState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  final List<HelpLine> helpLines;

  InitialHelpCenterState(
      {this.message, this.isLoading, this.isSuccess, this.helpLines});
}

class InitialInvoiceUploadeState extends CustomeInfoState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  final DeviceDetail deviceDetails;

  InitialInvoiceUploadeState(
      {this.message, this.isLoading, this.isSuccess, this.deviceDetails});
}

class InitialuploadIDProofState extends CustomeInfoState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  final DeviceDetailsIDProofs deviceDetails;

  InitialuploadIDProofState(
      {this.message, this.isLoading, this.isSuccess, this.deviceDetails});
}

class InitialuploadIDBackProofState extends CustomeInfoState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  final DeviceDetailsIDProofs deviceDetails;

  InitialuploadIDBackProofState(
      {this.message, this.isLoading, this.isSuccess, this.deviceDetails});
}

class InitialuploadDamageScreenState extends CustomeInfoState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  final DamageScreenResponse deviceDetailsUploads;

  InitialuploadDamageScreenState(
      {this.message,
      this.isLoading,
      this.isSuccess,
      this.deviceDetailsUploads});
}

class InitialDamageStatusScreenState extends CustomeInfoState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  final DamageScreenResponse deviceDetailsUploads;
  final String errorCode;

  InitialDamageStatusScreenState(
      {this.message,
      this.isLoading,
      this.isSuccess,
      this.deviceDetailsUploads,
      this.errorCode});
}

class InitialuploadVideoState extends CustomeInfoState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  final DeviceDetailsUploadVideo deviceDetails;

  InitialuploadVideoState(
      {this.message, this.isLoading, this.isSuccess, this.deviceDetails});
}

class InitialuserGetInfoState extends CustomeInfoState {
  final String message;
  final bool isLoading;
  final bool isSuccess;

  // User user;
  ProfileGetInfoResponse profileGetInfoResponse;

  InitialuserGetInfoState(
//      {this.message, this.isLoading, this.isSuccess, this.user});
      {this.message,
      this.isLoading,
      this.isSuccess,
      this.profileGetInfoResponse});
}

class InitialuserUpdateInfoState extends CustomeInfoState {
  final String message;
  final bool isLoading;
  final bool isSuccess;

//  User user;
  ProfileGetInfoResponse profileGetInfoResponse;

  InitialuserUpdateInfoState(
      //  {this.message, this.isLoading, this.isSuccess, this.user});
      {this.message,
      this.isLoading,
      this.isSuccess,
      this.profileGetInfoResponse});
}

class OrCodeScreenState extends CustomeInfoState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  final QrCodeResponse qrCodeResponse;

  OrCodeScreenState(
      {this.message, this.isLoading, this.isSuccess, this.qrCodeResponse});
}

class OrCodeSccanStatusState extends CustomeInfoState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  final QrCodeScanStatusResponse qrCodeScanStatusResponse;

  OrCodeSccanStatusState(
      {this.message,
      this.isLoading,
      this.isSuccess,
      this.qrCodeScanStatusResponse});
}

class PaymentStatusState extends CustomeInfoState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  String SubscriptionDate;
  String LastChargeDate;
  String NextChargeDate;
  String PackTypeDate;
  String TotalAmount;
  String PaidAmount;
  String TransactionID;
  String BillPartnerName;
  String PaymentStatus;

  PaymentStatusState({
    this.message,
    this.isLoading,
    this.isSuccess,
    this.SubscriptionDate,
    this.LastChargeDate,
    this.NextChargeDate,
    this.PackTypeDate,
    this.TotalAmount,
    this.PaidAmount,
    this.TransactionID,
    this.BillPartnerName,
    this.PaymentStatus,
  });
}

class CoupenVerifyStatusState extends CustomeInfoState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  CoupenResponse coupenResponse;

  CoupenVerifyStatusState({
    this.message,
    this.isLoading,
    this.isSuccess,
    this.coupenResponse,
  });
}

class UnSubscribeState extends CustomeInfoState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  UnSubscriptionResponse unSubscriptionResponse;

  UnSubscribeState({
    this.message,
    this.isLoading,
    this.isSuccess,
    this.unSubscriptionResponse,
  });
}