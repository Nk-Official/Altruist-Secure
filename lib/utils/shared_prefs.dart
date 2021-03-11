import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  final SharedPreferences prefs;

//keys need to define here
  var JWT_TOKEN = "JWT_TOKEN";
  var USER_ID = "USER_ID";
  var MSISDN = "MSISDN";
  var ISLOGIN = "ISLOGIN";
  var COUNTRY_ID = "COUNTRY_ID";

  SharedPrefs({this.prefs});

  dynamic getValue(String key, Object defaultValue) {
    if (defaultValue is int) {
      return prefs.getInt(key) == null ? defaultValue : prefs.getInt(key);
    } else if (defaultValue is bool) {
      return prefs.getBool(key) == null ? defaultValue : prefs.getBool(key);
    } else if (defaultValue is String) {
      return prefs.getString(key) == null ? defaultValue : prefs.getString(key);
    }
  }

  setValue(String key, Object value) {
    if (value is int) {
      prefs.setInt(key, value as int);
    } else if (value is bool) {
      prefs.setBool(key, value as bool);
    } else if (value is String) {
      prefs.setString(key, value as String);
    }
  }
}
