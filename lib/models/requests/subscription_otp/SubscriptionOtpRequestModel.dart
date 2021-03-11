// To parse this JSON data, do
//
//     final subscriptionOtpRequestModel = subscriptionOtpRequestModelFromJson(jsonString);

import 'dart:convert';

SubscriptionOtpRequestModel subscriptionOtpRequestModelFromJson(String str) =>
    SubscriptionOtpRequestModel.fromJson(json.decode(str));

String subscriptionOtpRequestModelToJson(SubscriptionOtpRequestModel data) =>
    json.encode(data.toJson());

class SubscriptionOtpRequestModel {
  int userId;
  String source;
  int productId;

  SubscriptionOtpRequestModel({
    this.userId,
    this.source,
    this.productId,
  });

  factory SubscriptionOtpRequestModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionOtpRequestModel(
        userId: json["userId"],
        source: json["source"],
        productId: json["productId"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "source": source,
        "productId": productId,
      };
}
