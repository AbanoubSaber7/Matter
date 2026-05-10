// lib/config/api_keys.dart
import 'package:shared_preferences/shared_preferences.dart';

class ApiKeys {
  static const String _geminiKeyPref = 'gemini_api_key';

  // Cached key loaded at startup
  static String _geminiApiKey = '';

  /// The current Gemini API key (empty string if not set)
  static String get geminiApiKey => _geminiApiKey;

  /// Initialize – loads the saved key from SharedPreferences.
  /// Call once at app startup before running the app.
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _geminiApiKey = prefs.getString(_geminiKeyPref) ?? '';
  }

  /// Persist a new API key and update the in-memory cache.
  static Future<void> saveApiKey(String key) async {
    _geminiApiKey = key.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_geminiKeyPref, _geminiApiKey);
  }

  /// Remove the stored API key.
  static Future<void> clearApiKey() async {
    _geminiApiKey = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_geminiKeyPref);
  }
}
