import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SessionProvider extends ChangeNotifier {
  // String _token = '';
  String _username = '';
  String _password = '';

  // String get token => _token;
  String get username => _username;
  String get password => _password;

  SessionProvider() {
    _loadSession(); // Load session data at initialization
  }

  Future<void> _loadSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // _token = prefs.getString('token') ?? '';
    _username = prefs.getString('username') ?? '';
    _password = prefs.getString('password') ?? ''; // Load username
// Load username
    notifyListeners();
  }

  void register(String token, String username) {
    // _token = token;
    _username = username;
    _password= _password;
    notifyListeners();
  }

  Future<void> logout() async {
    // _token = '';
    _username = '';
    _password='';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove('token');
    await prefs.remove('username');
    await prefs.remove('password'); // Clear username on logout
// Clear username on logout
    notifyListeners();
  }
}

