// To parse this JSON data, do
//
//     final displayProductsResponseModel = displayProductsResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:altruist_secure_flutter/models/responses/base/StatusDescription.dart';

DisplayProductsResponseModel displayProductsResponseModelFromJson(String str) =>
    DisplayProductsResponseModel.fromJson(json.decode(str));

String displayProductsResponseModelToJson(DisplayProductsResponseModel data) =>
    json.encode(data.toJson());

class DisplayProductsResponseModel {
  StatusDescription statusDescription;
  List<Product> products;

  DisplayProductsResponseModel({
    this.statusDescription,
    this.products,
  });

  factory DisplayProductsResponseModel.fromJson(Map<String, dynamic> json) =>
      DisplayProductsResponseModel(
        statusDescription:
            StatusDescription.fromJson(json["statusDescription"]),
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "statusDescription": statusDescription.toJson(),
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  int id;
  String productId;
  String productName;
  String productDisplayName;
  String price;
  String validity;
  String status;
  String packType;
  String gracePeriod;
  String countryId;
  String operatorCode;
  String operatorName;
  String currency;
  String source;

  Product({
    this.id,
    this.productId,
    this.productName,
    this.productDisplayName,
    this.price,
    this.validity,
    this.status,
    this.packType,
    this.gracePeriod,
    this.countryId,
    this.operatorCode,
    this.operatorName,
    this.currency,
    this.source,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        productId: json["productId"],
        productName: json["productName"],
        productDisplayName: json["productDisplayName"],
        price: json["price"],
        validity: json["validity"],
        status: json["status"],
        packType: json["packType"],
        gracePeriod: json["gracePeriod"],
        countryId: json["countryId"],
        operatorCode: json["operatorCode"],
        operatorName: json["operatorName"],
        currency: json["currency"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "productName": productName,
        "productDisplayName": productDisplayName,
        "price": price,
        "validity": validity,
        "status": status,
        "packType": packType,
        "gracePeriod": gracePeriod,
        "countryId": countryId,
        "operatorCode": operatorCode,
        "operatorName": operatorName,
        "currency": currency,
        "source": source,
      };
}
