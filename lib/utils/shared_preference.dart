import 'package:shared_preferences/shared_preferences.dart';

abstract class AppShared {

  static SharedPreferences? _prefs;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences _checkPrefs() {
    if (_prefs == null) {
      throw Exception('Please, call AppSharedPreference.init(); before');
    }
    return _prefs!;
  }

  static SharedPreferences get prefs => _checkPrefs();
}
