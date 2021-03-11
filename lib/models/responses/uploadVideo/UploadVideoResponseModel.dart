// To parse this JSON data, do
//
//     final uploadVideoResponseModel = uploadVideoResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:altruist_secure_flutter/models/responses/base/StatusDescription.dart';

UploadVideoResponseModel uploadVideoResponseModelFromJson(String str) =>
    UploadVideoResponseModel.fromJson(json.decode(str));

String uploadVideoResponseModelToJson(UploadVideoResponseModel data) =>
    json.encode(data.toJson());

class UploadVideoResponseModel {
  StatusDescription statusDescription;
  DeviceDetailsUploadVideo deviceDetails;

  UploadVideoResponseModel({
    this.statusDescription,
    this.deviceDetails,
  });

  factory UploadVideoResponseModel.fromJson(Map<String, dynamic> json) =>
      UploadVideoResponseModel(
        statusDescription:
            StatusDescription.fromJson(json["statusDescription"]),
        deviceDetails: DeviceDetailsUploadVideo.fromJson(json["deviceDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "statusDescription": statusDescription.toJson(),
        "deviceDetails": deviceDetails.toJson(),
      };
}

class DeviceDetailsUploadVideo {
  int id;
  int userId;
  String customerFirstName;
  String customerMiddleName;
  String customerLastName;
  String mobileNumber;
  String email;
  String deviceName;
  String deviceModel;
  String imieNumber;
  String invoiceAmount;
  String currency;
  String invoiceDate;
  String status;
  String deviceOs;
  String deviceOsVersion;
  String recordedVideoHttpUrl;

  DeviceDetailsUploadVideo({
    this.id,
    this.userId,
    this.customerFirstName,
    this.customerMiddleName,
    this.customerLastName,
    this.mobileNumber,
    this.email,
    this.deviceName,
    this.deviceModel,
    this.imieNumber,
    this.invoiceAmount,
    this.currency,
    this.invoiceDate,
    this.status,
    this.deviceOs,
    this.deviceOsVersion,
    this.recordedVideoHttpUrl,
  });

  factory DeviceDetailsUploadVideo.fromJson(Map<String, dynamic> json) =>
      DeviceDetailsUploadVideo(
        id: json["id"],
        userId: json["userId"],
        customerFirstName: json["customerFirstName"],
        customerMiddleName: json["customerMiddleName"],
        customerLastName: json["customerLastName"],
        mobileNumber: json["mobileNumber"],
        email: json["email"],
        deviceName: json["deviceName"],
        deviceModel: json["deviceModel"],
        imieNumber: json["imieNumber"],
        invoiceAmount: json["invoiceAmount"],
        currency: json["currency"],
        invoiceDate: json["invoiceDate"],
        status: json["status"],
        deviceOs: json["deviceOs"],
        deviceOsVersion: json["deviceOsVersion"],
        recordedVideoHttpUrl: json["recordedVideoHttpURL"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "customerFirstName": customerFirstName,
        "customerMiddleName": customerMiddleName,
        "customerLastName": customerLastName,
        "mobileNumber": mobileNumber,
        "email": email,
        "deviceName": deviceName,
        "deviceModel": deviceModel,
        "imieNumber": imieNumber,
        "invoiceAmount": invoiceAmount,
        "currency": currency,
        "invoiceDate": invoiceDate,
        "status": status,
        "deviceOs": deviceOs,
        "deviceOsVersion": deviceOsVersion,
        "recordedVideoHttpURL": recordedVideoHttpUrl,
      };
}
