// To parse this JSON data, do
//
//     final currencyInfoRequestModel = currencyInfoRequestModelFromJson(jsonString);

import 'dart:convert';

CurrencyInfoRequestModel currencyInfoRequestModelFromJson(String str) => CurrencyInfoRequestModel.fromJson(json.decode(str));

String currencyInfoRequestModelToJson(CurrencyInfoRequestModel data) => json.encode(data.toJson());

class CurrencyInfoRequestModel {
  String userId;
  String source;
  String countryId;
  String operatorCode;
  String deviceModelName;
  String tacCode;
  String technicalModel;

  CurrencyInfoRequestModel({
    this.userId,
    this.source,
    this.countryId,
    this.operatorCode,
    this.deviceModelName,
    this.tacCode,
    this.technicalModel,
  });

  factory CurrencyInfoRequestModel.fromJson(Map<String, dynamic> json) => CurrencyInfoRequestModel(
    userId: json["userId"],
    source: json["source"],
    countryId: json["countryId"],
    operatorCode: json["operatorCode"],
    deviceModelName: json["deviceModelName"],
    tacCode: json["tacCode"],
    technicalModel: json["technicalModel"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "source": source,
    "countryId": countryId,
    "operatorCode": operatorCode,
    "deviceModelName": deviceModelName,
    "tacCode": tacCode,
    "technicalModel": technicalModel,
  };
}
