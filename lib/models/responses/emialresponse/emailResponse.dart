import 'dart:convert';

EmailResponce emailRespose(String str) => EmailResponce.fromJson(json.decode(str));

String welcomeToJson(EmailResponce data) => json.encode(data.toJson());

class EmailResponce {
  EmailResponce({
    this.errorCode,
    this.errorMessage,
  });

  int errorCode;
  String errorMessage;

  factory EmailResponce.fromJson(Map<String, dynamic> json) => EmailResponce(
    errorCode: json["errorCode"],
    errorMessage: json["errorMessage"],
  );

  Map<String, dynamic> toJson() => {
    "errorCode": errorCode,
    "errorMessage": errorMessage,
  };
}
