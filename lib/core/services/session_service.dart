import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valarpay/features/models/login.dart';
import 'package:valarpay/features/models/user.dart';

class SessionService {
  static const String _userKey = 'user_session';
  static const String _tokenKey = 'auth_token';
  static const String _usernameKey = 'username';
  static const String _userFullnameKey = 'user_fullname';

  // Save login session
  static Future<void> saveSession(LoginResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(response.user.toJson()));
    await prefs.setString(_usernameKey, response.user.email);
    await prefs.setString(_userFullnameKey, response.user.fullname);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_usernameKey);
    if (username == null) return null;
    return username;
  }

  static Future<String?> getUserFullname() async {
    final prefs = await SharedPreferences.getInstance();
    final userFullname = prefs.getString(_userFullnameKey);
    if (userFullname == null) return null;
    return userFullname;
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson));
  }

  static Future<bool> isLoggedIn() async {
    final user = await getUser();
    return user != null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  Future<void> checkSession(BuildContext context) async {
    final loggedIn = await SessionService.isLoggedIn();
    if (loggedIn) {
      context.push('/'); // go to home
    } else {
      if (await SessionService.getUsername() != null) {
        context.push('/biometric-login');
      } else {
        context.pushReplacement('/signin');
      }
    }
  }
}
