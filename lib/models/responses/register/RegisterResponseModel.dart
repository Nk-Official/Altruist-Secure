// To parse this JSON data, do
//
//     final registerResponseModel = registerResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:altruist_secure_flutter/models/responses/base/StatusDescription.dart';
import 'package:altruist_secure_flutter/models/responses/verify_otp/User.dart';

RegisterResponseModel registerResponseModelFromJson(String str) =>
    RegisterResponseModel.fromJson(json.decode(str));

String registerResponseModelToJson(RegisterResponseModel data) =>
    json.encode(data.toJson());

class RegisterResponseModel {
  StatusDescription statusDescription;
  User user;

  RegisterResponseModel({
    this.statusDescription,
    this.user,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      RegisterResponseModel(
        statusDescription:
            StatusDescription.fromJson(json["statusDescription"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "statusDescription": statusDescription.toJson(),
        "user": user.toJson(),
      };
//      RegisterResponseModel(
//        statusDescription:
//            StatusDescription.fromJson(json["statusDescription"]),
//        user: json["user"] == null ? null : User.fromJson(json["user"]),
//      );
//
//  Map<String, dynamic> toJson() => {
//        "statusDescription": statusDescription.toJson(),
//        "user": user.toJson(),
//      };
}
