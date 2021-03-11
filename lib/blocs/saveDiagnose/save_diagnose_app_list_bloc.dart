import 'dart:async';
import 'package:altruist_secure_flutter/apis/apis.dart';
import 'package:altruist_secure_flutter/models/responses/ImageApprovalResponse/imageApprovalResponse.dart';
import 'package:altruist_secure_flutter/models/responses/diagnostic_list/DiagnosticListResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/save_diagnostics/SaveDiagnoseResponseModel.dart';
import 'package:altruist_secure_flutter/utils/StringConstants.dart';
import 'package:altruist_secure_flutter/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';

class SaveDiagnoseAppListBloc
    extends Bloc<SaveDiagnoseAppListEvent, SaveDiagnoseAppListState> {
  final ApisRepository apisRepository;

  SaveDiagnoseAppListBloc({this.apisRepository});

  @override
  SaveDiagnoseAppListState get initialState =>
      InitialSaveDiagnoseAppListState();

  @override
  Stream<SaveDiagnoseAppListState> mapEventToState(
    SaveDiagnoseAppListEvent event,
  ) async* {
    if (event is SaveDiagnosedApplistClickEvent) {
      yield* _mapSaveDiagnosedApplistClickState(event);
    } else if (event is FetchDiagnosApplIstEvent) {
      yield* _mapFetchDiagnoseAppListState(event);
    } else if (event is ImageInfoEvent) {
      print("event is ==== ");
      yield* _mapFetchuserImageStatus(event);
    }
  }

  Stream<SaveDiagnoseAppListState> _mapSaveDiagnosedApplistClickState(
      SaveDiagnosedApplistClickEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    SaveDiagnoseResponseModel response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialSaveDiagnoseAppListState(
          isLoading: true, isSuccess: false, message: "");
      response = await apisRepository.saveDiagnoseAppList(
          event.saveDiagnoseRequestModel,
          PreferenceUtils.getString(Utils.JWT_TOKEN));
      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
      } else {
        errorMessage = response.statusDescription.errorMessage;
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      yield InitialSaveDiagnoseAppListState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage);
    } else {
      yield InitialSaveDiagnoseAppListState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }

  Stream<SaveDiagnoseAppListState> _mapFetchDiagnoseAppListState(
      FetchDiagnosApplIstEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    DiagnosticListResponseModel response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialSaveDiagnoseAppListState(
          isLoading: true, isSuccess: false, message: "");
      response = await apisRepository.diagnosticAppList(
          event.diagnosticListRequestModel,
          PreferenceUtils.getString(Utils.JWT_TOKEN));
      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
      } else {
        errorMessage = response.statusDescription.errorMessage;
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      yield InitialSaveDiagnoseAppListState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
          diagnostics: response.diagnostics);
    } else {
      yield InitialSaveDiagnoseAppListState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }




  Stream<SaveDiagnoseAppListState> _mapFetchuserImageStatus(ImageInfoEvent event) async* {
    print("event Called is ==== ");
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    ImageApprovalResponse response;
    if (!isNetworkAvailable) {
    } else {
      response = await apisRepository.getImageInfoApi(event.url);
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      yield InitialImageInfotState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
          imageApprovalResponse: response);
    } else {
      yield InitialImageInfotState(
          isLoading: false,
          isSuccess: false,
          message: response.statusDescription.errorMessage,
          imageApprovalResponse: response);
    }
  }
}
