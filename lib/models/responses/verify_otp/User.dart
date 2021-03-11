import 'package:altruist_secure_flutter/models/responses/verify_otp/UserTokenDetails.dart';

class User {
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
  UserTokenDetails userTokenDetails;
  int lastSeenTime;
  String notificationFlag;


  User({
    this.id,
    this.msisdn,
    this.countryId,
    this.operatorCode,
    this.regDate,
    this.status,
    this.userTokenDetails,
    this.lastSeenTime,
    this.notificationFlag,
    this.imieNumber,
    this.deviceName,
    this.deviceModel,
    this.deviceOs,
    this.appVersion,
    this.language,
  });




  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        msisdn: json["msisdn"],
        countryId: json["countryId"],
        operatorCode: json["operatorCode"],
        regDate: json["regDate"],
        status: json["status"],
        userTokenDetails: UserTokenDetails.fromJson(json["userTokenDetails"]),
        lastSeenTime: json["lastSeenTime"],
        notificationFlag: json["notificationFlag"],
        imieNumber: json["imieNumber"] == null ? null : json["imieNumber"],
        deviceName: json["deviceName"] == null ? null : json["deviceName"],
        deviceModel: json["deviceModel"] == null ? null : json["deviceModel"],
        deviceOs: json["deviceOs"] == null ? null : json["deviceOs"],
        appVersion: json["appVersion"] == null ? null : json["appVersion"],
        language: json["language"] == null ? null : json["language"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "msisdn": msisdn,
        "countryId": countryId,
        "operatorCode": operatorCode,
        "regDate": regDate,
        "status": status,
        "userTokenDetails": userTokenDetails.toJson(),
        "lastSeenTime": lastSeenTime,
        "notificationFlag": notificationFlag,
        "imieNumber": imieNumber,
        "deviceName": deviceName,
        "deviceModel": deviceModel,
        "deviceOs": deviceOs,
        "appVersion": appVersion,
        "language": language,
      };
}
