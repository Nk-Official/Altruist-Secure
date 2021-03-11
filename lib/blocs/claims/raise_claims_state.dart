import 'package:altruist_secure_flutter/models/responses/claims/FetchClaimResponseModel.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RaiseClaimsState {}

class InitialRaiseClaimsState extends RaiseClaimsState {
  final String message;
  final bool isLoading;
  final bool isSuccess;
  final List<ClaimType> claimsList;

  InitialRaiseClaimsState(
      {this.message, this.isLoading, this.isSuccess, this.claimsList});
}
