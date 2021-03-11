import 'dart:io';
import 'package:altruist_secure_flutter/models/requests/PaymentRequest/PaymentRequest.dart';
import 'package:altruist_secure_flutter/models/requests/callbackrequest/CallbackRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/coupenRequest/CoupenRequest.dart';
import 'package:altruist_secure_flutter/models/requests/customer_info/CustomerInfoRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/helpcenter/HelpCenterRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/profile_update_info/profileupdate_info.dart';
import 'package:altruist_secure_flutter/models/requests/qr_code_request/QRCodeRequest.dart';
import 'package:altruist_secure_flutter/models/requests/qrcode_scan_request/qrcodescan_status.dart';
import 'package:altruist_secure_flutter/models/responses/PofileGetResponse/profileGetInfoResponse.dart';
import 'package:meta/meta.dart';
import 'package:altruist_secure_flutter/models/requests/profileget_info_request/profileget_info.dart';

@immutable
abstract class CustomeInfoEvent {}

class FetchCustomeInfoEvent extends CustomeInfoEvent {
  final CustomerInfoRequestModel customerInfoRequestModel;

  FetchCustomeInfoEvent({this.customerInfoRequestModel});
}

class CustomerCallbackRequestEvent extends CustomeInfoEvent {
  final CallbackRequestModel callbackRequestModel;

  CustomerCallbackRequestEvent({this.callbackRequestModel});
}

class HelpCenterEvent extends CustomeInfoEvent {
  final HelpCenterRequestModel helpCenterRequestModel;

  HelpCenterEvent({this.helpCenterRequestModel});
}

class UploadInvoiceEvent extends CustomeInfoEvent {
  final String userId;
  final String source;
  final File invoiceFile;

  UploadInvoiceEvent({this.userId, this.source, this.invoiceFile});
}

class UploadIDProofsEvent extends CustomeInfoEvent {
  final String userId;
  final String source;
  final File idProof;
  final File idProofBack;

  UploadIDProofsEvent(
      {this.userId, this.source, this.idProof, this.idProofBack});
}

class UploadBackIDProofsEvent extends CustomeInfoEvent {
  final String userId;
  final String source;
  final File idProofBack;
  UploadBackIDProofsEvent({this.userId, this.source, this.idProofBack});
}

class UploadDamageScreenEvent extends CustomeInfoEvent {
  final String userId;
  final String source;
  final File damagedScreen;

  UploadDamageScreenEvent({this.userId, this.source, this.damagedScreen});
}

class UploadVideoEvent extends CustomeInfoEvent {
  final String userId;
  final String source;
  final File videoFile;

  UploadVideoEvent({this.userId, this.source, this.videoFile});
}

class GetUserDetailsEvent extends CustomeInfoEvent {
  final ProfileGetInfo profileGetInfo;

  GetUserDetailsEvent({this.profileGetInfo});
}

class UpDateEvent extends CustomeInfoEvent {
  final ProfileUpdateRequest mProfileUpdateRequest;
  UpDateEvent({this.mProfileUpdateRequest});
}

class DamageStatusEvent extends CustomeInfoEvent {
}

class QRCodeEvent extends CustomeInfoEvent {
  final QRCodeRequest qrCodeRequest;
  QRCodeEvent({this.qrCodeRequest});
}


class QRCodeStatusEvent extends CustomeInfoEvent {
  final QrCodeScanRequest qrCodeScanRequest;
  QRCodeStatusEvent({this.qrCodeScanRequest});
}

class PaymentStatusEvent extends CustomeInfoEvent {
  final PaymentRequest paymentRequest;
  PaymentStatusEvent({this.paymentRequest});
}

class CoupenRequestStatusEvent extends CustomeInfoEvent {
  final CoupenRequest coupenRequest;
  CoupenRequestStatusEvent({this.coupenRequest});
}


class UnSubscriptionEvent extends CustomeInfoEvent {
  final String url;
  UnSubscriptionEvent({this.url});
}



