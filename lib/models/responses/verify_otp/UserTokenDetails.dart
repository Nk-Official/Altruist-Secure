class UserTokenDetails {
  String jwtToken;
  String jwtRefreshToken;
  String jwtTokenExpiryDateTime;
  String jwtRefreshTokenExpiryDateTime;


  UserTokenDetails({
    this.jwtToken,
    this.jwtRefreshToken,
    this.jwtTokenExpiryDateTime,
    this.jwtRefreshTokenExpiryDateTime,
  });

  factory UserTokenDetails.fromJson(Map<String, dynamic> json) =>
      UserTokenDetails(
        jwtToken: json["jwtToken"],
        jwtRefreshToken: json["jwtRefreshToken"],
        jwtTokenExpiryDateTime: json["jwtTokenExpiryDateTime"],
        jwtRefreshTokenExpiryDateTime: json["jwtRefreshTokenExpiryDateTime"],
      );

  Map<String, dynamic> toJson() => {
        "jwtToken": jwtToken,
        "jwtRefreshToken": jwtRefreshToken,
        "jwtTokenExpiryDateTime": jwtTokenExpiryDateTime,
        "jwtRefreshTokenExpiryDateTime": jwtRefreshTokenExpiryDateTime,
      };
}
