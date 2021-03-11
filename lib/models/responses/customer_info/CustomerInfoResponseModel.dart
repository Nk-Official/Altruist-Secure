// To parse this JSON data, do
//
//     final customerInfoResponseModel = customerInfoResponseModelFromJson(jsonString);

import 'dart:convert';

CustomerInfoResponseModel customerInfoResponseModelFromJson(String str) => CustomerInfoResponseModel.fromJson(json.decode(str));

String customerInfoResponseModelToJson(CustomerInfoResponseModel data) => json.encode(data.toJson());

class CustomerInfoResponseModel {
  CustomerInfoResponseModel({
    this.statusDescription,
    this.subscriptions,
    this.deviceDiagnosResults,
    this.deviceDetails,
    this.user,
  });

  StatusDescription statusDescription;
  List<Subscription> subscriptions;
  List<DeviceDiagnosResult> deviceDiagnosResults;
  DeviceDetails deviceDetails;
  User user;

  factory CustomerInfoResponseModel.fromJson(Map<String, dynamic> json) => CustomerInfoResponseModel(
    statusDescription: json["statusDescription"] == null ? null : StatusDescription.fromJson(json["statusDescription"]),
    subscriptions: json["subscriptions"] == null ? null : List<Subscription>.from(json["subscriptions"].map((x) => Subscription.fromJson(x))),
    deviceDiagnosResults: json["deviceDiagnosResults"] == null ? null : List<DeviceDiagnosResult>.from(json["deviceDiagnosResults"].map((x) => DeviceDiagnosResult.fromJson(x))),
    deviceDetails: json["deviceDetails"] == null ? null : DeviceDetails.fromJson(json["deviceDetails"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "statusDescription": statusDescription == null ? null : statusDescription.toJson(),
    "subscriptions": subscriptions == null ? null : List<dynamic>.from(subscriptions.map((x) => x.toJson())),
    "deviceDiagnosResults": deviceDiagnosResults == null ? null : List<dynamic>.from(deviceDiagnosResults.map((x) => x.toJson())),
    "deviceDetails": deviceDetails == null ? null : deviceDetails.toJson(),
    "user": user == null ? null : user.toJson(),
  };
}

class DeviceDetails {
  DeviceDetails({
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
    this.recordedVideoHttpUrl,
    this.idproofScanCopyHttpUrl,
    this.idproofScanCopyBackHttpUrl,
    this.fatherName,
    this.nationalId,
    this.deviceUploads,
  });

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
  String recordedVideoHttpUrl;
  String idproofScanCopyHttpUrl;
  String idproofScanCopyBackHttpUrl;
  String fatherName;
  String nationalId;
  List<DeviceUpload> deviceUploads;

  factory DeviceDetails.fromJson(Map<String, dynamic> json) => DeviceDetails(
    id: json["id"] == null ? null : json["id"],
    userId: json["userId"] == null ? null : json["userId"],
    customerFirstName: json["customerFirstName"] == null ? null : json["customerFirstName"],
    customerMiddleName: json["customerMiddleName"] == null ? null : json["customerMiddleName"],
    customerLastName: json["customerLastName"] == null ? null : json["customerLastName"],
    mobileNumber: json["mobileNumber"] == null ? null : json["mobileNumber"],
    email: json["email"] == null ? null : json["email"],
    deviceName: json["deviceName"] == null ? null : json["deviceName"],
    deviceModel: json["deviceModel"] == null ? null : json["deviceModel"],
    imieNumber: json["imieNumber"] == null ? null : json["imieNumber"],
    invoiceAmount: json["invoiceAmount"] == null ? null : json["invoiceAmount"],
    currency: json["currency"] == null ? null : json["currency"],
    invoiceDate: json["invoiceDate"] == null ? null : (json["invoiceDate"]),
    status: json["status"] == null ? null : json["status"],
    deviceOs: json["deviceOs"] == null ? null : json["deviceOs"],
    deviceOsVersion: json["deviceOsVersion"] == null ? null : json["deviceOsVersion"],
    invoiceScanCopyHttpUrl: json["invoiceScanCopyHttpURL"] == null ? null : json["invoiceScanCopyHttpURL"],
    recordedVideoHttpUrl: json["recordedVideoHttpURL"] == null ? null : json["recordedVideoHttpURL"],
    idproofScanCopyHttpUrl: json["idproofScanCopyHttpURL"] == null ? null : json["idproofScanCopyHttpURL"],
    idproofScanCopyBackHttpUrl: json["idproofScanCopyBackHttpURL"] == null ? null : json["idproofScanCopyBackHttpURL"],
    fatherName: json["fatherName"] == null ? null : json["fatherName"],
    nationalId: json["nationalId"] == null ? null : json["nationalId"],
    deviceUploads: json["deviceUploads"] == null ? null : List<DeviceUpload>.from(json["deviceUploads"].map((x) => DeviceUpload.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "userId": userId == null ? null : userId,
    "customerFirstName": customerFirstName == null ? null : customerFirstName,
    "customerMiddleName": customerMiddleName == null ? null : customerMiddleName,
    "customerLastName": customerLastName == null ? null : customerLastName,
    "mobileNumber": mobileNumber == null ? null : mobileNumber,
    "email": email == null ? null : email,
    "deviceName": deviceName == null ? null : deviceName,
    "deviceModel": deviceModel == null ? null : deviceModel,
    "imieNumber": imieNumber == null ? null : imieNumber,
    "invoiceAmount": invoiceAmount == null ? null : invoiceAmount,
    "currency": currency == null ? null : currency,
    "invoiceDate": invoiceDate  == null ? null : invoiceDate,
    "status": status == null ? null : status,
    "deviceOs": deviceOs == null ? null : deviceOs,
    "deviceOsVersion": deviceOsVersion == null ? null : deviceOsVersion,
    "invoiceScanCopyHttpURL": invoiceScanCopyHttpUrl == null ? null : invoiceScanCopyHttpUrl,
    "recordedVideoHttpURL": recordedVideoHttpUrl == null ? null : recordedVideoHttpUrl,
    "idproofScanCopyHttpURL": idproofScanCopyHttpUrl == null ? null : idproofScanCopyHttpUrl,
    "idproofScanCopyBackHttpURL": idproofScanCopyBackHttpUrl == null ? null : idproofScanCopyBackHttpUrl,
    "fatherName": fatherName == null ? null : fatherName,
    "nationalId": nationalId == null ? null : nationalId,
    "deviceUploads": deviceUploads == null ? null : List<dynamic>.from(deviceUploads.map((x) => x.toJson())),
  };
}

class DeviceUpload {
  DeviceUpload({
    this.id,
    this.userId,
    this.uploadType,
    this.status,
    this.uploadDateTime,
    this.resourceUrl,
  });

  int id;
  int userId;
  String uploadType;
  String status;
  int uploadDateTime;
  String resourceUrl;

  factory DeviceUpload.fromJson(Map<String, dynamic> json) => DeviceUpload(
    id: json["id"] == null ? null : json["id"],
    userId: json["userId"] == null ? null : json["userId"],
    uploadType: json["uploadType"] == null ? null : json["uploadType"],
    status: json["status"] == null ? null : json["status"],
    uploadDateTime: json["uploadDateTime"] == null ? null : json["uploadDateTime"],
    resourceUrl: json["resourceUrl"] == null ? null : json["resourceUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "userId": userId == null ? null : userId,
    "uploadType": uploadType == null ? null : uploadType,
    "status": status == null ? null : status,
    "uploadDateTime": uploadDateTime == null ? null : uploadDateTime,
    "resourceUrl": resourceUrl == null ? null : resourceUrl,
  };
}

class DeviceDiagnosResult {
  DeviceDiagnosResult({
    this.id,
    this.userId,
    this.countryId,
    this.operatorCode,
    this.dateTime,
    this.expiryDateTime,
    this.deviceName,
    this.deviceModel,
    this.deviceOs,
    this.appVersion,
    this.score,
    this.status,
    this.imieNumber,
  });

  int id;
  int userId;
  String countryId;
  String operatorCode;
  int dateTime;
  int expiryDateTime;
  String deviceName;
  String deviceModel;
  String deviceOs;
  String appVersion;
  int score;
  String status;
  String imieNumber;

  factory DeviceDiagnosResult.fromJson(Map<String, dynamic> json) => DeviceDiagnosResult(
    id: json["id"] == null ? null : json["id"],
    userId: json["userId"] == null ? null : json["userId"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    operatorCode: json["operatorCode"] == null ? null : json["operatorCode"],
    dateTime: json["dateTime"] == null ? null : json["dateTime"],
    expiryDateTime: json["expiryDateTime"] == null ? null : json["expiryDateTime"],
    deviceName: json["deviceName"] == null ? null : json["deviceName"],
    deviceModel: json["deviceModel"] == null ? null : json["deviceModel"],
    deviceOs: json["deviceOs"] == null ? null : json["deviceOs"],
    appVersion: json["appVersion"] == null ? null : json["appVersion"],
    score: json["score"] == null ? null : json["score"],
    status: json["status"] == null ? null : json["status"],
    imieNumber: json["imieNumber"] == null ? null : json["imieNumber"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "userId": userId == null ? null : userId,
    "countryId": countryId == null ? null : countryId,
    "operatorCode": operatorCode == null ? null : operatorCode,
    "dateTime": dateTime == null ? null : dateTime,
    "expiryDateTime": expiryDateTime == null ? null : expiryDateTime,
    "deviceName": deviceName == null ? null : deviceName,
    "deviceModel": deviceModel == null ? null : deviceModel,
    "deviceOs": deviceOs == null ? null : deviceOs,
    "appVersion": appVersion == null ? null : appVersion,
    "score": score == null ? null : score,
    "status": status == null ? null : status,
    "imieNumber": imieNumber == null ? null : imieNumber,
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
    errorCode: json["errorCode"] == null ? null : json["errorCode"],
    errorMessage: json["errorMessage"] == null ? null : json["errorMessage"],
  );

  Map<String, dynamic> toJson() => {
    "errorCode": errorCode == null ? null : errorCode,
    "errorMessage": errorMessage == null ? null : errorMessage,
  };
}

class Subscription {
  Subscription({
    this.id,
    this.userId,
    this.msisdn,
    this.imieNumber,
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
  String imieNumber;
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
    imieNumber: json["imieNumber"] == null ? null : json["imieNumber"],
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
    "imieNumber": imieNumber == null ? null : imieNumber,
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

class User {
  User({
    this.id,
    this.msisdn,
    this.imieNumber,
    this.countryId,
    this.operatorCode,
    this.regDate,
    this.status,
    this.deviceName,
    this.deviceModel,
    this.deviceOs,
    this.appVersion,
    this.language,
    this.lastSeenTime,
    this.notificationFlag,
  });

  int id;
  String msisdn;
  String imieNumber;
  String countryId;
  String operatorCode;
  int regDate;
  int status;
  String deviceName;
  String deviceModel;
  String deviceOs;
  String appVersion;
  String language;
  int lastSeenTime;
  String notificationFlag;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] == null ? null : json["id"],
    msisdn: json["msisdn"] == null ? null : json["msisdn"],
    imieNumber: json["imieNumber"] == null ? null : json["imieNumber"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    operatorCode: json["operatorCode"] == null ? null : json["operatorCode"],
    regDate: json["regDate"] == null ? null : json["regDate"],
    status: json["status"] == null ? null : json["status"],
    deviceName: json["deviceName"] == null ? null : json["deviceName"],
    deviceModel: json["deviceModel"] == null ? null : json["deviceModel"],
    deviceOs: json["deviceOs"] == null ? null : json["deviceOs"],
    appVersion: json["appVersion"] == null ? null : json["appVersion"],
    language: json["language"] == null ? null : json["language"],
    lastSeenTime: json["lastSeenTime"] == null ? null : json["lastSeenTime"],
    notificationFlag: json["notificationFlag"] == null ? null : json["notificationFlag"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "msisdn": msisdn == null ? null : msisdn,
    "imieNumber": imieNumber == null ? null : imieNumber,
    "countryId": countryId == null ? null : countryId,
    "operatorCode": operatorCode == null ? null : operatorCode,
    "regDate": regDate == null ? null : regDate,
    "status": status == null ? null : status,
    "deviceName": deviceName == null ? null : deviceName,
    "deviceModel": deviceModel == null ? null : deviceModel,
    "deviceOs": deviceOs == null ? null : deviceOs,
    "appVersion": appVersion == null ? null : appVersion,
    "language": language == null ? null : language,
    "lastSeenTime": lastSeenTime == null ? null : lastSeenTime,
    "notificationFlag": notificationFlag == null ? null : notificationFlag,
  };
}
