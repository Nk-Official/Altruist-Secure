import 'dart:convert';

class DeviceDetailsUploads {
  String uploadType;
  int id;
  Long uploadDateTime;
  int userId;
  String status;

  DeviceDetailsUploads({
  this.uploadType = "",
  this.id = 0,
  this.uploadDateTime = null,
  this.userId = 0,
  this.status = "",
  });

  DeviceDetailsUploads.fromJson(Map<String, dynamic>  map) :
        uploadType = map['uploadType']  ?? "",
        id = map['id']  ?? 0,
        userId = map['userId']  ?? 0,
        status = map['status']  ?? "";

  Map<String, dynamic> toJson() => {
        'uploadType': uploadType,
        'id': id,
        'uploadDateTime': uploadDateTime,
        'userId': userId,
        'status': status,
      };

  DeviceDetailsUploads copyWith({
    String uploadType,
    int id,
    Long uploadDateTime,
    int userId,
    String status,
  }) {
    return DeviceDetailsUploads(
      uploadType: uploadType ?? this.uploadType,
      id: id ?? this.id,
      uploadDateTime: uploadDateTime ?? this.uploadDateTime,
      userId: userId ?? this.userId,
      status: status ?? this.status,
    );
  }
}

