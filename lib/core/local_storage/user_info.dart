import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {

  // =======Access Token======= //
  static void setAccessToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access', token);
  }

  static Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access');
  }

  // =======Refresh Token======= //
  static void setRefreshToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('refresh', token);
  }

  static Future<String?> getRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh');
  }

  // =======reset token======= //
  static void ResetToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('reset_token', token);
  }

  static Future<String?> getResetToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('reset_token');
  }

//



}