import 'dart:convert';
CuntryResponseModel getcuntryRes(String str) => CuntryResponseModel.fromJson(json.decode(str));
String welcomeToJson(CuntryResponseModel data) => json.encode(data.toJson());
class CuntryResponseModel {
  CuntryResponseModel({
    this.statusDescription,
    this.countryList,
  });

  StatusDescription statusDescription;
  List<CountryList> countryList;

  factory CuntryResponseModel.fromJson(Map<String, dynamic> json) => CuntryResponseModel(
    statusDescription: StatusDescription.fromJson(json["statusDescription"]),
    countryList: List<CountryList>.from(json["countryList"].map((x) => CountryList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusDescription": statusDescription.toJson(),
    "countryList": List<dynamic>.from(countryList.map((x) => x.toJson())),
  };
}

class CountryList {
  CountryList({
    this.id,
    this.countryName,
    this.countryCode,
    this.status,
    this.a,
    this.mobileNumberLength,
    this.policyWordingLink,
  });

  int id;
  String countryName;
  String countryCode;
  bool status;
  String a;
  int mobileNumberLength;
  String policyWordingLink;

  factory CountryList.fromJson(Map<String, dynamic> json) => CountryList(
    id: json["id"],
    countryName: json["countryName"],
    countryCode: json["countryCode"] == null ? null : json["countryCode"],
    status: json["status"],
    a: json["a"] == null ? null : json["a"],
    mobileNumberLength:json["mobileNumberLength"],
    policyWordingLink:json["policyWordingLink"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "countryName": countryName,
    "countryCode": countryCode == null ? null : countryCode,
    "status": status,
    "a": a == null ? null : a,
    "mobileNumberLength":mobileNumberLength,
    "policyWordingLink":policyWordingLink
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
