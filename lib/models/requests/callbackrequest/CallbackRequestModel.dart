// To parse this JSON data, do
//
//     final callbackRequestModel = callbackRequestModelFromJson(jsonString);

import 'dart:convert';

CallbackRequestModel callbackRequestModelFromJson(String str) =>
    CallbackRequestModel.fromJson(json.decode(str));

String callbackRequestModelToJson(CallbackRequestModel data) =>
    json.encode(data.toJson());

class CallbackRequestModel {
  String userId;
  String source;
  String mobile;

  CallbackRequestModel({
    this.userId,
    this.source,
    this.mobile,
  });

  factory CallbackRequestModel.fromJson(Map<String, dynamic> json) =>
      CallbackRequestModel(
        userId: json["userId"],
        source: json["source"],
        mobile: json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "source": source,
        "mobile": mobile,
      };
}
