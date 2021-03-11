// To parse this JSON data, do
//
//     final verifySubscriptionOtpResponseModel = verifySubscriptionOtpResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:altruist_secure_flutter/models/responses/base/StatusDescription.dart';

VerifySubscriptionOtpResponseModel verifySubscriptionOtpResponseModelFromJson(
        String str) =>
    VerifySubscriptionOtpResponseModel.fromJson(json.decode(str));

String verifySubscriptionOtpResponseModelToJson(
        VerifySubscriptionOtpResponseModel data) =>
    json.encode(data.toJson());

class VerifySubscriptionOtpResponseModel {
  StatusDescription statusDescription;

  VerifySubscriptionOtpResponseModel({
    this.statusDescription,
  });

  factory VerifySubscriptionOtpResponseModel.fromJson(
          Map<String, dynamic> json) =>
      VerifySubscriptionOtpResponseModel(
        statusDescription:
            StatusDescription.fromJson(json["statusDescription"]),
      );

  Map<String, dynamic> toJson() => {
        "statusDescription": statusDescription.toJson(),
      };
}
