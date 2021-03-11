// To parse this JSON data, do
//
//     final helpCenterRequestModel = helpCenterRequestModelFromJson(jsonString);

import 'dart:convert';

HelpCenterRequestModel helpCenterRequestModelFromJson(String str) =>
    HelpCenterRequestModel.fromJson(json.decode(str));

String helpCenterRequestModelToJson(HelpCenterRequestModel data) =>
    json.encode(data.toJson());

class HelpCenterRequestModel {
  String userId;
  String source;
  String countryId;
  String operatorCode;

  HelpCenterRequestModel({
    this.userId,
    this.source,
    this.countryId,
    this.operatorCode,
  });

  factory HelpCenterRequestModel.fromJson(Map<String, dynamic> json) =>
      HelpCenterRequestModel(
        userId: json["userId"],
        source: json["source"],
        countryId: json["countryId"],
        operatorCode: json["operatorCode"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "source": source,
        "countryId": countryId,
        "operatorCode": operatorCode,
      };
}
