// To parse this JSON data, do
//
//     final coupenResponse = coupenResponseFromJson(jsonString);

import 'dart:convert';

CoupenResponse coupenResponseFromJson(String str) => CoupenResponse.fromJson(json.decode(str));

String coupenResponseToJson(CoupenResponse data) => json.encode(data.toJson());

class CoupenResponse {
  CoupenResponse({
    this.statusDescription,
    this.subscriptionMaster,
  });

  StatusDescription statusDescription;
  SubscriptionMaster subscriptionMaster;

  factory CoupenResponse.fromJson(Map<String, dynamic> json) => CoupenResponse(
    statusDescription: json["statusDescription"] == null ? null : StatusDescription.fromJson(json["statusDescription"]),
    subscriptionMaster: json["subscriptionMaster"] == null ? null : SubscriptionMaster.fromJson(json["subscriptionMaster"]),
  );

  Map<String, dynamic> toJson() => {
    "statusDescription": statusDescription == null ? null : statusDescription.toJson(),
    "subscriptionMaster": subscriptionMaster == null ? null : subscriptionMaster.toJson(),
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

class SubscriptionMaster {
  SubscriptionMaster({
    this.id,
    this.userId,
    this.msisdn,
    this.productId,
    this.productName,
    this.countryId,
    this.operatorCode,
    this.subscriptionDate,
    this.lastChargeDate,
    this.nextChargeDate,
    this.packType,
    this.status,
    this.policyIssueDateTime,
    this.policyExpiryDateTime,
    this.policyId,
    this.policyStatus,
    this.policyDocReference,
    this.channel,
    this.totalAmount,
    this.paidAmount,
    this.currency,
  });

  int id;
  int userId;
  String msisdn;
  int productId;
  String productName;
  String countryId;
  String operatorCode;
  int subscriptionDate;
  int lastChargeDate;
  int nextChargeDate;
  String packType;
  String status;
  int policyIssueDateTime;
  int policyExpiryDateTime;
  String policyId;
  String policyStatus;
  String policyDocReference;
  String channel;
  String totalAmount;
  String paidAmount;
  String currency;

  factory SubscriptionMaster.fromJson(Map<String, dynamic> json) => SubscriptionMaster(
    id: json["id"] == null ? null : json["id"],
    userId: json["userId"] == null ? null : json["userId"],
    msisdn: json["msisdn"] == null ? null : json["msisdn"],
    productId: json["productId"] == null ? null : json["productId"],
    productName: json["productName"] == null ? null : json["productName"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    operatorCode: json["operatorCode"] == null ? null : json["operatorCode"],
    subscriptionDate: json["subscriptionDate"] == null ? null : json["subscriptionDate"],
    lastChargeDate: json["lastChargeDate"] == null ? null : json["lastChargeDate"],
    nextChargeDate: json["nextChargeDate"] == null ? null : json["nextChargeDate"],
    packType: json["packType"] == null ? null : json["packType"],
    status: json["status"] == null ? null : json["status"],
    policyIssueDateTime: json["policyIssueDateTime"] == null ? null : json["policyIssueDateTime"],
    policyExpiryDateTime: json["policyExpiryDateTime"] == null ? null : json["policyExpiryDateTime"],
    policyId: json["policyId"] == null ? null : json["policyId"],
    policyStatus: json["policyStatus"] == null ? null : json["policyStatus"],
    policyDocReference: json["policyDocReference"] == null ? null : json["policyDocReference"],
    channel: json["channel"] == null ? null : json["channel"],
    totalAmount: json["totalAmount"] == null ? null : json["totalAmount"],
    paidAmount: json["paidAmount"] == null ? null : json["paidAmount"],
    currency: json["currency"] == null ? null : json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "userId": userId == null ? null : userId,
    "msisdn": msisdn == null ? null : msisdn,
    "productId": productId == null ? null : productId,
    "productName": productName == null ? null : productName,
    "countryId": countryId == null ? null : countryId,
    "operatorCode": operatorCode == null ? null : operatorCode,
    "subscriptionDate": subscriptionDate == null ? null : subscriptionDate,
    "lastChargeDate": lastChargeDate == null ? null : lastChargeDate,
    "nextChargeDate": nextChargeDate == null ? null : nextChargeDate,
    "packType": packType == null ? null : packType,
    "status": status == null ? null : status,
    "policyIssueDateTime": policyIssueDateTime == null ? null : policyIssueDateTime,
    "policyExpiryDateTime": policyExpiryDateTime == null ? null : policyExpiryDateTime,
    "policyId": policyId == null ? null : policyId,
    "policyStatus": policyStatus == null ? null : policyStatus,
    "policyDocReference": policyDocReference == null ? null : policyDocReference,
    "channel": channel == null ? null : channel,
    "totalAmount": totalAmount == null ? null : totalAmount,
    "paidAmount": paidAmount == null ? null : paidAmount,
    "currency": currency == null ? null : currency,
  };
}


