import 'dart:convert';

import 'package:crypto/crypto.dart';

class HashCalculator {
  static String salt = "54IzSRi";

  static String hashCompose(String hashSequence) {
    hashSequence = hashSequence.trim();
    String hashString = hashSequence;
    hashString = hashString + "|" + salt;
    String hash = hashCalc(hashString);
//    String hash = hashCal("SHA-512", hashString);
    return hash;
  }

  static String hashCalc(String hashString) {
    Digest sha512Result;
    try {
      var bytes = utf8.encode(hashString); // data being hashed
      sha512Result = sha512.convert(bytes);
      return "" + sha512Result.toString();
    } on Exception catch (e) {
      print("Error in conversion");
    }
  }
}
