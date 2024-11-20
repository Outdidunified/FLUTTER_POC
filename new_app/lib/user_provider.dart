import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  final String _baseUrl = "http://192.168.1.103:5000/api";
  bool isLoading = false;
  String error = "";
  bool isLoggedIn = false; // Keep track of login state

  Future<void> logIn(String email, String password) async {
    isLoading = true;
    error = "";
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/user/signin"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"]) {
          isLoggedIn = true; // Set to true on successful login
          notifyListeners();
        } else {
          error = data["message"] ?? "Login failed.";
        }
      } else {
        error = "Something went wrong. Please try again.";
      }
    } catch (e) {
      error = "An error occurred: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createAccount(String email, String password, BuildContext context) async {
    isLoading = true;
    error = "";
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/user/createAccount"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"]) {
          // Show success dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Account Created'),
                content: Text('Your account has been successfully created!'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      // Optionally, navigate to the login screen after successful account creation
                      Navigator.pushReplacementNamed(context, "/login");
                    },
                  ),
                ],
              );
            },
          );
        } else {
          error = data["message"] ?? "Signup failed.";
        }
      } else {
        error = "Something went wrong. Please try again.";
      }
    } catch (e) {
      error = "An error occurred: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void logOut() {
    isLoggedIn = false; // Reset login status
    notifyListeners();
  }
}
