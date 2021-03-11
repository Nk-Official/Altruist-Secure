// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

DamageScreenResponse damageScreesResponse(String str) => DamageScreenResponse.fromJson(json.decode(str));

String welcomeToJson(DamageScreenResponse data) => json.encode(data.toJson());

class DamageScreenResponse {
  DamageScreenResponse({
    this.statusDescription,
    this.deviceDetailsUploads,
  });

  StatusDescription statusDescription;
  DeviceDetailsUploads deviceDetailsUploads;

  factory DamageScreenResponse.fromJson(Map<String, dynamic> json) => DamageScreenResponse(
    statusDescription: StatusDescription.fromJson(json["statusDescription"]),
    deviceDetailsUploads: DeviceDetailsUploads.fromJson(json["deviceDetailsUploads"]),
  );

  Map<String, dynamic> toJson() => {
    "statusDescription": statusDescription.toJson(),
    "deviceDetailsUploads": deviceDetailsUploads.toJson(),
  };
}

class DeviceDetailsUploads {
  DeviceDetailsUploads({
    this.id,
    this.userId,
    this.uploadType,
    this.status,
    this.uploadDateTime,
  });

  int id;
  int userId;
  String uploadType;
  String status;
  int uploadDateTime;

  factory DeviceDetailsUploads.fromJson(Map<String, dynamic> json) => DeviceDetailsUploads(
    id: json["id"],
    userId: json["userId"],
    uploadType: json["uploadType"],
    status: json["status"],
    uploadDateTime: json["uploadDateTime"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "uploadType": uploadType,
    "status": status,
    "uploadDateTime": uploadDateTime,
  };
}

class StatusDescription {
  StatusDescription({
    this.errorCode,
    this.errorMessage,
  });

  int errorCode;
  String errorMessage;

  factory StatusDescription.fromJson(Map<String, dynamic> json) => StatusDescription(
    errorCode: json["errorCode"],
    errorMessage: json["errorMessage"],
  );

  Map<String, dynamic> toJson() => {
    "errorCode": errorCode,
    "errorMessage": errorMessage,
  };
}
