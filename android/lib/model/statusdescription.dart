import 'dart:convert';

class StatusDescription {
  String errorMessage;
  int errorCode;

  StatusDescription({
  this.errorMessage = "",
  this.errorCode = 0,
  });

  StatusDescription.fromJson(Map<String, dynamic>  map) :
        errorMessage = map['errorMessage']  ?? "",
        errorCode = map['errorCode']  ?? 0;

  Map<String, dynamic> toJson() => {
        'errorMessage': errorMessage,
        'errorCode': errorCode,
      };

  StatusDescription copyWith({
    String errorMessage,
    int errorCode,
  }) {
    return StatusDescription(
      errorMessage: errorMessage ?? this.errorMessage,
      errorCode: errorCode ?? this.errorCode,
    );
  }
}

