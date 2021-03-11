// To parse this JSON data, do
//
//     final heRequestModel = heRequestModelFromJson(jsonString);

import 'dart:convert';

HeRequestModel heRequestModelFromJson(String str) =>
    HeRequestModel.fromJson(json.decode(str));

String heRequestModelToJson(HeRequestModel data) => json.encode(data.toJson());

class HeRequestModel {
  String countryId;
  String operatorCode;
  String requestId;
  String source;
  String hashToken;
  bool isDebug;

  HeRequestModel({
    this.countryId,
    this.operatorCode,
    this.requestId,
    this.source,
    this.hashToken,
    this.isDebug,
  });

  factory HeRequestModel.fromJson(Map<String, dynamic> json) => HeRequestModel(
        countryId: json["countryId"],
        operatorCode: json["operatorCode"],
        requestId: json["requestId"],
        source: json["source"],
        hashToken: json["hashToken"],
        isDebug: json["isDebug"],
      );

  Map<String, dynamic> toJson() => {
        "countryId": countryId,
        "operatorCode": operatorCode,
        "requestId": requestId,
        "source": source,
        "hashToken": hashToken,
        "isDebug": isDebug,
      };
}
