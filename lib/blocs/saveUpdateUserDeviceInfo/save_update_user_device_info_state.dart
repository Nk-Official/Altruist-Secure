import 'package:altruist_secure_flutter/models/responses/AgreeValueResponse/AgreeValueResponse.dart';
import 'package:altruist_secure_flutter/models/responses/ImageApprovalResponse/imageApprovalResponse.dart';
import 'package:altruist_secure_flutter/models/responses/PofileGetResponse/profileGetInfoResponse.dart';
import 'package:altruist_secure_flutter/models/responses/customer_info/CustomerInfoResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/damageresponse/damageresponse.dart';
import 'package:meta/meta.dart';


@immutable
abstract class SaveUpdateUserDeviceInfoState {}

class InitialSaveUpdateUserDeviceInfoState extends SaveUpdateUserDeviceInfoState {
  final String message;
  final bool isLoading;
  final bool isSuccess;

  InitialSaveUpdateUserDeviceInfoState({this.isLoading, this.isSuccess, this.message});
}


class AgreeValueInfoState extends SaveUpdateUserDeviceInfoState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  final AgreeValueResponse agreeValueResponse;

  AgreeValueInfoState({this.isLoading, this.isSuccess, this.message,this.agreeValueResponse});

}
class InitialImageInfotState extends SaveUpdateUserDeviceInfoState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  ImageApprovalResponse imageApprovalResponse;


  InitialImageInfotState(
      {this.isLoading, this.isSuccess, this.message,this.imageApprovalResponse});
}


class InitialuploadDamageScreenState extends SaveUpdateUserDeviceInfoState {
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


class InitialSplashBlocState extends SaveUpdateUserDeviceInfoState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
 final CustomerInfoResponseModel customerInfoResponseModel;
  InitialSplashBlocState(
      {this.message,
        this.isLoading,
        this.isSuccess,
        this.customerInfoResponseModel,
      });
}


