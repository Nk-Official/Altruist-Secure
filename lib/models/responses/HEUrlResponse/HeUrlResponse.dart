// To parse this JSON data, do
//
//     final heUrlResponse = heUrlResponseFromJson(jsonString);

import 'dart:convert';

HeUrlResponse heUrlResponseFromJson(String str) => HeUrlResponse.fromJson(json.decode(str));

String heUrlResponseToJson(HeUrlResponse data) => json.encode(data.toJson());

class HeUrlResponse {
  HeUrlResponse({
    this.statusCode,
    this.msisdn,
    this.imei,
  });

  int statusCode;
  String msisdn;
  String imei;

  factory HeUrlResponse.fromJson(Map<String, dynamic> json) => HeUrlResponse(
    statusCode: json["statusCode"] == null ? null : json["statusCode"],
    msisdn: json["msisdn"] == null ? null : json["msisdn"],
    imei: json["imei"] == null ? null : json["imei"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode == null ? null : statusCode,
    "msisdn": msisdn == null ? null : msisdn,
    "imei": imei == null ? null : imei,
  };
}
