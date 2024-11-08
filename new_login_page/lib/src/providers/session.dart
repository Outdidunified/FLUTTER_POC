import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SessionProvider extends ChangeNotifier {
  String _token = '';
  String _username = '';

  String get token => _token;
  String get username => _username;

  SessionProvider() {
    _loadSession(); // Load session data at initialization
  }

  Future<void> _loadSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // _token = prefs.getString('token') ?? '';
    _username = prefs.getString('username') ?? ''; // Load username
    notifyListeners();
  }

  void register(String token, String username) {
    // _token = token;
    _username = username;
    notifyListeners();
  }

  Future<void> logout() async {
    _token = '';
    _username = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove('token');
    await prefs.remove('username'); // Clear username on logout
    notifyListeners();
  }
}
