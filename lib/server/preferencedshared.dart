import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String userIdKey = 'USERKEY';
  static String userNameKey = 'USERNAME';
  static String userEmailKey = 'USEREMAILKEY';
  static String userPicKey = 'USERPICKEY';
  static String displayNameKey = 'USERDISPLAYNAME';

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(userIdKey, getUserId);
  }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(userNameKey, getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(userEmailKey, getUserEmail);
  }

  Future<bool> saveUserPicKey(String getUserPicKey) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(userPicKey, getUserPicKey);
  }

  Future<bool> saveUserDisplayName(String getUserDisplayName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(displayNameKey, getUserDisplayName);
  }

  Future<String?> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userIdKey);
  }

  Future<String?> getUserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userNameKey);
  }

  Future<String?> getUserDisplayName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(displayNameKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userEmailKey);
  }

  Future<String?> getUserPicKey() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userPicKey);
  }
}
