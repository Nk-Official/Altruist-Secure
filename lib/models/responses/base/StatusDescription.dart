class StatusDescription {
  int errorCode;
  String errorMessage;

  StatusDescription({
    this.errorCode,
    this.errorMessage,
  });

  factory StatusDescription.fromJson(Map<String, dynamic> json) =>
      StatusDescription(
        errorCode: json["errorCode"],
        errorMessage: json["errorMessage"],
      );

  Map<String, dynamic> toJson() => {
        "errorCode": errorCode,
        "errorMessage": errorMessage,
      };
}
