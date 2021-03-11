// To parse this JSON data, do
//
//     final qrCodeResponse = qrCodeResponseFromJson(jsonString);

import 'dart:convert';

QrCodeResponse qrCodeResponseFromJson(String str) => QrCodeResponse.fromJson(json.decode(str));

String qrCodeResponseToJson(QrCodeResponse data) => json.encode(data.toJson());

class QrCodeResponse {
  QrCodeResponse({
    this.errorCode,
    this.errorMessage,
    this.qrCode,
  });

  int errorCode;
  String errorMessage;
  QrCode qrCode;

  factory QrCodeResponse.fromJson(Map<String, dynamic> json) => QrCodeResponse(
    errorCode: json["errorCode"] == null ? null : json["errorCode"],
    errorMessage: json["errorMessage"] == null ? null : json["errorMessage"],
    qrCode: json["qrCode"] == null ? null : QrCode.fromJson(json["qrCode"]),
  );

  Map<String, dynamic> toJson() => {
    "errorCode": errorCode == null ? null : errorCode,
    "errorMessage": errorMessage == null ? null : errorMessage,
    "qrCode": qrCode == null ? null : qrCode.toJson(),
  };
}

class QrCode {
  QrCode({
    this.id,
    this.creationTime,
    this.expiryDate,
    this.qrCodeImagePath,
    this.userId,
    this.qrCodeToken,
    this.status,
    this.qrCodeStatus,
  });

  int id;
  int creationTime;
  int expiryDate;
  String qrCodeImagePath;
  int userId;
  String qrCodeToken;
  bool status;
  bool qrCodeStatus;

  factory QrCode.fromJson(Map<String, dynamic> json) => QrCode(
    id: json["id"] == null ? null : json["id"],
    creationTime: json["creationTime"] == null ? null : json["creationTime"],
    expiryDate: json["expiryDate"] == null ? null : json["expiryDate"],
    qrCodeImagePath: json["qrCodeImagePath"] == null ? null : json["qrCodeImagePath"],
    userId: json["userId"] == null ? null : json["userId"],
    qrCodeToken: json["qrCodeToken"] == null ? null : json["qrCodeToken"],
    status: json["status"] == null ? null : json["status"],
    qrCodeStatus: json["qrCodeStatus"] == null ? null : json["qrCodeStatus"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "creationTime": creationTime == null ? null : creationTime,
    "expiryDate": expiryDate == null ? null : expiryDate,
    "qrCodeImagePath": qrCodeImagePath == null ? null : qrCodeImagePath,
    "userId": userId == null ? null : userId,
    "qrCodeToken": qrCodeToken == null ? null : qrCodeToken,
    "status": status == null ? null : status,
    "qrCodeStatus": qrCodeStatus == null ? null : qrCodeStatus,
  };
}
