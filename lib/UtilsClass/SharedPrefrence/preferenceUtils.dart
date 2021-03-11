import 'dart:async' show Future;
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();
  static SharedPreferences _prefs;
  static SharedPreferences _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance;
  }

  static String getString(String key) {
    return  _prefsInstance == null
        ? null
        : _prefsInstance.getString(key) ?? "" ?? "";
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;
    return prefs?.setString(key, value) ?? Future.value(false);
  }


  static Future<bool> setInteger(String key, int value) async {
    var prefs = await _instance;
    return prefs?.setInt(key, value) ?? Future.value(false);
  }

  static int getInteger(String key) {
    return  _prefsInstance == null
        ? null
        : _prefsInstance.getInt(key) ?? "" ?? "";
  }
  static void mClearPre(){
    _prefsInstance.clear();
  }


}
