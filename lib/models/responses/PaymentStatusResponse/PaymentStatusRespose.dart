// To parse this JSON data, do
//
//     final paymentResponse = paymentResponseFromJson(jsonString);

import 'dart:convert';

PaymentResponse paymentResponseFromJson(String str) => PaymentResponse.fromJson(json.decode(str));

String paymentResponseToJson(PaymentResponse data) => json.encode(data.toJson());

class PaymentResponse {
  PaymentResponse({
    this.statusDescription,
    this.subscription,
    this.purchaseTransaction,
  });

  StatusDescription statusDescription;
  Subscription subscription;
  List<PurchaseTransaction> purchaseTransaction;

  factory PaymentResponse.fromJson(Map<String, dynamic> json) => PaymentResponse(
    statusDescription: json["statusDescription"] == null ? null : StatusDescription.fromJson(json["statusDescription"]),
    subscription: json["subscription"] == null ? null : Subscription.fromJson(json["subscription"]),
    purchaseTransaction: json["purchaseTransaction"] == null ? null : List<PurchaseTransaction>.from(json["purchaseTransaction"].map((x) => PurchaseTransaction.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusDescription": statusDescription == null ? null : statusDescription.toJson(),
    "subscription": subscription == null ? null : subscription.toJson(),
    "purchaseTransaction": purchaseTransaction == null ? null : List<dynamic>.from(purchaseTransaction.map((x) => x.toJson())),
  };
}

class PurchaseTransaction {
  PurchaseTransaction({
    this.id,
    this.userId,
    this.countryId,
    this.operatorCode,
    this.amount,
    this.currency,
    this.productId,
    this.productName,
    this.transactionId,
    this.billPartnerName,
    this.status,
    this.verificationStatus,
    this.dateTime,
    this.respDateTime,
    this.requestPayload,
    this.response,
    this.respPaymentStatus,
    this.respPayMode,
    this.respPayId,
    this.userStatus,
    this.billCfgId,
  });

  int id;
  int userId;
  String countryId;
  String operatorCode;
  String amount;
  String currency;
  int productId;
  String productName;
  String transactionId;
  String billPartnerName;
  String status;
  dynamic verificationStatus;
  DateTime dateTime;
  DateTime respDateTime;
  String requestPayload;
  String response;
  String respPaymentStatus;
  dynamic respPayMode;
  String respPayId;
  String userStatus;
  int billCfgId;

  factory PurchaseTransaction.fromJson(Map<String, dynamic> json) => PurchaseTransaction(
    id: json["id"] == null ? null : json["id"],
    userId: json["userId"] == null ? null : json["userId"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    operatorCode: json["operatorCode"] == null ? null : json["operatorCode"],
    amount: json["amount"] == null ? null : json["amount"],
    currency: json["currency"] == null ? null : json["currency"],
    productId: json["productId"] == null ? null : json["productId"],
    productName: json["productName"] == null ? null : json["productName"],
    transactionId: json["transactionId"] == null ? null : json["transactionId"],
    billPartnerName: json["billPartnerName"] == null ? null : json["billPartnerName"],
    status: json["status"] == null ? null : json["status"],
    verificationStatus: json["verificationStatus"],
    dateTime: json["dateTime"] == null ? null : DateTime.parse(json["dateTime"]),
    respDateTime: json["respDateTime"] == null ? null : DateTime.parse(json["respDateTime"]),
    requestPayload: json["requestPayload"] == null ? null : json["requestPayload"],
    response: json["response"] == null ? null : json["response"],
    respPaymentStatus: json["respPaymentStatus"] == null ? null : json["respPaymentStatus"],
    respPayMode: json["respPayMode"],
    respPayId: json["respPayId"] == null ? null : json["respPayId"],
    userStatus: json["userStatus"] == null ? null : json["userStatus"],
    billCfgId: json["billCfgId"] == null ? null : json["billCfgId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "userId": userId == null ? null : userId,
    "countryId": countryId == null ? null : countryId,
    "operatorCode": operatorCode == null ? null : operatorCode,
    "amount": amount == null ? null : amount,
    "currency": currency == null ? null : currency,
    "productId": productId == null ? null : productId,
    "productName": productName == null ? null : productName,
    "transactionId": transactionId == null ? null : transactionId,
    "billPartnerName": billPartnerName == null ? null : billPartnerName,
    "status": status == null ? null : status,
    "verificationStatus": verificationStatus,
    "dateTime": dateTime == null ? null : dateTime.toIso8601String(),
    "respDateTime": respDateTime == null ? null : respDateTime.toIso8601String(),
    "requestPayload": requestPayload == null ? null : requestPayload,
    "response": response == null ? null : response,
    "respPaymentStatus": respPaymentStatus == null ? null : respPaymentStatus,
    "respPayMode": respPayMode,
    "respPayId": respPayId == null ? null : respPayId,
    "userStatus": userStatus == null ? null : userStatus,
    "billCfgId": billCfgId == null ? null : billCfgId,
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

class Subscription {
  Subscription({
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

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
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
