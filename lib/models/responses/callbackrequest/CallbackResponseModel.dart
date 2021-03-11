// To parse this JSON data, do
//
//     final callbackResponseModel = callbackResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:altruist_secure_flutter/models/responses/base/StatusDescription.dart';

CallbackResponseModel callbackResponseModelFromJson(String str) =>
    CallbackResponseModel.fromJson(json.decode(str));

String callbackResponseModelToJson(CallbackResponseModel data) =>
    json.encode(data.toJson());

class CallbackResponseModel {
  StatusDescription statusDescription;
  int requestId;

  CallbackResponseModel({
    this.statusDescription,
    this.requestId,
  });

  factory CallbackResponseModel.fromJson(Map<String, dynamic> json) =>
      CallbackResponseModel(
        statusDescription:
            StatusDescription.fromJson(json["statusDescription"]),
        requestId: json["requestId"],
      );

  Map<String, dynamic> toJson() => {
        "statusDescription": statusDescription.toJson(),
        "requestId": requestId,
      };
}
