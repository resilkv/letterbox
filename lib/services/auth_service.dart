import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  final String baseUrl = 'http://10.0.2.2:8000/api'; // your Django API base URL

  String? token;
  String? refreshToken;
  Map<String, dynamic>? user;

  bool get isAuthenticated => token != null && user != null;

  // ✅ Load saved user data when app starts
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');
    final savedRefresh = prefs.getString('refresh');
    final savedUser = prefs.getString('user');

    if (savedToken != null && savedUser != null) {
      token = savedToken;
      refreshToken = savedRefresh;
      user = jsonDecode(savedUser);
      notifyListeners();
      debugPrint("✅ Loaded user from storage: ${user!['username']}");
    } else {
      debugPrint("⚠️ No saved user found");
    }
  }

  // ✅ Login and save data to provider + local storage
  Future<dynamic> login(String username, String password) async {
    try {
      final url = Uri.parse("$baseUrl/login/");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      debugPrint(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();

        token = data['data']['access'] ?? '';
        refreshToken = data['data']['refresh'] ?? '';
        user = data['data']['user'];

        // ✅ Save in local storage
        await prefs.setString("token", token!);
        await prefs.setString("refresh", refreshToken!);
        await prefs.setString("user", jsonEncode(user));

        notifyListeners();
        return true;
      } else {
        final err = jsonDecode(response.body);
        return err['detail'] ?? "Login failed";
      }
    } catch (e) {
      debugPrint("❌ Login error: $e");
      return "An error occurred";
    }
  }

  // ✅ Signup (optional)
  Future<String?> signUp(Map<String, dynamic> userData) async {
    try {
      final url = Uri.parse('$baseUrl/signup/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        token = data['token'];
        user = data['data'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token!);
        await prefs.setString("user", jsonEncode(user));

        notifyListeners();
        return null; // Success
      } else {
        final errorData = jsonDecode(response.body);
        if (errorData.containsKey('password')) {
          return errorData['password'][0];
        } else if (errorData.containsKey('non_field_errors')) {
          return errorData['non_field_errors'][0];
        } else {
          return 'Signup failed. Please check your information.';
        }
      }
    } catch (e) {
      return 'Network error: $e';
    }
  }

  // ✅ Logout
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    token = null;
    refreshToken = null;
    user = null;

    notifyListeners();
  }
}
