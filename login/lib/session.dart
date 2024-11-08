import 'package:flutter/material.dart';

class SessionProvider with ChangeNotifier {
  String? _token;

  String? get token => _token;
  // Method to set the session token after successful registration or login
  void register(String token) {
    _token = token;
    notifyListeners();
  }

  // Method to clear the session data on logout
  void logout() {
    _token = null;
    notifyListeners();
  }

  bool get isLoggedIn => _token != null;
}
