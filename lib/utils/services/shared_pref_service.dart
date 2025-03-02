import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static final SharedPrefService _instance = SharedPrefService._internal();
  factory SharedPrefService() => _instance;
  SharedPrefService._internal();

  late SharedPreferences _prefs;

  /// Initialize SharedPreferences (Call this in `main()`)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save a value
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  /// Retrieve a value
  String? getString(String key) {
    return _prefs.getString(key);
  }

  /// Save a value
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  /// Retrieve a value
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// Remove a key
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  /// Clear all preferences
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
