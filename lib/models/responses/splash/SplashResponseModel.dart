// To parse this JSON data, do
//
//     final splashResponseModel = splashResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:altruist_secure_flutter/models/responses/base/StatusDescription.dart';

SplashResponseModel splashResponseModelFromJson(String str) =>
    SplashResponseModel.fromJson(json.decode(str));

String splashResponseModelToJson(SplashResponseModel data) =>
    json.encode(data.toJson());

class SplashResponseModel {
  StatusDescription statusDescription;
  String versionCode;

  SplashResponseModel({
    this.statusDescription,
    this.versionCode,
  });

  factory SplashResponseModel.fromJson(Map<String, dynamic> json) =>
      SplashResponseModel(
        statusDescription:
            StatusDescription.fromJson(json["statusDescription"]),
        versionCode: json["versionCode"],
      );

  Map<String, dynamic> toJson() => {
        "statusDescription": statusDescription.toJson(),
        "versionCode": versionCode,
      };
}
