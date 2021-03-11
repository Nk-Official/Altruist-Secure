// To parse this JSON data, do
//
//     final verifyOtpRequestModel = verifyOtpRequestModelFromJson(jsonString);

import 'dart:convert';

VerifyOtpRequestModel verifyOtpRequestModelFromJson(String str) =>
    VerifyOtpRequestModel.fromJson(json.decode(str));

String verifyOtpRequestModelToJson(VerifyOtpRequestModel data) =>
    json.encode(data.toJson());

class VerifyOtpRequestModel {
  String msisdn;
  String countryId;
  String otp;
  String operatorCode;
  String transactionId;
  String source;

  VerifyOtpRequestModel({
    this.msisdn,
    this.countryId,
    this.otp,
    this.operatorCode,
    this.transactionId,
    this.source,
  });

  factory VerifyOtpRequestModel.fromJson(Map<String, dynamic> json) =>
      VerifyOtpRequestModel(
        msisdn: json["msisdn"],
        countryId: json["countryId"],
        otp: json["otp"],
        operatorCode: json["operatorCode"],
        transactionId: json["transactionId"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "msisdn": msisdn,
        "countryId": countryId,
        "otp": otp,
        "operatorCode": operatorCode,
        "transactionId": transactionId,
        "source": source,
      };





}
