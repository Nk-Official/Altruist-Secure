import 'package:altruist_secure_flutter/models/responses/cuntryinfo/CuntryResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/currencyInfo/CurrencyInfoResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/customer_info/CustomerInfoResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/damageresponse/damageresponse.dart';
import 'package:altruist_secure_flutter/models/responses/invoiceUpload/InvoiceResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/storeResponse/StoreResponseModel.dart';
import 'package:meta/meta.dart';

@immutable
abstract class OtpLoginProcessState {}

class InitialOtpLoginProcessState extends OtpLoginProcessState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  final String transactionId;

  InitialOtpLoginProcessState(
      {this.isLoading, this.isSuccess, this.message, this.transactionId});
}

class InitialFirebaseOtpState extends OtpLoginProcessState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  final int timerCount;

  InitialFirebaseOtpState(
      {this.isLoading, this.isSuccess, this.message, this.timerCount});
}

class InitialUserLoginlocState extends OtpLoginProcessState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  final List<Subscription> subscriptions;
  final List<DeviceDiagnosResult> deviceDiagnosResults;
  final DeviceDetails deviceDetails;

  InitialUserLoginlocState(
      {this.message,
      this.isLoading,
      this.isSuccess,
      this.subscriptions,
      this.deviceDiagnosResults,
      this.deviceDetails});
}

class IntialCurrencyInfoState extends OtpLoginProcessState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  final OperatorConfig operatorConfig;
  final int errorCode;

  IntialCurrencyInfoState(
      {this.isLoading, this.isSuccess, this.message, this.operatorConfig,this.errorCode});
}

class IntialCuntryInfoState extends OtpLoginProcessState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  final List<CountryList> countryList;

  IntialCuntryInfoState(
      {this.isLoading, this.isSuccess, this.message, this.countryList});
}

class EailInfoState extends OtpLoginProcessState {
  final String message;
  final bool isLoading;
  final bool isSuccess;

  EailInfoState({this.isLoading, this.isSuccess, this.message});
}

class InitialInvoiceUploadeState extends OtpLoginProcessState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  final DeviceDetail deviceDetails;

  InitialInvoiceUploadeState(
      {this.message, this.isLoading, this.isSuccess, this.deviceDetails});
}


class InitialDamageStatusScreenState extends OtpLoginProcessState {
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
class InitialuploadDamageScreenState extends OtpLoginProcessState {
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

class InitialSaveUpdateUserDeviceInfoState extends OtpLoginProcessState {
  final String message;
  final bool isLoading;
  final bool isSuccess;

  InitialSaveUpdateUserDeviceInfoState({this.isLoading, this.isSuccess, this.message});
}

class IntialStoreInfoState extends OtpLoginProcessState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  final List<StoreList> storeList;

  IntialStoreInfoState(
      {this.isLoading, this.isSuccess, this.message, this.storeList});
}




