import 'package:shared_preferences/shared_preferences.dart';

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

  // Future<void> setLoginDoneBool(bool value) async {
  //   await _storage?.setBool(LocalStorageKeys.isLoggedIn, value);
  // }

  // bool? getLoginDoneBool() {
  //   return _storage?.getBool(LocalStorageKeys.isLoggedIn);
  // }

  Future<void> setLoginSkippedBool(bool value) async {
    await _storage?.setBool(LocalStorageKeys.skippedDone, value);
  }

  bool? getLoginSkippedBool() {
    return _storage?.getBool(LocalStorageKeys.skippedDone);
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

  // Future<void> setProfilePhoto(String value) async {
  //   await _storage?.setString(LocalStorageKeys.profilePhoto, value);
  // }

  // String? getProfilePhoto() {
  //   return _storage?.getString(LocalStorageKeys.profilePhoto);
  // }

  Future<void> setDefaultHomePage(String value) async {
    await _storage?.setString(LocalStorageKeys.defaultHomePage, value);
  } //"Home", "Live TV", "Articles"

  String? getDefaultHomePage() {
    return _storage?.getString(LocalStorageKeys.defaultHomePage);
  }
}

class LocalStorageKeys {
  // static const isLoggedIn = 'isLoggedIn_key';
  static const skippedDone = 'skippedDone_key';
  static const isOnboading = 'isOnboading_key';
  static const country = 'country_key';
  static const language = 'language_key';
  static const profilePhoto = 'language_key';
  static const defaultHomePage = 'default_home_page';
}
