// To parse this JSON data, do
//
//     final heResponseModel = heResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:altruist_secure_flutter/models/responses/base/StatusDescription.dart';

HeResponseModel heResponseModelFromJson(String str) =>
    HeResponseModel.fromJson(json.decode(str));

String heResponseModelToJson(HeResponseModel data) =>
    json.encode(data.toJson());

class HeResponseModel {
  StatusDescription statusDescription;
  HeInfo heInfo;

  HeResponseModel({
    this.statusDescription,
    this.heInfo,
  });

  factory HeResponseModel.fromJson(Map<String, dynamic> json) =>
      HeResponseModel(
        statusDescription:
            StatusDescription.fromJson(json["statusDescription"]),
        heInfo: HeInfo.fromJson(json["heInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "statusDescription": statusDescription.toJson(),
        "heInfo": heInfo.toJson(),
      };
}

class HeInfo {
  int id;
  String countryId;
  String countryName;
  String operatorCode;
  String url;
  String responseFormat;
  String requestMethod;

  HeInfo({
    this.id,
    this.countryId,
    this.countryName,
    this.operatorCode,
    this.url,
    this.responseFormat,
    this.requestMethod,
  });

  factory HeInfo.fromJson(Map<String, dynamic> json) => HeInfo(
        id: json["id"],
        countryId: json["countryId"],
        countryName: json["countryName"],
        operatorCode: json["operatorCode"],
        url: json["url"],
        responseFormat: json["responseFormat"],
        requestMethod: json["requestMethod"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "countryId": countryId,
        "countryName": countryName,
        "operatorCode": operatorCode,
        "url": url,
        "responseFormat": responseFormat,
        "requestMethod": requestMethod,
      };
}
