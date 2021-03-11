import 'package:altruist_secure_flutter/models/responses/HEUrlResponse/HeUrlResponse.dart';
import 'package:altruist_secure_flutter/models/responses/heResponse/HeInfoResponse.dart';
import 'package:meta/meta.dart';
import 'package:altruist_secure_flutter/models/responses/customer_info/CustomerInfoResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/HEUrlResponse/HeUrlResponse.dart';

@immutable
abstract class SplashBlocState {}

class InitialSplashBlocState extends SplashBlocState {
  final String message;
  final bool isLoading ;
  final bool isSuccess;
  final List<Subscription> subscriptions;
  final List<DeviceDiagnosResult> deviceDiagnosResults;
  final DeviceDetails deviceDetails;
  final String versionCode;
  final String SatusCode;
  User user;
  InitialSplashBlocState(
      {this.message,
      this.isLoading,
      this.isSuccess,
      this.subscriptions,
      this.deviceDiagnosResults,
      this.deviceDetails,
      this.versionCode,
      this.SatusCode,
      this.user
      });
}

class InitialHEStatusScreenState extends SplashBlocState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  final bool heStatus;
  final String url;

  InitialHEStatusScreenState(
      {this.message, this.isLoading, this.isSuccess, this.heStatus,this.url});
}

class InitialHEInfoScreenState extends SplashBlocState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  HeInfoResponse heInfoResponse;

  InitialHEInfoScreenState(
      {this.message, this.isLoading, this.isSuccess, this.heInfoResponse});
}

class InitialHEUrlcreenState extends SplashBlocState {
  final int status;
  final bool isLoading;
  final bool isSuccess;
  HeUrlResponse  heUrlResponseRe;

  InitialHEUrlcreenState(
      {this.status, this.isLoading, this.isSuccess, this.heUrlResponseRe});
}
class InitialOtpLoginProcessState extends SplashBlocState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  final String transactionId;

  InitialOtpLoginProcessState(
      {this.isLoading, this.isSuccess, this.message, this.transactionId});
}