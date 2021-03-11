// To parse this JSON data, do
//
//     final saveDiagnoseResponseModel = saveDiagnoseResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:altruist_secure_flutter/models/responses/base/StatusDescription.dart';

SaveDiagnoseResponseModel saveDiagnoseResponseModelFromJson(String str) =>
    SaveDiagnoseResponseModel.fromJson(json.decode(str));

String saveDiagnoseResponseModelToJson(SaveDiagnoseResponseModel data) =>
    json.encode(data.toJson());

class SaveDiagnoseResponseModel {
  StatusDescription statusDescription;

  SaveDiagnoseResponseModel({
    this.statusDescription,
  });

  factory SaveDiagnoseResponseModel.fromJson(Map<String, dynamic> json) =>
      SaveDiagnoseResponseModel(
        statusDescription:
            StatusDescription.fromJson(json["statusDescription"]),
      );

  Map<String, dynamic> toJson() => {
        "statusDescription": statusDescription.toJson(),
      };
}
