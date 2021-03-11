import 'package:altruist_secure_flutter/models/requests/customer_info/CustomerInfoRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/register/RegisterRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/splash/SplashRequestModel.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SplashBlocEvent {}

class FetchCustomerInfoEvent extends SplashBlocEvent {}

class UpdateSplashInfoEvent extends SplashBlocEvent {
  final String fcmToken;
  final String appVersion;
  UpdateSplashInfoEvent({this.fcmToken, this.appVersion});
}
class CustomerHERequestEvent extends SplashBlocEvent {
  final bool heFlag;
  final String mCountryCode;
  final String mCountryOperatorCode;
  CustomerHERequestEvent({this.heFlag,this.mCountryCode,this.mCountryOperatorCode});
}

class HERequestEvent extends SplashBlocEvent {
  HERequestEvent();
}

class CustomerHEUrlEvent extends SplashBlocEvent {
  final String url;
  CustomerHEUrlEvent({this.url});
}

class RegisterUserEvent extends SplashBlocEvent {
  RegisterRequestModel registerRequestModel;
  String otp;

  RegisterUserEvent({this.registerRequestModel, this.otp});
}

