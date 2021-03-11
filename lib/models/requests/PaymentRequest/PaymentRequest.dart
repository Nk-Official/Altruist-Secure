import 'dart:convert';
PaymentRequest paymentRequestFromJson(String str) => PaymentRequest.fromJson(json.decode(str));

String paymentRequestToJson(PaymentRequest data) => json.encode(data.toJson());

class PaymentRequest {
  PaymentRequest({
    this.userId,
    this.msisdn,
  });

  String userId;
  String msisdn;

  factory PaymentRequest.fromJson(Map<String, dynamic> json) => PaymentRequest(
    userId: json["userId"] == null ? null : json["userId"],
    msisdn: json["msisdn"] == null ? null : json["msisdn"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId == null ? null : userId,
    "msisdn": msisdn == null ? null : msisdn,
  };
}
