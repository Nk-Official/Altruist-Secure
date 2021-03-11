// To parse this JSON data, do
//
//     final customerInfoRequestModel = customerInfoRequestModelFromJson(jsonString);

import 'dart:convert';

CustomerInfoRequestModel customerInfoRequestModelFromJson(String str) =>
    CustomerInfoRequestModel.fromJson(json.decode(str));

String customerInfoRequestModelToJson(CustomerInfoRequestModel data) =>
    json.encode(data.toJson());

class CustomerInfoRequestModel {
  String userId;
  String source;

  CustomerInfoRequestModel({
    this.userId,
    this.source,
  });

  factory CustomerInfoRequestModel.fromJson(Map<String, dynamic> json) =>
      CustomerInfoRequestModel(
        userId: json["userId"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "source": source,
      };
}
