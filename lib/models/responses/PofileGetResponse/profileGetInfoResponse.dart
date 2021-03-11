// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

ProfileGetInfoResponse getinforesponse(String str) =>
    ProfileGetInfoResponse.fromJson(json.decode(str));

String welcomeToJson(ProfileGetInfoResponse data) => json.encode(data.toJson());

class ProfileGetInfoResponse {
  ProfileGetInfoResponse({
    this.statusDescription,
    this.user,
  });

  StatusDescription statusDescription;
  User user;

  factory ProfileGetInfoResponse.fromJson(Map<String, dynamic> json) => ProfileGetInfoResponse(
    statusDescription: StatusDescription.fromJson(json["statusDescription"]),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "statusDescription": statusDescription.toJson(),
    "user": user.toJson(),
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

class User {
  User({
    this.id,
    this.msisdn,
    this.imieNumber,
    this.countryId,
    this.operatorCode,
    this.regDate,
    this.status,
    this.fcmToken,
    this.appVersion,
    this.email,
    this.language,
    this.deviceOsName,
    this.lastSeenTime,
    this.regChannel,
    this.notificationFlag,
    this.address,
    this.alternativeNumber,
    this.dob,
    this.gender,
  });

  int id;
  String msisdn;
  String imieNumber;
  String countryId;
  String operatorCode;
  int regDate;
  int status;
  String fcmToken;
  String appVersion;
  String email;
  String language;
  String deviceOsName;
  int lastSeenTime;
  String regChannel;
  String notificationFlag;
  String address;
  String alternativeNumber;
  String dob;
  String gender;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    msisdn: json["msisdn"],
    imieNumber: json["imieNumber"],
    countryId: json["countryId"],
    operatorCode: json["operatorCode"],
    regDate: json["regDate"],
    status: json["status"],
    fcmToken: json["fcmToken"],
    appVersion: json["appVersion"],
    email: json["email"],
    language: json["language"],
    deviceOsName: json["deviceOsName"],
    lastSeenTime: json["lastSeenTime"],
    regChannel: json["regChannel"],
    notificationFlag: json["notificationFlag"],
    address: json["address"],
    alternativeNumber: json["alternativeNumber"],
    dob: json["dob"],
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "msisdn": msisdn,
    "imieNumber": imieNumber,
    "countryId": countryId,
    "operatorCode": operatorCode,
    "regDate": regDate,
    "status": status,
    "fcmToken": fcmToken,
    "appVersion": appVersion,
    "email": email,
    "language": language,
    "deviceOsName": deviceOsName,
    "lastSeenTime": lastSeenTime,
    "regChannel": regChannel,
    "notificationFlag": notificationFlag,
    "address": address,
    "alternativeNumber": alternativeNumber,
    "dob": dob,
    "gender": gender,
  };
}
