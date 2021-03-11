// To parse this JSON data, do
//
//     final idProofsResponseModel = idProofsResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:altruist_secure_flutter/models/responses/base/StatusDescription.dart';

IdProofsResponseModel idProofsResponseModelFromJson(String str) =>
    IdProofsResponseModel.fromJson(json.decode(str));

String idProofsResponseModelToJson(IdProofsResponseModel data) =>
    json.encode(data.toJson());

class IdProofsResponseModel {
  StatusDescription statusDescription;
  DeviceDetailsIDProofs deviceDetails;

  IdProofsResponseModel({
    this.statusDescription,
    this.deviceDetails,
  });

  factory IdProofsResponseModel.fromJson(Map<String, dynamic> json) =>
      IdProofsResponseModel(
        statusDescription:
            StatusDescription.fromJson(json["statusDescription"]),
        deviceDetails: DeviceDetailsIDProofs.fromJson(json["deviceDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "statusDescription": statusDescription.toJson(),
        "deviceDetails": deviceDetails.toJson(),
      };
}

class DeviceDetailsIDProofs {
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
  String idproofScanCopyHttpUrl;
  String idproofScanCopyBackHttpUrl;

  DeviceDetailsIDProofs({
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
    this.idproofScanCopyHttpUrl,
    this.idproofScanCopyBackHttpUrl,
  });

  factory DeviceDetailsIDProofs.fromJson(Map<String, dynamic> json) =>
      DeviceDetailsIDProofs(
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
        idproofScanCopyHttpUrl: json["idproofScanCopyHttpURL"],
        idproofScanCopyBackHttpUrl: json["idproofScanCopyBackHttpURL"] == null
            ? null
            : json["idproofScanCopyBackHttpURL"],
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
        "idproofScanCopyHttpURL": idproofScanCopyHttpUrl,
        "idproofScanCopyBackHttpURL": idproofScanCopyBackHttpUrl,
      };
}
