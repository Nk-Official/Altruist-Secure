// To parse this JSON data, do
//
//     final invoiceResponseModel = invoiceResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:altruist_secure_flutter/models/responses/base/StatusDescription.dart';

InvoiceResponseModel invoiceResponseModelFromJson(String str) =>
    InvoiceResponseModel.fromJson(json.decode(str));

String invoiceResponseModelToJson(InvoiceResponseModel data) =>
    json.encode(data.toJson());

class InvoiceResponseModel {
  StatusDescription statusDescription;
  DeviceDetail deviceDetails;

  InvoiceResponseModel({
    this.statusDescription,
    this.deviceDetails,
  });

  factory InvoiceResponseModel.fromJson(Map<String, dynamic> json) =>
      InvoiceResponseModel(
        statusDescription:
            StatusDescription.fromJson(json["statusDescription"]),
        deviceDetails: json["deviceDetails"] == null
            ? null
            : DeviceDetail.fromJson(json["deviceDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "statusDescription": statusDescription.toJson(),
        "deviceDetails": deviceDetails.toJson(),
      };
}

class DeviceDetail {
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
  String invoiceScanCopyHttpUrl;

  DeviceDetail({
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
    this.invoiceScanCopyHttpUrl,
  });

  factory DeviceDetail.fromJson(Map<String, dynamic> json) => DeviceDetail(
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
        invoiceScanCopyHttpUrl: json["invoiceScanCopyHttpURL"],
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
        "invoiceScanCopyHttpURL": invoiceScanCopyHttpUrl,
      };
}
