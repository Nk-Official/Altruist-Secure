// To parse this JSON data, do
//
//     final subscriptionOtpResponseModel = subscriptionOtpResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:altruist_secure_flutter/models/responses/base/StatusDescription.dart';

SubscriptionOtpResponseModel subscriptionOtpResponseModelFromJson(String str) =>
    SubscriptionOtpResponseModel.fromJson(json.decode(str));

String subscriptionOtpResponseModelToJson(SubscriptionOtpResponseModel data) =>
    json.encode(data.toJson());

class SubscriptionOtpResponseModel {
  StatusDescription statusDescription;
  String transactionId;

  SubscriptionOtpResponseModel({
    this.statusDescription,
    this.transactionId,
  });

  factory SubscriptionOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionOtpResponseModel(
        statusDescription:
            StatusDescription.fromJson(json["statusDescription"]),
        transactionId: json["transactionId"],
      );

  Map<String, dynamic> toJson() => {
        "statusDescription": statusDescription.toJson(),
        "transactionId": transactionId,
      };
}
