import 'dart:convert';

UnSubscriptionResponse unSubscriptionResponseFromJson(String str) => UnSubscriptionResponse.fromJson(json.decode(str));

String unSubscriptionResponseToJson(UnSubscriptionResponse data) => json.encode(data.toJson());

class UnSubscriptionResponse {
  UnSubscriptionResponse({
    this.statusDescription,
  });

  StatusDescription statusDescription;

  factory UnSubscriptionResponse.fromJson(Map<String, dynamic> json) => UnSubscriptionResponse(
    statusDescription: json["statusDescription"] == null ? null : StatusDescription.fromJson(json["statusDescription"]),
  );

  Map<String, dynamic> toJson() => {
    "statusDescription": statusDescription == null ? null : statusDescription.toJson(),
  };
}

class StatusDescription {
  StatusDescription({
    this.errorCode,
    this.errorMessage,
  });

  int errorCode;
  String errorMessage;

  factory StatusDescription.fromJson(Map<String, dynamic> json) => StatusDescription(
    errorCode: json["errorCode"] == null ? null : json["errorCode"],
    errorMessage: json["errorMessage"] == null ? null : json["errorMessage"],
  );

  Map<String, dynamic> toJson() => {
    "errorCode": errorCode == null ? null : errorCode,
    "errorMessage": errorMessage == null ? null : errorMessage,
  };
}
