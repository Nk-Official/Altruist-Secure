// To parse this JSON data, do
//
//     final sendOtpRequestModel = sendOtpRequestModelFromJson(jsonString);

import 'dart:convert';

SendOtpRequestModel sendOtpRequestModelFromJson(String str) =>
    SendOtpRequestModel.fromJson(json.decode(str));

String sendOtpRequestModelToJson(SendOtpRequestModel data) =>
    json.encode(data.toJson());

class SendOtpRequestModel {
  String msisdn;
  String countryId;
  String operatorCode;
  String source;

  SendOtpRequestModel({
    this.msisdn,
    this.countryId,
    this.operatorCode,
    this.source,
  });

  factory SendOtpRequestModel.fromJson(Map<String, dynamic> json) =>
      SendOtpRequestModel(
        msisdn: json["msisdn"],
        countryId: json["countryId"],
        operatorCode: json["operatorCode"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "msisdn": msisdn,
        "countryId": countryId,
        "operatorCode": operatorCode,
        "source": source,
      };
}
