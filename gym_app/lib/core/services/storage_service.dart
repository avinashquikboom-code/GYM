import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // Keys
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserToken = 'user_token';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyActivePlan = 'active_plan';
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  
  // Body Metrics Keys
  static const String _keyWeightStart = 'weight_start';
  static const String _keyWeightCurrent = 'weight_current';
  static const String _keyChest = 'chest';
  static const String _keyWaist = 'waist';
  static const String _keyBiceps = 'biceps';
  static const String _keyBodyFat = 'body_fat';
  static const String _keyMuscleMass = 'muscle_mass';
  static const String _keyBmi = 'bmi';
  static const String _keyWeightHistory = 'weight_history';

  // Theme Persistence
  bool isDarkMode() {
    return _prefs.getBool(_keyThemeMode) ?? true; // Dark mode is default as per image
  }

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(_keyThemeMode, value);
  }

  // Auth Persistence
  bool isLoggedIn() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(_keyIsLoggedIn, value);
  }

  String? getUserToken() {
    return _prefs.getString(_keyUserToken);
  }

  Future<void> setUserToken(String? value) async {
    if (value == null) {
      await _prefs.remove(_keyUserToken);
    } else {
      await _prefs.setString(_keyUserToken, value);
    }
  }

  String getUserName() {
    return _prefs.getString(_keyUserName) ?? 'Rahul Sharma';
  }

  Future<void> setUserName(String value) async {
    await _prefs.setString(_keyUserName, value);
  }

  String getUserEmail() {
    return _prefs.getString(_keyUserEmail) ?? 'rahulsharma@gmail.com';
  }

  Future<void> setUserEmail(String value) async {
    await _prefs.setString(_keyUserEmail, value);
  }

  String getUserPhone() {
    return _prefs.getString(_keyUserPhone) ?? '+91 9876543210';
  }

  Future<void> setUserPhone(String value) async {
    await _prefs.setString(_keyUserPhone, value);
  }

  // Subscription Plan Persistence
  String getActivePlan() {
    return _prefs.getString(_keyActivePlan) ?? 'Premium Plan';
  }

  Future<void> setActivePlan(String value) async {
    await _prefs.setString(_keyActivePlan, value);
  }

  // Body Metrics Methods
  double getWeightStart() => _prefs.getDouble(_keyWeightStart) ?? 75.0;
  Future<void> setWeightStart(double value) => _prefs.setDouble(_keyWeightStart, value);

  double getWeightCurrent() => _prefs.getDouble(_keyWeightCurrent) ?? 68.5;
  Future<void> setWeightCurrent(double value) => _prefs.setDouble(_keyWeightCurrent, value);

  double getChest() => _prefs.getDouble(_keyChest) ?? 98.0;
  Future<void> setChest(double value) => _prefs.setDouble(_keyChest, value);

  double getWaist() => _prefs.getDouble(_keyWaist) ?? 86.0;
  Future<void> setWaist(double value) => _prefs.setDouble(_keyWaist, value);

  double getBiceps() => _prefs.getDouble(_keyBiceps) ?? 32.0;
  Future<void> setBiceps(double value) => _prefs.setDouble(_keyBiceps, value);

  double getBodyFat() => _prefs.getDouble(_keyBodyFat) ?? 22.0;
  Future<void> setBodyFat(double value) => _prefs.setDouble(_keyBodyFat, value);

  double getMuscleMass() => _prefs.getDouble(_keyMuscleMass) ?? 56.0;
  Future<void> setMuscleMass(double value) => _prefs.setDouble(_keyMuscleMass, value);

  double getBmi() => _prefs.getDouble(_keyBmi) ?? 23.4;
  Future<void> setBmi(double value) => _prefs.setDouble(_keyBmi, value);

  // Weight History (format: "timestamp:weight,timestamp:weight")
  List<String> getWeightHistory() {
    return _prefs.getStringList(_keyWeightHistory) ?? [
      '10 May:75.0',
      '15 May:73.8',
      '01 Jun:71.5',
      '15 Jun:69.8',
      '01 Jul:68.5'
    ];
  }

  Future<void> setWeightHistory(List<String> history) async {
    await _prefs.setStringList(_keyWeightHistory, history);
  }

  bool isOnboardingCompleted() {
    return _prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  Future<void> setOnboardingCompleted(bool value) async {
    await _prefs.setBool(_keyOnboardingCompleted, value);
  }

  // Clear Storage
  Future<void> clearAll() async {
    // Keep theme but clear user info
    final theme = isDarkMode();
    final onboarding = isOnboardingCompleted();
    await _prefs.clear();
    await setDarkMode(theme);
    await setOnboardingCompleted(onboarding);
  }
}
