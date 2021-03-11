// To parse this JSON data, do
//
//     final fetchClaimRequestModel = fetchClaimRequestModelFromJson(jsonString);

import 'dart:convert';

FetchClaimRequestModel fetchClaimRequestModelFromJson(String str) =>
    FetchClaimRequestModel.fromJson(json.decode(str));

String fetchClaimRequestModelToJson(FetchClaimRequestModel data) =>
    json.encode(data.toJson());

class FetchClaimRequestModel {
  String userId;
  String source;

  FetchClaimRequestModel({
    this.userId,
    this.source,
  });

  factory FetchClaimRequestModel.fromJson(Map<String, dynamic> json) =>
      FetchClaimRequestModel(
        userId: json["userId"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "source": source,
      };
}
