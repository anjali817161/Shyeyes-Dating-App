import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  // 🔑 Keys
  static const String _tokenKey = "auth_token";
  static const String _dialogueShown = "is_dialogue_shown";
  static const String _userIdKey = "user_id";
  static const String _userNameKey = "user_name";
  static const String _userPicKey = "user_pic";

  /// ✅ Save token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);

    // reset dialogue shown whenever a new token is saved
    await prefs.setBool(_dialogueShown, false);
  }

  /// Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  ///  Remove token + user data (logout)
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_dialogueShown);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userPicKey);
  }

  /// ✅ Save user details
  static Future<void> saveUserId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, id);
  }

  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }

  static Future<void> saveUserPic(String picUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userPicKey, picUrl);
  }

  /// Get user details
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  static Future<String?> getUserPic() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userPicKey);
  }

  ///  Dialog flag
  static Future<void> setDialogShown(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dialogueShown, value);
  }

  static Future<bool> isDialogAlreadyShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_dialogueShown) ?? false;
  }
}
