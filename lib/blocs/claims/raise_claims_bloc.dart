import 'dart:async';
import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:altruist_secure_flutter/apis/apis_repository.dart';
import 'package:altruist_secure_flutter/models/requests/claims/FetchClaimRequestModel.dart';
import 'package:altruist_secure_flutter/models/responses/claims/FetchClaimResponseModel.dart';
import 'package:altruist_secure_flutter/models/responses/claims/RaiseClaimResponseModel.dart';
import 'package:altruist_secure_flutter/utils/StringConstants.dart';
import 'package:altruist_secure_flutter/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class RaiseClaimsBloc extends Bloc<RaiseClaimsEvent, RaiseClaimsState> {
  final ApisRepository apisRepository;

  RaiseClaimsBloc({this.apisRepository});

  @override
  RaiseClaimsState get initialState => InitialRaiseClaimsState();

  @override
  Stream<RaiseClaimsState> mapEventToState(
    RaiseClaimsEvent event,
  ) async* {
    if (event is FetchClaimsListEvent) {
      yield* _mapFetchClaimsListEventState(event);
    } else if (event is InitialRaiseClaimsEvent) {
      yield* _mapRaiseClaimsEventState(event);
    }
  }

  Stream<RaiseClaimsState> _mapFetchClaimsListEventState(
      FetchClaimsListEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    FetchClaimResponseModel response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialRaiseClaimsState(
          isLoading: true, isSuccess: false, message: "");
      response = await apisRepository.fetchClaimList(
          FetchClaimRequestModel(
              source: StringConstants.SOURCE,
              userId: PreferenceUtils.getString(Utils.USER_ID)),
          PreferenceUtils.getString(Utils.JWT_TOKEN));
      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
      } else {
        errorMessage = response.statusDescription.errorMessage;
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      yield InitialRaiseClaimsState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage,
          claimsList: response.claimTypes);
    } else {
      yield InitialRaiseClaimsState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }

  Stream<RaiseClaimsState> _mapRaiseClaimsEventState(
      InitialRaiseClaimsEvent event) async* {
    bool isNetworkAvailable = await AppUtils.isInternetAvailable();
    String errorMessage = "";
    RaiseClaimResponseModel response;
    if (!isNetworkAvailable) {
      errorMessage = StringConstants.INTERNET_ERROR;
    } else {
      yield InitialRaiseClaimsState(
          isLoading: true, isSuccess: false, message: "");
      var filename = "raiseClaimDoc.jpg";
      response = await apisRepository.raiseClaim(
          filename,
          event.docFile,
          PreferenceUtils.getString(Utils.USER_ID),
          StringConstants.SOURCE,
          PreferenceUtils.getString(Utils.JWT_TOKEN),
          event.claimTypeId,
          event.customerRemarks,
          event.postalCode);

      if (response != null && response.statusDescription.errorCode == 200) {
        errorMessage = response.statusDescription.errorMessage;
      } else {
        errorMessage = response.statusDescription.errorMessage;
      }
    }
    if (response != null && response.statusDescription.errorCode == 200) {
      yield InitialRaiseClaimsState(
          isLoading: false,
          isSuccess: true,
          message: response.statusDescription.errorMessage);
    } else {
      yield InitialRaiseClaimsState(
          isLoading: false, isSuccess: false, message: errorMessage);
    }
  }
}
