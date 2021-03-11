import 'dart:convert';

HeInfoResponse heInfoResponseFromJson(String str) => HeInfoResponse.fromJson(json.decode(str));

String heInfoResponseToJson(HeInfoResponse data) => json.encode(data.toJson());

class HeInfoResponse {
  HeInfoResponse({
    this.imei,
    this.msisdn,
  });

  String imei;
  String msisdn;

  factory HeInfoResponse.fromJson(Map<String, dynamic> json) => HeInfoResponse(
    imei: json["imei"] == null ? null : json["imei"],
    msisdn: json["msisdn"] == null ? null : json["msisdn"],
  );

  Map<String, dynamic> toJson() => {
    "imei": imei == null ? null : imei,
    "msisdn": msisdn == null ? null : msisdn,
  };
}
