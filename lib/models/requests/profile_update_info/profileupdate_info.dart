// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

ProfileUpdateRequest welcomeFromJson(String str) => ProfileUpdateRequest.fromJson(json.decode(str));

String welcomeToJson(ProfileUpdateRequest data) => json.encode(data.toJson());

class ProfileUpdateRequest {
  ProfileUpdateRequest({
    this.userId,
    this.address,
    this.alternativeNumber,
    this.email,
    this.dob,
    this.gender,
  });

  int userId;
  String address;
  String alternativeNumber;
  String email;
  String dob;
  String gender;

  factory ProfileUpdateRequest.fromJson(Map<String, dynamic> json) => ProfileUpdateRequest(
    userId: json["userId"],
    address: json["address"],
    alternativeNumber: json["alternativeNumber"],
    email: json["email"],
    dob: json["dob"],
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "address": address,
    "alternativeNumber": alternativeNumber,
    "email": email,
    "dob": dob,
    "gender": gender,
  };
}
