// To parse this JSON data, do
//
//     final currencyInfoResponseModel = currencyInfoResponseModelFromJson(jsonString);

import 'dart:convert';

CurrencyInfoResponseModel currencyInfoResponseModelFromJson(String str) => CurrencyInfoResponseModel.fromJson(json.decode(str));

String currencyInfoResponseModelToJson(CurrencyInfoResponseModel data) => json.encode(data.toJson());

class CurrencyInfoResponseModel {
  CurrencyInfoResponseModel({
    this.statusDescription,
    this.operatorConfig,
  });

  StatusDescription statusDescription;
  OperatorConfig operatorConfig;

  factory CurrencyInfoResponseModel.fromJson(Map<String, dynamic> json) => CurrencyInfoResponseModel(
    statusDescription: json["statusDescription"] == null ? null : StatusDescription.fromJson(json["statusDescription"]),
    operatorConfig: json["operatorConfig"] == null ? null : OperatorConfig.fromJson(json["operatorConfig"]),
  );

  Map<String, dynamic> toJson() => {
    "statusDescription": statusDescription == null ? null : statusDescription.toJson(),
    "operatorConfig": operatorConfig == null ? null : operatorConfig.toJson(),
  };
}

class OperatorConfig {
  OperatorConfig({
    this.id,
    this.countryId,
    this.operatorCode,
    this.currency,
    this.maxLengthForAmount,
    this.minInvoiceAmount,
    this.maxInvoiceAmount,
    this.maxAgeOfDevice,
    this.deviceModelName,
    this.tacCode,
  });

  int id;
  String countryId;
  String operatorCode;
  String currency;
  String maxLengthForAmount;
  String minInvoiceAmount;
  String maxInvoiceAmount;
  String maxAgeOfDevice;
  String deviceModelName;
  String tacCode;

  factory OperatorConfig.fromJson(Map<String, dynamic> json) => OperatorConfig(
    id: json["id"] == null ? null : json["id"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    operatorCode: json["operatorCode"] == null ? null : json["operatorCode"],
    currency: json["currency"] == null ? null : json["currency"],
    maxLengthForAmount: json["maxLengthForAmount"] == null ? null : json["maxLengthForAmount"],
    minInvoiceAmount: json["minInvoiceAmount"] == null ? null : json["minInvoiceAmount"],
    maxInvoiceAmount: json["maxInvoiceAmount"] == null ? null : json["maxInvoiceAmount"],
    maxAgeOfDevice: json["maxAgeOfDevice"] == null ? null : json["maxAgeOfDevice"],
    deviceModelName: json["deviceModelName"] == null ? null : json["deviceModelName"],
    tacCode: json["tacCode"] == null ? null : json["tacCode"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "countryId": countryId == null ? null : countryId,
    "operatorCode": operatorCode == null ? null : operatorCode,
    "currency": currency == null ? null : currency,
    "maxLengthForAmount": maxLengthForAmount == null ? null : maxLengthForAmount,
    "minInvoiceAmount": minInvoiceAmount == null ? null : minInvoiceAmount,
    "maxInvoiceAmount": maxInvoiceAmount == null ? null : maxInvoiceAmount,
    "maxAgeOfDevice": maxAgeOfDevice == null ? null : maxAgeOfDevice,
    "deviceModelName": deviceModelName == null ? null : deviceModelName,
    "tacCode": tacCode == null ? null : tacCode,
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
