import 'package:altruist_secure_flutter/models/requests/diagnostic_list/DiagnosticListRequestModel.dart';
import 'package:altruist_secure_flutter/models/requests/profileget_info_request/profileget_info.dart';
import 'package:altruist_secure_flutter/models/requests/save_diagnostics/SaveDiagnoseRequestModel.dart';
import 'package:altruist_secure_flutter/models/responses/ImageApprovalResponse/imageApprovalResponse.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SaveDiagnoseAppListEvent {}

class FetchDiagnosApplIstEvent extends SaveDiagnoseAppListEvent {
  final DiagnosticListRequestModel diagnosticListRequestModel;
  FetchDiagnosApplIstEvent({this.diagnosticListRequestModel});
}

class SaveDiagnosedApplistClickEvent extends SaveDiagnoseAppListEvent {
  final SaveDiagnoseRequestModel saveDiagnoseRequestModel;
  SaveDiagnosedApplistClickEvent({this.saveDiagnoseRequestModel});
}

class GetUserInfoEvent extends SaveDiagnoseAppListEvent {
  final ProfileGetInfo mgetProfileInfo;
  GetUserInfoEvent({this.mgetProfileInfo});
}
class ImageInfoEvent extends SaveDiagnoseAppListEvent {
  final String url;
  ImageInfoEvent({this.url});
}