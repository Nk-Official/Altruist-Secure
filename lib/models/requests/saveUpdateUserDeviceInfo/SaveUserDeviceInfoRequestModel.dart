// To parse this JSON data, do
//
//     final saveUserDeviceInfoRequestModel = saveUserDeviceInfoRequestModelFromJson(jsonString);
import 'dart:convert';
SaveUserDeviceInfoRequestModel saveUserDeviceInfoRequestModelFromJson(
        String str) =>
    SaveUserDeviceInfoRequestModel.fromJson(json.decode(str));

String saveUserDeviceInfoRequestModelToJson(
        SaveUserDeviceInfoRequestModel data) =>
    json.encode(data.toJson());

class SaveUserDeviceInfoRequestModel {
  String userId;
  String source;
  DeviceDetails deviceDetails;

  SaveUserDeviceInfoRequestModel({
    this.userId,
    this.source,
    this.deviceDetails,
  });

  factory SaveUserDeviceInfoRequestModel.fromJson(Map<String, dynamic> json) =>
      SaveUserDeviceInfoRequestModel(
        userId: json["userId"],
        source: json["source"],
        deviceDetails: DeviceDetails.fromJson(json["deviceDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "source": source,
        "deviceDetails": deviceDetails.toJson(),
      };
}

class DeviceDetails {
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
  String deviceOs;
  String deviceOsVersion;
  String fatherName;
  String nationalId;
  String marketValue;
  String sumAssuredValue;

  DeviceDetails({
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
    this.deviceOs,
    this.deviceOsVersion,
    this.fatherName,
    this.nationalId,
    this.marketValue,
    this.sumAssuredValue,
  });

  factory DeviceDetails.fromJson(Map<String, dynamic> json) => DeviceDetails(
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
        deviceOs: json["deviceOs"],
        deviceOsVersion: json["deviceOsVersion"],
        fatherName: json["fatherName"],
        nationalId: json["nationalId"],
        marketValue: json["marketValue"],
        sumAssuredValue: json["sumAssuredValue"],
      );

  Map<String, dynamic> toJson() => {
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
        "deviceOs": deviceOs,
        "deviceOsVersion": deviceOsVersion,
        "fatherName": fatherName,
        "nationalId": nationalId,
        "marketValue": marketValue,
        "sumAssuredValue": sumAssuredValue,
      };
}
