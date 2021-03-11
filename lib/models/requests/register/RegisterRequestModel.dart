// To parse this JSON data, do
//
//     final registerRequestModel = registerRequestModelFromJson(jsonString);

import 'dart:convert';

RegisterRequestModel registerRequestModelFromJson(String str) =>
    RegisterRequestModel.fromJson(json.decode(str));

String registerRequestModelToJson(RegisterRequestModel data) =>
    json.encode(data.toJson());

class RegisterRequestModel {
  String msisdn;
  String countryId;
  String operatorCode;
  String transactionId;
  String source;
  String hashToken;

  RegisterRequestModel({
    this.msisdn,
    this.countryId,
    this.operatorCode,
    this.transactionId,
    this.source,
    this.hashToken,
  });

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) =>
      RegisterRequestModel(
        msisdn: json["msisdn"],
        countryId: json["countryId"],
        operatorCode: json["operatorCode"],
        transactionId: json["transactionId"],
        source: json["source"],
        hashToken: json["hashToken"],
      );

  Map<String, dynamic> toJson() => {
        "msisdn": msisdn,
        "countryId": countryId,
        "operatorCode": operatorCode,
        "transactionId": transactionId,
        "source": source,
        "hashToken": hashToken,
      };
}
