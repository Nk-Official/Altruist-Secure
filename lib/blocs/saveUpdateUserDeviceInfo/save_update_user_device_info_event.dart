import 'dart:io';

import 'package:altruist_secure_flutter/models/requests/AgreeValueRequest/AgreeValueRequest.dart';
import 'package:altruist_secure_flutter/models/requests/saveUpdateUserDeviceInfo/SaveUserDeviceInfoRequestModel.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SaveUpdateUserDeviceInfoEvent {}

class FetchCustomerInfoEvent extends SaveUpdateUserDeviceInfoEvent {}

class SaveUpdateUserDeviceInfoClickEvent extends SaveUpdateUserDeviceInfoEvent {

  SaveUserDeviceInfoRequestModel saveUserDeviceInfoRequestModel;
  SaveUpdateUserDeviceInfoClickEvent({this.saveUserDeviceInfoRequestModel});

}
class AgreeValueEvent extends SaveUpdateUserDeviceInfoEvent {
  AgreeRequest agreeRequest;
  AgreeValueEvent({this.agreeRequest});

}
class ImageInfoEvent extends SaveUpdateUserDeviceInfoEvent {
  final String url;
  ImageInfoEvent({this.url});
}

class UploadDamageScreenEvent extends SaveUpdateUserDeviceInfoEvent {
  final String userId;
  final String source;
  final File damagedScreen;

  UploadDamageScreenEvent({this.userId, this.source, this.damagedScreen});
}