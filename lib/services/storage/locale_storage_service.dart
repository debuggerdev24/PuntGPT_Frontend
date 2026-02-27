import 'package:shared_preferences/shared_preferences.dart';

class LocaleStorageService {
  LocaleStorageService._();

  static late SharedPreferences _pref;
  static Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static const String _accessTokenKey = "user_token";
  static const String _refreshTokenKey = "user_refresh_token";
  static const String _isUserLoggedInKey = "is_user_logged_in";
  static const String _loggedInUserEmailKey = "logged_in_user_email";
  static const String _loggedInUserNameKey = "logged_in_user_name";
  static const String _loggedInUserPasswordKey = "logged_in_user_password";
  static const String _loggedInCustomerEmailKey = "logged_in_user_email";
  static const String _loggedInCustomerPasswordKey = "logged_in_user_password";
  static const String _registerUserId = "register_user_id";
  static const String _isProfileCreated = "is_profile_created";
  static const String _isFirstTime = "is_First_Time";

  static bool get isUserLoggedIn => _pref.getBool(_isUserLoggedInKey) ?? false;
  static Future<void> setIsUserLoggedIn({bool value = true}) async =>
      await _pref.setBool(_isUserLoggedInKey, value);

  // save and get the user auth token
  static String get userToken => _pref.getString(_accessTokenKey) ?? "";
  static Future<void> saveUserToken(String value) async =>
      await _pref.setString(_accessTokenKey, value);
  static Future<void> removeAccessToken() async {
    await _pref.remove(_accessTokenKey);
  }

  static Future<void> removeRefreshToken() async {
    await _pref.remove(_refreshTokenKey);
  }

  // get logged in user email and password
  static String get loggedInUserEmail =>
      _pref.getString(_loggedInUserEmailKey) ?? '';
  static Future<void> setLoggedInUserEmail(String value) async =>
      await _pref.setString(_loggedInUserEmailKey, value);

  // get logged in user name
  static String get loggedInUserName =>
      _pref.getString(_loggedInUserNameKey) ?? '';
  static Future<void> setLoggedInUserName(String value) async =>
      await _pref.setString(_loggedInUserNameKey, value);

  static String get loggedInUserPassword =>
      _pref.getString(_loggedInUserPasswordKey) ?? '';
  static Future<void> setLoggedInUserPassword(String value) async =>
      await _pref.setString(_loggedInUserPasswordKey, value);

  static bool get isFirstTime => _pref.getBool(_isFirstTime) ?? true;
  static Future<void> setIsFirstTime(bool value) async =>
      await _pref.setBool(_isFirstTime, value);

  //todo register customer id
  static String get userId => _pref.getString(_registerUserId) ?? '';
  static Future<void> saveUserId(String value) async =>
      await _pref.setString(_registerUserId, value);

  //todo save and get the user refresh auth token
  static String get refreshToken => _pref.getString(_refreshTokenKey) ?? '';
  static Future<void> saveUserRefreshToken(String value) async =>
      await _pref.setString(_refreshTokenKey, value);

  //todo get logged in customer email and password
  static String get loggedInCustomerEmail =>
      _pref.getString(_loggedInCustomerEmailKey) ?? '';
  static Future<void> setLoggedInCustomerEmail(String value) async =>
      await _pref.setString(_loggedInCustomerEmailKey, value);
  static String get loggedInCustomerPassword =>
      _pref.getString(_loggedInCustomerPasswordKey) ?? '';
  static Future<void> setLoggedInCustomerPassword(String value) async =>
      await _pref.setString(_loggedInCustomerPasswordKey, value);

  //todo check is profile crested or not.
  static bool get profileCreated => _pref.getBool(_isProfileCreated) ?? false;
  static Future<void> setProfileCreated(bool value) async =>
      await _pref.setBool(_isProfileCreated, value);

  static Future<void> clearUserTokens() async {
    await _pref.remove(_accessTokenKey);
    await _pref.remove(_refreshTokenKey);
  }
}
