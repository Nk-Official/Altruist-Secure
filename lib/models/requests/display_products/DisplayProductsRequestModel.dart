// To parse this JSON data, do
//
//     final displayProductsRequestModel = displayProductsRequestModelFromJson(jsonString);

import 'dart:convert';

DisplayProductsRequestModel displayProductsRequestModelFromJson(String str) =>
    DisplayProductsRequestModel.fromJson(json.decode(str));

String displayProductsRequestModelToJson(DisplayProductsRequestModel data) =>
    json.encode(data.toJson());

class DisplayProductsRequestModel {
  int userId;
  String source;

  DisplayProductsRequestModel({
    this.userId,
    this.source,
  });

  factory DisplayProductsRequestModel.fromJson(Map<String, dynamic> json) =>
      DisplayProductsRequestModel(
        userId: json["userId"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "source": source,
      };
}
