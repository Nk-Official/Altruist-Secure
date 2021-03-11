// To parse this JSON data, do
//
//     final qrCodeScanRequest = qrCodeScanRequestFromJson(jsonString);

import 'dart:convert';

QrCodeScanRequest qrCodeScanRequestFromJson(String str) => QrCodeScanRequest.fromJson(json.decode(str));

String qrCodeScanRequestToJson(QrCodeScanRequest data) => json.encode(data.toJson());

class QrCodeScanRequest {
  QrCodeScanRequest({
    this.userId,
    this.qrCodeToken,
  });

  int userId;
  String qrCodeToken;

  factory QrCodeScanRequest.fromJson(Map<String, dynamic> json) => QrCodeScanRequest(
    userId: json["userId"],
    qrCodeToken: json["qrCodeToken"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "qrCodeToken": qrCodeToken,
  };
}
