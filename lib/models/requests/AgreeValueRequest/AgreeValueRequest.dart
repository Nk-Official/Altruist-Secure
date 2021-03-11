import 'dart:convert';
AgreeRequest agreeRequestFromJson(String str) => AgreeRequest.fromJson(json.decode(str));
String agreeRequestToJson(AgreeRequest data) => json.encode(data.toJson());
class AgreeRequest {
  AgreeRequest({
    this.countryId,
    this.invoiceAmount,
    this.invoiceDate,
  });
  String countryId;
  int invoiceAmount;
  String invoiceDate;
  factory AgreeRequest.fromJson(Map<String, dynamic> json) => AgreeRequest(
    countryId: json["countryId"] == null ? null : json["countryId"],
    invoiceAmount: json["invoiceAmount"] == null ? null : json["invoiceAmount"],
    invoiceDate: json["invoiceDate"] == null ? null : json["invoiceDate"],
  );
  Map<String, dynamic> toJson() => {
    "countryId": countryId == null ? null : countryId,
    "invoiceAmount": invoiceAmount == null ? null : invoiceAmount,
    "invoiceDate": invoiceDate == null ? null : invoiceDate,
  };
}
