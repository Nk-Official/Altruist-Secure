// To parse this JSON data, do
//
//     final saveDiagnoseRequestModel = saveDiagnoseRequestModelFromJson(jsonString);

import 'dart:convert';

SaveDiagnoseRequestModel saveDiagnoseRequestModelFromJson(String str) =>
    SaveDiagnoseRequestModel.fromJson(json.decode(str));

String saveDiagnoseRequestModelToJson(SaveDiagnoseRequestModel data) =>
    json.encode(data.toJson());

class SaveDiagnoseRequestModel {
  String userId;
  String source;
  DiagnosResult diagnosResult;
  List<DiagnosResultDetail> diagnosResultDetails;

  SaveDiagnoseRequestModel({
    this.userId,
    this.source,
    this.diagnosResult,
    this.diagnosResultDetails,
  });

  factory SaveDiagnoseRequestModel.fromJson(Map<String, dynamic> json) =>
      SaveDiagnoseRequestModel(
        userId: json["userId"],
        source: json["source"],
        diagnosResult: DiagnosResult.fromJson(json["diagnosResult"]),
        diagnosResultDetails: List<DiagnosResultDetail>.from(
            json["diagnosResultDetails"]
                .map((x) => DiagnosResultDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "source": source,
        "diagnosResult": diagnosResult.toJson(),
        "diagnosResultDetails":
            List<dynamic>.from(diagnosResultDetails.map((x) => x.toJson())),
      };
}

class DiagnosResult {
  String deviceName;
  String deviceModel;
  String deviceOs;
  String appVersion;
  int score;
  String imieNumber;

  DiagnosResult({
    this.deviceName,
    this.deviceModel,
    this.deviceOs,
    this.appVersion,
    this.score,
    this.imieNumber,
  });

  factory DiagnosResult.fromJson(Map<String, dynamic> json) => DiagnosResult(
        deviceName: json["deviceName"],
        deviceModel: json["deviceModel"],
        deviceOs: json["deviceOs"],
        appVersion: json["appVersion"],
        score: json["score"],
        imieNumber: json["imieNumber"],
      );

  Map<String, dynamic> toJson() => {
        "deviceName": deviceName,
        "deviceModel": deviceModel,
        "deviceOs": deviceOs,
        "appVersion": appVersion,
        "score": score,
        "imieNumber": imieNumber,
      };
}

class DiagnosResultDetail {
  int diagnosId;
  String diagnosTechName;
  int score;

  DiagnosResultDetail({
    this.diagnosId,
    this.diagnosTechName,
    this.score,
  });

  factory DiagnosResultDetail.fromJson(Map<String, dynamic> json) =>
      DiagnosResultDetail(
        diagnosId: json["diagnosId"],
        diagnosTechName: json["diagnosTechName"],
        score: json["score"],
      );

  Map<String, dynamic> toJson() => {
        "diagnosId": diagnosId,
        "diagnosTechName": diagnosTechName,
        "score": score,
      };
}
