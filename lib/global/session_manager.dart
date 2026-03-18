import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const _isKeepSigned = 'isKeepSigned';
  String kUserName = 'kUserName';
  String kPassword = 'kPassword';

  Future<void> setKeepSignedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_isKeepSigned, isLoggedIn);
  }

  Future<bool> getKeepSignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isKeepSigned) ?? false;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
