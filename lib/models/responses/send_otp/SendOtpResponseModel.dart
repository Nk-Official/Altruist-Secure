// To parse this JSON data, do
//
//     final sendOtpResponseModel = sendOtpResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:altruist_secure_flutter/models/responses/base/StatusDescription.dart';

SendOtpResponseModel sendOtpResponseModelFromJson(String str) =>
    SendOtpResponseModel.fromJson(json.decode(str));

String sendOtpResponseModelToJson(SendOtpResponseModel data) =>
    json.encode(data.toJson());

class SendOtpResponseModel {
  StatusDescription statusDescription;
  String transactionId;

  SendOtpResponseModel({
    this.statusDescription,
    this.transactionId,
  });

  factory SendOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      SendOtpResponseModel(
        statusDescription:
            StatusDescription.fromJson(json["statusDescription"]),
        transactionId: json["transactionId"],
      );

  Map<String, dynamic> toJson() => {
        "statusDescription": statusDescription.toJson(),
        "transactionId": transactionId,
      };
}
