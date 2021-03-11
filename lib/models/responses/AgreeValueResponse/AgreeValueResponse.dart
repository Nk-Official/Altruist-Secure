// To parse this JSON data, do
//
//     final agreeValueResponse = agreeValueResponseFromJson(jsonString);

import 'dart:convert';

AgreeValueResponse agreeValueResponseFromJson(String str) => AgreeValueResponse.fromJson(json.decode(str));

String agreeValueResponseToJson(AgreeValueResponse data) => json.encode(data.toJson());

class AgreeValueResponse {
  AgreeValueResponse({
    this.statusDescription,
    this.agreeValue,
  });

  StatusDescription statusDescription;
  String agreeValue;

  factory AgreeValueResponse.fromJson(Map<String, dynamic> json) => AgreeValueResponse(
    statusDescription: json["statusDescription"] == null ? null : StatusDescription.fromJson(json["statusDescription"]),
    agreeValue: json["agreeValue"] == null ? null : json["agreeValue"],
  );

  Map<String, dynamic> toJson() => {
    "statusDescription": statusDescription == null ? null : statusDescription.toJson(),
    "agreeValue": agreeValue == null ? null : agreeValue,
  };
}

class StatusDescription {
  StatusDescription({
    this.errorCode,
    this.errorMessage,
    this.qrCode,
  });

  int errorCode;
  String errorMessage;
  dynamic qrCode;

  factory StatusDescription.fromJson(Map<String, dynamic> json) => StatusDescription(
    errorCode: json["errorCode"] == null ? null : json["errorCode"],
    errorMessage: json["errorMessage"] == null ? null : json["errorMessage"],
    qrCode: json["qrCode"],
  );

  Map<String, dynamic> toJson() => {
    "errorCode": errorCode == null ? null : errorCode,
    "errorMessage": errorMessage == null ? null : errorMessage,
    "qrCode": qrCode,
  };
}
