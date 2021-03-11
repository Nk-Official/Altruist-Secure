// To parse this JSON data, do
//
//     final splashRequestModel = splashRequestModelFromJson(jsonString);

import 'dart:convert';

SplashRequestModel splashRequestModelFromJson(String str) =>
    SplashRequestModel.fromJson(json.decode(str));

String splashRequestModelToJson(SplashRequestModel data) =>
    json.encode(data.toJson());

class SplashRequestModel {
  String userId;
  String source;
  String versionCode;
  String fcmToken;

  SplashRequestModel({
    this.userId,
    this.source,
    this.versionCode,
    this.fcmToken,
  });

  factory SplashRequestModel.fromJson(Map<String, dynamic> json) =>
      SplashRequestModel(
        userId: json["userId"],
        source: json["source"],
        versionCode: json["versionCode"],
        fcmToken: json["fcmToken"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "source": source,
        "versionCode": versionCode,
        "fcmToken": fcmToken,
      };
}
