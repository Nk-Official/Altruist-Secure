// To parse this JSON data, do
//
//     final fetchClaimResponseModel = fetchClaimResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:altruist_secure_flutter/models/responses/base/StatusDescription.dart';

FetchClaimResponseModel fetchClaimResponseModelFromJson(String str) =>
    FetchClaimResponseModel.fromJson(json.decode(str));

String fetchClaimResponseModelToJson(FetchClaimResponseModel data) =>
    json.encode(data.toJson());

class FetchClaimResponseModel {
  StatusDescription statusDescription;
  List<ClaimType> claimTypes;

  FetchClaimResponseModel({
    this.statusDescription,
    this.claimTypes,
  });

  factory FetchClaimResponseModel.fromJson(Map<String, dynamic> json) =>
      FetchClaimResponseModel(
        statusDescription:
            StatusDescription.fromJson(json["statusDescription"]),
        claimTypes: List<ClaimType>.from(
            json["claimTypes"].map((x) => ClaimType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "statusDescription": statusDescription.toJson(),
        "claimTypes": List<dynamic>.from(claimTypes.map((x) => x.toJson())),
      };
}

class ClaimType {
  int id;
  int vendorId;
  String claimType;
  String maxAvailLimit;
  String status;

  ClaimType({
    this.id,
    this.vendorId,
    this.claimType,
    this.maxAvailLimit,
    this.status,
  });

  factory ClaimType.fromJson(Map<String, dynamic> json) => ClaimType(
        id: json["id"],
        vendorId: json["vendorId"],
        claimType: json["claimType"],
        maxAvailLimit: json["maxAvailLimit"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vendorId": vendorId,
        "claimType": claimType,
        "maxAvailLimit": maxAvailLimit,
        "status": status,
      };
}
