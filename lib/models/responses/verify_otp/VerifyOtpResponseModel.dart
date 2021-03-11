// To parse this JSON data, do
//
//     final verifyOtpResponseModel = verifyOtpResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:altruist_secure_flutter/models/responses/base/StatusDescription.dart';
import 'package:altruist_secure_flutter/models/responses/verify_otp/User.dart';

VerifyOtpResponseModel verifyOtpResponseModelFromJson(String str) =>
    VerifyOtpResponseModel.fromJson(json.decode(str));

String verifyOtpResponseModelToJson(VerifyOtpResponseModel data) =>
    json.encode(data.toJson());

class VerifyOtpResponseModel {
  StatusDescription statusDescription;
  User user;

  VerifyOtpResponseModel({
    this.statusDescription,
    this.user,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      VerifyOtpResponseModel(
        statusDescription:
            StatusDescription.fromJson(json["statusDescription"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "statusDescription": statusDescription.toJson(),
        "user": user.toJson(),
      };
}
