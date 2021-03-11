import 'dart:convert';
import 'package:altruist_secure_flutter/models/responses/base/StatusDescription.dart';
import 'devicedetailsuploads.dart';

class Acb {
  StatusDescription statusDescription;
  DeviceDetailsUploads deviceDetailsUploads;

  Acb({
  this.statusDescription,
  this.deviceDetailsUploads,
  });

  Acb.fromJson(Map<String, dynamic>  map) :
        statusDescription = map['statusDescription'] == null
            ? null
            : StatusDescription.fromJson(map['statusDescription']),
        deviceDetailsUploads = map['deviceDetailsUploads'] == null
            ? null
            : DeviceDetailsUploads.fromJson(map['deviceDetailsUploads']);

  Map<String, dynamic> toJson() => {
        'statusDescription': statusDescription.toJson(),
        'deviceDetailsUploads': deviceDetailsUploads.toJson(),
      };

  Acb copyWith({
    StatusDescription statusDescription,
    DeviceDetailsUploads deviceDetailsUploads,
  }) {
    return Acb(
      statusDescription: statusDescription ?? this.statusDescription,
      deviceDetailsUploads: deviceDetailsUploads ?? this.deviceDetailsUploads,
    );
  }
}

