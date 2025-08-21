import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static const String _tokenKey = "auth_token";
  static const String _dialogueShown = "is_dialogue_shown";

  /// Save token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);

    //sets dialogue shown to false when a new token is saved
    await prefs.setBool(_dialogueShown, false);
  }

  /// Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Remove token (for logout)
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_dialogueShown);
  }

  /// Set dialog flag
  static Future<void> setDialogShown(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dialogueShown, value);
  }

  /// Get dialog flag
  static Future<bool> isDialogAlreadyShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_dialogueShown) ?? false;
  }
}
