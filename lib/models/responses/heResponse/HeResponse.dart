import 'dart:convert';

HeResponse heResponseFromJson(String str) => HeResponse.fromJson(json.decode(str));

String heResponseToJson(HeResponse data) => json.encode(data.toJson());

class HeResponse {
    HeResponse({
        this.status,
        this.heUrl,
    });

    bool status;
    String heUrl;

    factory HeResponse.fromJson(Map<String, dynamic> json) => HeResponse(
        status: json["status"] == null ? null : json["status"],
        heUrl: json["heUrl"] == null ? null : json["heUrl"],
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "heUrl": heUrl == null ? null : heUrl,
    };
}
