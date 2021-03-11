// To parse this JSON data, do
//
//     final helpCenterResponseModel = helpCenterResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:altruist_secure_flutter/models/responses/base/StatusDescription.dart';

HelpCenterResponseModel helpCenterResponseModelFromJson(String str) =>
    HelpCenterResponseModel.fromJson(json.decode(str));

String helpCenterResponseModelToJson(HelpCenterResponseModel data) =>
    json.encode(data.toJson());

class HelpCenterResponseModel {
  StatusDescription statusDescription;
  List<HelpLine> helpLines;

  HelpCenterResponseModel({
    this.statusDescription,
    this.helpLines,
  });

  factory HelpCenterResponseModel.fromJson(Map<String, dynamic> json) =>
      HelpCenterResponseModel(
        statusDescription:
            StatusDescription.fromJson(json["statusDescription"]),
        helpLines: json["helpLines"] == null
            ? null
            : List<HelpLine>.from(
                json["helpLines"].map((x) => HelpLine.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "statusDescription": statusDescription.toJson(),
        "helpLines": List<dynamic>.from(helpLines.map((x) => x.toJson())),
      };
}

class HelpLine {
  int id;
  String countryId;
  String operatorCode;
  String helplineNumber;
  String helplineEmail;

  HelpLine({
    this.id,
    this.countryId,
    this.operatorCode,
    this.helplineNumber,
    this.helplineEmail,
  });

  factory HelpLine.fromJson(Map<String, dynamic> json) => HelpLine(
        id: json["id"],
        countryId: json["countryId"],
        operatorCode: json["operatorCode"],
        helplineNumber: json["helplineNumber"],
        helplineEmail: json["helplineEmail"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "countryId": countryId,
        "operatorCode": operatorCode,
        "helplineNumber": helplineNumber,
        "helplineEmail": helplineEmail,
      };
}
