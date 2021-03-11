// To parse this JSON data, do
//
//     final coupenRequest = coupenRequestFromJson(jsonString);

import 'dart:convert';

CoupenRequest coupenRequestFromJson(String str) => CoupenRequest.fromJson(json.decode(str));

String coupenRequestToJson(CoupenRequest data) => json.encode(data.toJson());

class CoupenRequest {
  CoupenRequest({
    this.userId,
    this.source,
    this.msisdn,
    this.coupenCode,
    this.imei,
  });

  int userId;
  String source;
  String msisdn;
  String coupenCode;
  String imei;

  factory CoupenRequest.fromJson(Map<String, dynamic> json) => CoupenRequest(
    userId: json["userId"] == null ? null : json["userId"],
    source: json["source"] == null ? null : json["source"],
    msisdn: json["msisdn"] == null ? null : json["msisdn"],
    coupenCode: json["coupenCode"] == null ? null : json["coupenCode"],
    imei: json["imei"] == null ? null : json["imei"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId == null ? null : userId,
    "source": source == null ? null : source,
    "msisdn": msisdn == null ? null : msisdn,
    "coupenCode": coupenCode == null ? null : coupenCode,
    "imei": imei == null ? null : imei,
  };
}
