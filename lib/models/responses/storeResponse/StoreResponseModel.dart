import 'dart:convert';

StoreResponseModel storeResponseModelFromJson(String str) =>
    StoreResponseModel.fromJson(json.decode(str));

String storeResponseModelToJson(StoreResponseModel data) =>
    json.encode(data.toJson());

class StoreResponseModel {
  StoreResponseModel({
    this.statusDescription,
    this.storeList,
  });

  StatusDescription statusDescription;
  List<StoreList> storeList;

  factory StoreResponseModel.fromJson(Map<String, dynamic> json) =>
      StoreResponseModel(
        statusDescription: json["statusDescription"] == null
            ? null
            : StatusDescription.fromJson(json["statusDescription"]),
        storeList: json["storeList"] == null
            ? null
            : List<StoreList>.from(
            json["storeList"].map((x) => StoreList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "statusDescription":
    statusDescription == null ? null : statusDescription.toJson(),
    "storeList": storeList == null
        ? null
        : List<dynamic>.from(storeList.map((x) => x.toJson())),
  };
}



class StoreList {
  StoreList({
    this.id,
    this.storeName,
    this.storeLocation,
  });

  int id;
  String storeName;
  String storeLocation;

  factory StoreList.fromJson(Map<String, dynamic> json) =>
      StoreList(
        id: json["id"] == null ? null : json["id"],
        storeName: json["storeName"] == null ? null : json["storeName"],
        storeLocation:
        json["storeLocation"] == null ? null : json["storeLocation"],
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id == null ? null : id,
        "storeName": storeName == null ? null : storeName,
        "storeLocation": storeLocation == null ? null : storeLocation,
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

  factory StatusDescription.fromJson(Map<String, dynamic> json) =>
      StatusDescription(
        errorCode: json["errorCode"] == null ? null : json["errorCode"],
        errorMessage:
        json["errorMessage"] == null ? null : json["errorMessage"],
        qrCode: json["qrCode"],
      );

  Map<String, dynamic> toJson() => {
    "errorCode": errorCode == null ? null : errorCode,
    "errorMessage": errorMessage == null ? null : errorMessage,
    "qrCode": qrCode,
  };
}