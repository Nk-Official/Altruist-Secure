import 'dart:io';
import 'package:altruist_secure_flutter/models/requests/register/RegisterRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/saveUpdateUserDeviceInfo/SaveUserDeviceInfoRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/send_otp/SendOtpRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/verify_otp/VerifyOtpRequestModel.dart';
import 'package:meta/meta.dart';

@immutable
abstract class OtpLoginProcessEvent {}

class InitiateFirebaseOtpEvent extends OtpLoginProcessEvent {
  String number;

  InitiateFirebaseOtpEvent({this.number});
}

class RegisterUserEvent extends OtpLoginProcessEvent {
  RegisterRequestModel registerRequestModel;
  String otp;

  RegisterUserEvent({this.registerRequestModel, this.otp});
}




class UploadIDProofsEvent extends OtpLoginProcessEvent {
  final String userId;
  final String source;
  final File idProof;
  final File idProofBack;

  UploadIDProofsEvent(
      {this.userId, this.source, this.idProof, this.idProofBack});
}

class SendOtpEvent extends OtpLoginProcessEvent {
  SendOtpRequestModel sendOtpRequestModel;

  SendOtpEvent({this.sendOtpRequestModel});
}

class VerifyOtpEvent extends OtpLoginProcessEvent {
  VerifyOtpRequestModel verifyOtpRequestModel;
  String otp;
  VerifyOtpEvent({this.verifyOtpRequestModel, this.otp});
}

class FetchCustomerInfoEvent extends OtpLoginProcessEvent {}

class FetchCurrencyInfoEvent extends OtpLoginProcessEvent {}

class FetchCountryEvent extends OtpLoginProcessEvent {}

class EmailEvent extends OtpLoginProcessEvent {}

class UploadInvoiceEvent extends OtpLoginProcessEvent {
  final String userId;
  final String source;
  final File invoiceFile;

  UploadInvoiceEvent({this.userId, this.source, this.invoiceFile});
}
class DamageStatusEvent extends OtpLoginProcessEvent {
}

class UploadDamageScreenEvent extends OtpLoginProcessEvent {
  final String userId;
  final String source;
  final File damagedScreen;

  UploadDamageScreenEvent({this.userId, this.source, this.damagedScreen});
}

class SaveUpdateUserDeviceInfoClickEvent extends OtpLoginProcessEvent {

  SaveUserDeviceInfoRequestModel saveUserDeviceInfoRequestModel;
  SaveUpdateUserDeviceInfoClickEvent({this.saveUserDeviceInfoRequestModel});

}

class FetchStoreEvent extends OtpLoginProcessEvent {}