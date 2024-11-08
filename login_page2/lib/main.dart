import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'example.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  List<Map<String, String>> _users = [];
  bool _isDataLoaded = false; // Track if the data is loaded

  @override
  void initState() {
    super.initState();
    _loadUserData();  // Load the user data when the app starts
  }

  // Load user data from JSON file
  Future<void> _loadUserData() async {
    try {
      // Load the JSON file from assets
      final jsonData = await rootBundle.rootBundle.loadString('assets/user_data.json');
      List<dynamic> data = jsonDecode(jsonData);
   print("userdata : $jsonData");
      // Convert JSON data to a List<Map<String, String>> with String values only
      setState(() {
        _users = data.map((e) {
          return {
            'username': e['username'].toString(),
            'password': e['password'].toString(),
          };
        }).toList();
        _isDataLoaded = true;  // Mark data as loaded
      });

      print("Loaded user data from JSON: $_users");
    } catch (e) {
      print("Error loading JSON data: $e");
    }
  }

  // Validate user credentials
  void _login() {
    if (!_isDataLoaded) {
      // Show loading message or prevent login attempt if data isn't loaded yet
      return;
    }

    String username = _usernameController.text.trim(); // Trim whitespace
    String password = _passwordController.text.trim(); // Trim whitespace

    // Check if any user has the entered username and password
    bool isValid = _users.any((user) =>
    user['username']!.toLowerCase() == username.toLowerCase() &&
        user['password']!.toLowerCase() == password.toLowerCase()
    );

    if (isValid) {
      // Navigate to HomePage if login is successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(username: username)), // Pass the username here
      );
    } else {
      // Show error dialog if login fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Failed"),
            content: Text("Invalid username or password."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            height: 500,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11)

                    ),
                    hintText: "Enter your username",
                      labelText: "Username"
                  ),
                ),
                SizedBox(height: 20,),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11)
                    ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)

                      ),
                    hintText: "enter your password",
                      labelText: "Password"),
                  obscureText: true,
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: _isDataLoaded ? _login : null, // Enable login only when data is loaded
                  child: Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

