import 'dart:io';

import 'package:flutter/material.dart';

@immutable
abstract class RaiseClaimsEvent {}

class FetchClaimsListEvent extends RaiseClaimsEvent {}

class InitialRaiseClaimsEvent extends RaiseClaimsEvent {
  final File docFile;
  final String claimTypeId;
  final String customerRemarks;
  final String postalCode;

  InitialRaiseClaimsEvent(
      {this.docFile, this.claimTypeId, this.customerRemarks, this.postalCode});
}
