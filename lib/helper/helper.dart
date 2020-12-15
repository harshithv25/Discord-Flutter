import 'package:shared_preferences/shared_preferences.dart';

class HelperFunc {
  static String userLoginKey = 'ISLOGGEDIN';
  static String userNameKey = 'USERNAME';
  static String userEmailKey = 'USEREMAIL';
  static String userImageKey = 'USERIMAGE';

  static Future<bool> saveUserState(bool isLogged) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(userLoginKey, isLogged);
  }

  static Future<bool> saveUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userNameKey, userName);
  }

  static Future<bool> saveUserImage(String image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userImageKey, image);
  }

  static Future<bool> saveUserMail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userEmailKey, email);
  }

  static Future<bool> getUserState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(userLoginKey);
  }

  static Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(userNameKey);
  }

  static Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(userEmailKey);
  }

  static Future<String> getUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(userImageKey);
  }
}
