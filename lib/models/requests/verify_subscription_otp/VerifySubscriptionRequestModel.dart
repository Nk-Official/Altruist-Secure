// To parse this JSON data, do
//
//     final verifySubscriptionRequestModel = verifySubscriptionRequestModelFromJson(jsonString);

import 'dart:convert';

VerifySubscriptionRequestModel verifySubscriptionRequestModelFromJson(
        String str) =>
    VerifySubscriptionRequestModel.fromJson(json.decode(str));

String verifySubscriptionRequestModelToJson(
        VerifySubscriptionRequestModel data) =>
    json.encode(data.toJson());

class VerifySubscriptionRequestModel {
  int userId;
  String source;
  int productId;
  String otp;
  String transactionId;

  VerifySubscriptionRequestModel({
    this.userId,
    this.source,
    this.productId,
    this.otp,
    this.transactionId,
  });

  factory VerifySubscriptionRequestModel.fromJson(Map<String, dynamic> json) =>
      VerifySubscriptionRequestModel(
        userId: json["userId"],
        source: json["source"],
        productId: json["productId"],
        otp: json["otp"],
        transactionId: json["transactionId"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "source": source,
        "productId": productId,
        "otp": otp,
        "transactionId": transactionId,
      };
}
