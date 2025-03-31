import 'package:shared_preferences/shared_preferences.dart';

/*
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
*/

class SharedPrefService {
  static final SharedPrefService _instance = SharedPrefService._internal();
  static SharedPreferences? _storage;

  factory SharedPrefService() {
    return _instance;
  }

  SharedPrefService._internal();

  static Future<void> init() async {
    _storage ??= await SharedPreferences.getInstance();
  }

  Future<void> clearAllPref() async {
    bool? isOnboardingDone = _storage?.getBool(LocalStorageKeys.isOnboading);

    await _storage?.clear(); // Clears all stored data

    // Restore only the onboarding status
    if (isOnboardingDone != null) {
      await _storage?.setBool(LocalStorageKeys.isOnboading, isOnboardingDone);
    }
  }

  Future<void> setLoginDoneBool(bool value) async {
    await _storage?.setBool(LocalStorageKeys.isLoggedIn, value);
  }

  bool? getLoginDoneBool() {
    return _storage?.getBool(LocalStorageKeys.isLoggedIn);
  }

  Future<void> setSkippedBool(bool value) async {
    await _storage?.setBool(LocalStorageKeys.isLoggedIn, value);
  }

  bool? getSkippedBool() {
    return _storage?.getBool(LocalStorageKeys.isLoggedIn);
  }

  Future<void> setOnboadingDoneBool(bool value) async {
    await _storage?.setBool(LocalStorageKeys.isOnboading, value);
  }

  bool? getOnboadingDoneBool() {
    return _storage?.getBool(LocalStorageKeys.isOnboading);
  }

  Future<void> setLanguage(List<String> value) async {
    await _storage?.setStringList(LocalStorageKeys.language, value);
  }

  List<String>? getLanguage() {
    return _storage?.getStringList(LocalStorageKeys.language);
  }

  Future<void> setCounty(List<String> value) async {
    await _storage?.setStringList(LocalStorageKeys.country, value);
  }

  List<String>? getCounty() {
    return _storage?.getStringList(LocalStorageKeys.country);
  }

  Future<void> setProfilePhoto(String value) async {
    await _storage?.setString(LocalStorageKeys.profilePhoto, value);
  }

  String? getProfilePhoto() {
    return _storage?.getString(LocalStorageKeys.profilePhoto);
  }
}

class LocalStorageKeys {
  static const isLoggedIn = 'isLoggedIn_key';
  static const isOnboading = 'isOnboading_key';
  static const country = 'country_key';
  static const language = 'language_key';
  static const profilePhoto = 'language_key';
}
