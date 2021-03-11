// To parse this JSON data, do
//
//     final qrCodeScanRequest = qrCodeScanRequestFromJson(jsonString);

import 'dart:convert';

QrCodeScanStatusResponse qrCodeScanStatusFromJson(String str) => QrCodeScanStatusResponse.fromJson(json.decode(str));

String qrCodeScanRequestToJson(QrCodeScanStatusResponse data) => json.encode(data.toJson());

class QrCodeScanStatusResponse {
  QrCodeScanStatusResponse({
    this.errorCode,
    this.errorMessage,
    this.qrCode,
  });

  int errorCode;
  String errorMessage;
  QrCode qrCode;

  factory QrCodeScanStatusResponse.fromJson(Map<String, dynamic> json) => QrCodeScanStatusResponse(
    errorCode: json["errorCode"],
    errorMessage: json["errorMessage"],
    qrCode: QrCode.fromJson(json["qrCode"]),
  );

  Map<String, dynamic> toJson() => {
    "errorCode": errorCode,
    "errorMessage": errorMessage,
    "qrCode": qrCode.toJson(),
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
    id: json["id"],
    creationTime: json["creationTime"],
    expiryDate: json["expiryDate"],
    qrCodeImagePath: json["qrCodeImagePath"],
    userId: json["userId"],
    qrCodeToken: json["qrCodeToken"],
    status: json["status"],
    qrCodeStatus: json["qrCodeStatus"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "creationTime": creationTime,
    "expiryDate": expiryDate,
    "qrCodeImagePath": qrCodeImagePath,
    "userId": userId,
    "qrCodeToken": qrCodeToken,
    "status": status,
    "qrCodeStatus": qrCodeStatus,
  };
}
