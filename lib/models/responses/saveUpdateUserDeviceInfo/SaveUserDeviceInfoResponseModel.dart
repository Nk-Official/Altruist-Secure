// To parse this JSON data, do
//
//     final saveUserDeviceInfoResponseModel = saveUserDeviceInfoResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:altruist_secure_flutter/models/responses/base/StatusDescription.dart';

SaveUserDeviceInfoResponseModel saveUserDeviceInfoResponseModelFromJson(
        String str) =>
    SaveUserDeviceInfoResponseModel.fromJson(json.decode(str));

String saveUserDeviceInfoResponseModelToJson(
        SaveUserDeviceInfoResponseModel data) =>
    json.encode(data.toJson());

class SaveUserDeviceInfoResponseModel {
  StatusDescription statusDescription;

  SaveUserDeviceInfoResponseModel({
    this.statusDescription,
  });

  factory SaveUserDeviceInfoResponseModel.fromJson(Map<String, dynamic> json) =>
      SaveUserDeviceInfoResponseModel(
        statusDescription:
            StatusDescription.fromJson(json["statusDescription"]),
      );

  Map<String, dynamic> toJson() => {
        "statusDescription": statusDescription.toJson(),
      };
}
