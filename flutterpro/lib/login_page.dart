import 'package:flutter/material.dart';
import 'notes_page.dart';
import 'dart:math';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final emailText = TextEditingController();
  final passText = TextEditingController();
  String? _emailError;
  bool _isPasswordVisible = false;

  late AnimationController _backgroundController;
  late AnimationController _buttonController;
  late AnimationController _dialogController;
  late AnimationController _eyeController;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _dialogController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      lowerBound: 0.7,
      upperBound: 1.0,
    );

    _eyeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    emailText.dispose();
    passText.dispose();
    _backgroundController.dispose();
    _buttonController.dispose();
    _dialogController.dispose();
    _eyeController.dispose();
    super.dispose();
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _showAlertDialog(String title, String message) {
    _dialogController.forward().then((_) => _dialogController.reverse());
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ScaleTransition(
          scale: _dialogController,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _resetState() {
    setState(() {
      emailText.clear();
      passText.clear();
      _emailError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _resetState(); // Reset state when back is pressed
        return true; // Allow pop
      },
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _backgroundController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple,
                    Colors.teal.withOpacity(0.8),
                    Colors.pink,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [
                    0.2 + 0.1 * sin(_backgroundController.value * 2 * pi),
                    0.6 + 0.1 * cos(_backgroundController.value * 2 * pi),
                    1.0,
                  ],
                ),
              ),
              child: Center(
                child: Container(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Login Page',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailText,
                        decoration: InputDecoration(
                          hintText: "Enter email",
                          errorText:_emailError,
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: const BorderSide(color: Colors.teal),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          suffixIcon: const Icon(Icons.email, color: Colors.teal, size: 28),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: passText,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: "Enter password",
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: const BorderSide(color: Colors.teal),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                              _isPasswordVisible
                                  ? _eyeController.forward()
                                  : _eyeController.reverse();
                            },
                            child: RotationTransition(
                              turns: Tween(begin: 0.0, end: 0.5).animate(_eyeController),
                              child: Icon(
                                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                color: Colors.teal,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ScaleTransition(
                        scale: Tween<double>(begin: 0.9, end: 1.0).animate(_buttonController),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                          ),
                          onPressed: () {
                            _buttonController.forward().then((_) => _buttonController.reverse());
                            String uEmail = emailText.text.trim();
                            String uPass = passText.text.trim();

                            setState(() {
                              _emailError = null;
                            });

                            if (uEmail.isEmpty || uPass.isEmpty) {
                              _showAlertDialog("Login Failed", "Please fill in all fields.");
                            } else if (!_validateEmail(uEmail)) {
                              setState(() {
                                _emailError = "Please enter a valid email address.";
                              });
                            } else {
                              // Show the success dialog
                              _showAlertDialog("Login Successful", "Welcome, $uEmail").then((_) {
                                // After the dialog is closed, navigate to the next page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotesPage(email: uEmail),
                                  ),
                                ).then((_) {
                                  _resetState(); // Reset state on return
                                });
                              });
                            }
                          },
                          child: const Text("Login", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
