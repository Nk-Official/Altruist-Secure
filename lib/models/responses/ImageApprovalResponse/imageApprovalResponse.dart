import 'dart:convert';
ImageApprovalResponse imageApprovalResponseFromJson(String str) => ImageApprovalResponse.fromJson(json.decode(str));
String imageApprovalResponseToJson(ImageApprovalResponse data) => json.encode(data.toJson());

class ImageApprovalResponse {
  ImageApprovalResponse({
    this.statusDescription,
    this.imageStatus,
  });

  StatusDescription statusDescription;
  String imageStatus;

  factory ImageApprovalResponse.fromJson(Map<String, dynamic> json) => ImageApprovalResponse(
    statusDescription: json["statusDescription"] == null ? null : StatusDescription.fromJson(json["statusDescription"]),
    imageStatus: json["imageStatus"] == null ? null : json["imageStatus"],
  );

  Map<String, dynamic> toJson() => {
    "statusDescription": statusDescription == null ? null : statusDescription.toJson(),
    "imageStatus": imageStatus == null ? null : imageStatus,
  };
}

class StatusDescription {
  StatusDescription({
    this.errorCode,
    this.errorMessage,
    this.qrCode,
  });

  int errorCode;
  String errorMessage;
  dynamic qrCode;

  factory StatusDescription.fromJson(Map<String, dynamic> json) => StatusDescription(
    errorCode: json["errorCode"] == null ? null : json["errorCode"],
    errorMessage: json["errorMessage"] == null ? null : json["errorMessage"],
    qrCode: json["qrCode"],
  );

  Map<String, dynamic> toJson() => {
    "errorCode": errorCode == null ? null : errorCode,
    "errorMessage": errorMessage == null ? null : errorMessage,
    "qrCode": qrCode,
  };
}
