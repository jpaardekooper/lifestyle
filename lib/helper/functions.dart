import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static const String sharedPreferenceUserLoggedInKey = "USERLOGGEDINKEY";
  static const String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static const String sharedPreferenceUserEmailKey = "USEREMAILKEY";
  static const String sharedPreferenceUserPassKey = "USERPASSKEY";
  static const String sharedPreferenceDisclaimerKey = "DISCLAIMERKEY";

  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharedPreference(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<void> saveUserEmailSharedPreference(String userEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  static Future<void> saveUserPasswordSharedPreference(String pass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(sharedPreferenceUserPassKey, pass);
  }

  static Future<bool> saveDisclaimerSharedPreference(bool disclaimer) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool(sharedPreferenceDisclaimerKey, disclaimer);
  }

  /// This is awesome

  static Future<bool> getUserLoggedInSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String> getUserNameSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserNameKey);
  }

  static Future<String> getUserEmailSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserEmailKey);
  }

  static Future<String> getUserPasswordSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserPassKey);
  }

  static Future<bool> getDisclaimerSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPreferenceDisclaimerKey);
  }
}
