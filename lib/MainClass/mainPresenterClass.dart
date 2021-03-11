import 'package:altruist_secure_flutter/UtilsClass/SharedPrefrence/preferenceUtils.dart';
import 'package:altruist_secure_flutter/UtilsClass/Util/Util.dart';
import 'package:flutter/material.dart';

class MainClass extends StatelessWidget {
  //    if(PreferenceUtils.getString(Utils.BackIDProof)){
//
//    }
  @override
  Widget build(BuildContext context) {
//    if(PreferenceUtils.getString(Utils.BackIDProof)){
//
//    }
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: new Container(
          height: double.infinity, width: double.infinity, child: _status()),
    );
  }

  Widget _status() {
    var PackageName = PreferenceUtils.getString(Utils.appPackageName);
    if (PackageName == "com.insurance.atpl.altruist_secure_flutter" || PackageName == "com.insurance.altruistSecureFlutter") {
      return Image.asset('splash_screen_altruist_secure_ghana.jpg',
          fit: BoxFit.cover);
    } else if (PackageName == "com.r3factory" ||
        PackageName == "com.insurance.altruistSecureR3") {
      return Image.asset('splash_screen.png', fit: BoxFit.cover);
    } else if (PackageName == "com.app.noon_secure" ||
        PackageName == "com.insurance.noonSecure") {
      return Image.asset('splash_screen_noon_secure.png', fit: BoxFit.cover);
    } else if (PackageName == "com.app.airtel_tigo_secure") {
      return Image.asset('splash_screen_airteltigo_secure.png',
          fit: BoxFit.cover);
    } else if (PackageName == "com.app.mansardecure_secure") {
      return Padding(
          padding: EdgeInsets.all(30),
          child: Image.asset('splash_screen_mansard_secure.png',
              width: 100, height: 100));
    } else if (PackageName == "com.app.altruists_secure_bangla" || PackageName == "com.app.altruists-secure-bangla") {
      return Image.asset('splash_screen_altruist_secure.png',
          fit: BoxFit.cover);
    } else {
      return Image.asset('splash_screen_altruist_secure.png',
          fit: BoxFit.cover);
    }
  }
}
