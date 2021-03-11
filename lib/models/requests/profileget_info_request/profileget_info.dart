// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

ProfileGetInfo welcomeFromJson(String str) => ProfileGetInfo.fromJson(json.decode(str));

String profileGetInfoToJson(ProfileGetInfo data) => json.encode(data.toJson());

class ProfileGetInfo {
  ProfileGetInfo({
    this.userId,
  });

  int userId;

  factory ProfileGetInfo.fromJson(Map<String, dynamic> json) => ProfileGetInfo(
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
  };
}
