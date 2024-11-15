import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/src/themes/image.dart';
import 'example.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'register.dart';
import '../providers/session.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // String message = '';
  bool _isobsecure = true;

  // Track if the data is loaded

  Future<Map<String, dynamic>> login(String username, String password) async {
    final Uri url = Uri.parse('http://192.168.1.120:5000/api/user/signin');

    if (username.isEmpty ||
        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(username)) {
      return {'error': 'Invalid username format'};
    }
    if (password.isEmpty || password.length < 6) {
      return {'error': 'Password must be at least 6 characters'};
    }

    final Map<String, String> loginData = {
      'email': username,
      'password': password,
    };

    try {
      final response = await http.post(
        url,
        body: json.encode(loginData),
        headers: {'Content-Type': 'application/json'},
      );

      print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print("Response body: ${response.body}");

        // Check if response body is JSON by examining the content type
        if (response.headers['content-type']?.contains('application/json') ??
            false) {
          return json.decode(response.body); // Parse as JSON
        } else {
          return {'message': response.body}; // Treat as plain text
        }
      } else {
        return {
          'error': 'Failed to login. Status Code: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

  void _handleLogin() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    final response = await login(username, password);
    print("res:$response");

    if (response.containsKey('error')) {
      setState(() {
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
      });
    } else {
      final sessionProvider = Provider.of<SessionProvider>(context, listen: false);

      // Get the token from the response
      // String token = response['token']; // Assuming the token is returned by the API

      // Save token and username in SessionProvider
      sessionProvider.register(username, password); // Pass both the token and username

      // Save token and username in SharedPreferences for persistence
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setString('token', token);
      await prefs.setString('username', username);
      await prefs.setString('password', password);

      setState(() {
        // Show login success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text("Login Successful", style: TextStyle(color: Color(0xffB81736)),),
              actions: [
                TextButton(
                  child: Text("OK", style: TextStyle(color: Color(0xff281537))),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage()),
                    );
                    // Navigator.pushNamed(context, '/homePage');
                  },
                ),
              ],
            );
          },
        );
      });
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   checkIfAlreadyLoggedIn();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // image: DecorationImage(
          //     image: AssetImage(
          //       'assets/images/bg1.jpg',
          //     ),
          //     fit: BoxFit.cover)
          gradient: LinearGradient(
              colors:[
                Color(0xffB81736),
                Color(0xff281537)
              ]
          )
      ),
      child: Scaffold(
        // appBar: AppBar(
        //   // title: Logo(),
        // ),
        backgroundColor: Colors.transparent,
        // appBar: AppBar(title: Text("Login")),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              height: 500,
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset("assets/images/logo_test.jpg", height: 40,width: 40,),
                  // Icon(Icons.youtube_searched_for),
                  Text(
                    "Login To Your Account",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color:Color(0xffB81736)),
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)),
                      hintText: "Enter your email",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(

                    controller: _passwordController,
                    obscureText: _isobsecure,
                    decoration: InputDecoration(
                      prefixIcon: IconButton(onPressed: (){
                        setState(() {
                          _isobsecure = !_isobsecure;

                        });
                      }, icon: Icon(Icons.remove_red_eye_outlined,color:Color(0xffB81736))
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)),
                      hintText: "Enter your password",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed:
                            _handleLogin, // Enable login only when data is loaded
                        child: Text("Login", style: TextStyle(color: Color(0xffB81736)),
                        )),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                        }, // Enable login only when data is loaded
                        child: Text("Are you new user? Register here", style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
