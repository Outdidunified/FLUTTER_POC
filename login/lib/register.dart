import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'example.dart';
// import 'main.dart';
import 'session.dart';
import 'package:provider/provider.dart';
import 'login.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usercontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _mailcontroller = TextEditingController();
  final TextEditingController _numbercontroller = TextEditingController();

  Future<Map<String, dynamic>> register(String username, String password, String email, String phoneNumber) async {
    final Uri url = Uri.parse('http://192.168.1.28:5000/signup');

    // Basic validation checks
    if (username.isEmpty) {
      return {'error': 'Username is required'};
    }
    if (password.isEmpty || password.length < 6) {
      return {'error': 'Password must be at least 6 characters'};
    }
    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return {'error': 'Invalid email format'};
    }

    // Remove non-digit characters from phone number and validate it
    phoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (phoneNumber.isEmpty || phoneNumber.length != 10) {
      return {'error': 'Phone number must be exactly 10 digits'};
    }

    // final sessionProvider = Provider.of<SessionProvider>(context, listen: false);

    final Map<String, String> registerData = {
      'username': username,
      'password': password,
      'email': email,
      'phoneNumber': phoneNumber,
    };

    print("registerData: $registerData");

    try {
      final response = await http.post(
        url,
        body: json.encode(registerData),
        headers: {'Content-Type': 'application/json'},
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.headers['content-type']?.contains('application/json') ?? false) {
          return json.decode(response.body); // Parse as JSON
        } else {
          return {'message': response.body}; // Treat as plain text
        }
      } else {
        return {
          'error': 'Failed to register. Status Code: ${response.statusCode}, Response: ${response.body}'
        };
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }


  void _handleRegister() async {
    String username = _usercontroller.text;
    String password = _passwordcontroller.text;
    String email = _mailcontroller.text;
    String phoneNumber = _numbercontroller.text;

    // Print and validate token before making the request


    final response = await register(username, password, email, phoneNumber);

    if (response.containsKey('error')) {
      // Show error dialog, but don't clear the text fields

      _showDialog("Registration Failed", response['error']
      );
    } else {
      // final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
      // Print and validate token before making the request


      _showDialog("Registration Successful", "Welcome, $username!");
      Navigator.push(context, MaterialPageRoute(builder: (content)=>LoginPage()));

      // Navigate to the next page only on successful registration
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomePage(username: username)),
      // );
    }
  }


  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog and stay on the same page
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/bg1.jpg', ),
            fit: BoxFit.cover
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: AppBar(
        //   title: Text("Registration Page"),
        // ),
        body: Center(
          child: Container(
            width: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Registration Page", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),),
                SizedBox(height: 40,),
                TextField(
                  controller: _usercontroller,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)),
                      hintText: "username"),
                ),
                SizedBox(height: 20),
                TextField(

                  controller: _passwordcontroller,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)),
                      hintText: "password"),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _mailcontroller,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)),
                      hintText: "email"),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _numbercontroller,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)),
                      hintText: "phoneNumber"),
                ),
                SizedBox(height: 20),
                ElevatedButton(onPressed: _handleRegister, child: Text("Register"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
