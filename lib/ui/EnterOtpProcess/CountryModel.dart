import 'package:meta/meta.dart';

class CountryModel {
  int id;
  String countryName;
  String countryCode;
  bool status;
  int mobileNumberLength;
  String policyWordingLink;

  CountryModel({
    @required this.id,
    @required this.countryName,
    @required this.countryCode,
    @required this.status,
    @required this.mobileNumberLength,
    @required this.policyWordingLink,
  });
}
