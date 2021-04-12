import 'package:shared_preferences/shared_preferences.dart';

class helperFunctions {
  static String sharePreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharePreferenceUserNameKey = "USERNAMEKEY";
  static String sharePreferenceUserEmailKey = "USEREMAILKEY";

  //saving data to prefercence
  static Future<bool> saveuserLoggedInSharePreference(
      bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(
        sharePreferenceUserLoggedInKey, isUserLoggedIn);
  }

   static Future<bool> saveuserNameSharePreference(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharePreferenceUserNameKey, userName);
  }

  static Future<bool> saveuserEmailSharePreference(String userEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharePreferenceUserEmailKey, userEmail);
  }

  static Future<bool> getuserLoggedInSharePreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.get(sharePreferenceUserLoggedInKey);
  }

  static Future<String> getuserNameSharePreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharePreferenceUserNameKey);
  }

  static Future<String> getuserEmailSharePreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharePreferenceUserEmailKey);
  }
}
