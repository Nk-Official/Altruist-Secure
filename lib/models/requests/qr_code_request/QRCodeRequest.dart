import 'dart:convert';

QRCodeRequest welcomeFromJson(String str) => QRCodeRequest.fromJson(json.decode(str));

String welcomeToJson(QRCodeRequest data) => json.encode(data.toJson());

class QRCodeRequest {
  QRCodeRequest({
    this.userId,
  });

  int userId;

  factory QRCodeRequest.fromJson(Map<String, dynamic> json) => QRCodeRequest(
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
  };
}
