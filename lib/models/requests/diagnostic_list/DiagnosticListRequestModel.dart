// To parse this JSON data, do
//
//     final diagnosticListRequestModel = diagnosticListRequestModelFromJson(jsonString);

import 'dart:convert';

DiagnosticListRequestModel diagnosticListRequestModelFromJson(String str) =>
    DiagnosticListRequestModel.fromJson(json.decode(str));

String diagnosticListRequestModelToJson(DiagnosticListRequestModel data) =>
    json.encode(data.toJson());

class DiagnosticListRequestModel {
  String userId;
  String source;
  String operatorCode;
  String countryId;

  DiagnosticListRequestModel({
    this.userId,
    this.source,
    this.operatorCode,
    this.countryId,
  });

  factory DiagnosticListRequestModel.fromJson(Map<String, dynamic> json) =>
      DiagnosticListRequestModel(
        userId: json["userId"],
        source: json["source"],
        operatorCode: json["operatorCode"],
        countryId: json["countryId"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "source": source,
        "operatorCode": operatorCode,
        "countryId": countryId,
      };
}
