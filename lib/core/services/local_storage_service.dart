import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static Future<void> save(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> get(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(key);
    if (username == null) return null;
    return username;
  }

  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
