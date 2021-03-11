// To parse this JSON data, do
//
//     final diagnosticListResponseModel = diagnosticListResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:altruist_secure_flutter/models/responses/base/StatusDescription.dart';

DiagnosticListResponseModel diagnosticListResponseModelFromJson(String str) =>
    DiagnosticListResponseModel.fromJson(json.decode(str));

String diagnosticListResponseModelToJson(DiagnosticListResponseModel data) =>
    json.encode(data.toJson());

class DiagnosticListResponseModel {
  StatusDescription statusDescription;
  List<Diagnostic> diagnostics;

  DiagnosticListResponseModel({
    this.statusDescription,
    this.diagnostics,
  });

  factory DiagnosticListResponseModel.fromJson(Map<String, dynamic> json) =>
      DiagnosticListResponseModel(
        statusDescription:
            StatusDescription.fromJson(json["statusDescription"]),
        diagnostics: List<Diagnostic>.from(
            json["diagnostics"].map((x) => Diagnostic.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "statusDescription": statusDescription.toJson(),
        "diagnostics": List<dynamic>.from(diagnostics.map((x) => x.toJson())),
      };
}

class Diagnostic {
  int id;
  String countryId;
  String operatorCode;
  String deviceOs;
  String displayName;
  String diagnosTechName;
  int maxScore;
  int minScore;
  String diaImageUrl;
  String displayOrder;
  String deviceModel;

  Diagnostic({
    this.id,
    this.countryId,
    this.operatorCode,
    this.deviceOs,
    this.displayName,
    this.diagnosTechName,
    this.maxScore,
    this.minScore,
    this.diaImageUrl,
    this.displayOrder,
    this.deviceModel,
  });

  factory Diagnostic.fromJson(Map<String, dynamic> json) => Diagnostic(
        id: json["id"],
        countryId: json["countryId"],
        operatorCode: json["operatorCode"],
        deviceOs: json["deviceOs"],
        displayName: json["displayName"],
        diagnosTechName: json["diagnosTechName"],
        maxScore: json["maxScore"],
        minScore: json["minScore"],
        diaImageUrl: json["diaImageUrl"] == null ? null : json["diaImageUrl"],
        displayOrder: json["displayOrder"],
        deviceModel: json["deviceModel"] == null ? null : json["deviceModel"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "countryId": countryId,
        "operatorCode": operatorCode,
        "deviceOs": deviceOs,
        "displayName": displayName,
        "diagnosTechName": diagnosTechName,
        "maxScore": maxScore,
        "minScore": minScore,
        "diaImageUrl": diaImageUrl == null ? null : diaImageUrl,
        "displayOrder": displayOrder,
        "deviceModel": deviceModel == null ? null : deviceModel,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
