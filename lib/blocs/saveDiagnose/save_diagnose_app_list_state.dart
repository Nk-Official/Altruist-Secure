import 'package:altruist_secure_flutter/models/responses/ImageApprovalResponse/imageApprovalResponse.dart';
import 'package:altruist_secure_flutter/models/responses/PofileGetResponse/profileGetInfoResponse.dart';
import 'package:altruist_secure_flutter/models/responses/diagnostic_list/DiagnosticListResponseModel.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SaveDiagnoseAppListState {}

class InitialSaveDiagnoseAppListState extends SaveDiagnoseAppListState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  final List<Diagnostic> diagnostics;

  InitialSaveDiagnoseAppListState(
      {this.isLoading, this.isSuccess, this.message, this.diagnostics});
}


class InitialGetInfotState extends SaveDiagnoseAppListState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  User user;


  InitialGetInfotState(
      {this.isLoading, this.isSuccess, this.message,this.user});
}


class InitialImageInfotState extends SaveDiagnoseAppListState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  ImageApprovalResponse imageApprovalResponse;


  InitialImageInfotState(
      {this.isLoading, this.isSuccess, this.message,this.imageApprovalResponse});
}



//class InitialFetchDiagnoseAppListState extends SaveDiagnoseAppListState {
//  final String message;
//  final bool isLoading;
//  final bool isSuccess;
//  final List<Diagnostic> diagnostics;
//
//  InitialFetchDiagnoseAppListState(
//      {this.isLoading, this.isSuccess, this.message, this.diagnostics});
//}
