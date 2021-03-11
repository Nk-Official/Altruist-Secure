// To parse this JSON data, do
//
//     final raiseClaimResponseModel = raiseClaimResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:altruist_secure_flutter/models/responses/base/StatusDescription.dart';

RaiseClaimResponseModel raiseClaimResponseModelFromJson(String str) =>
    RaiseClaimResponseModel.fromJson(json.decode(str));

String raiseClaimResponseModelToJson(RaiseClaimResponseModel data) =>
    json.encode(data.toJson());

class RaiseClaimResponseModel {
  StatusDescription statusDescription;
  int claimRequestId;

  RaiseClaimResponseModel({
    this.statusDescription,
    this.claimRequestId,
  });

  factory RaiseClaimResponseModel.fromJson(Map<String, dynamic> json) =>
      RaiseClaimResponseModel(
        statusDescription:
            StatusDescription.fromJson(json["statusDescription"]),
        claimRequestId: json["claimRequestId"],
      );

  Map<String, dynamic> toJson() => {
        "statusDescription": statusDescription.toJson(),
        "claimRequestId": claimRequestId,
      };
}
