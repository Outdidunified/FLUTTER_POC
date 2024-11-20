import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'signup_screen.dart';
import 'user_provider.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = "login";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (provider.error.isNotEmpty)
                Text(provider.error, style: const TextStyle(color: Colors.red)),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: provider.isLoading
                    ? null
                    : () {
                  if (_formKey.currentState!.validate()) {
                    provider.logIn(
                      _emailController.text,
                      _passwordController.text,
                    ).then((_) {
                      if (provider.isLoggedIn) {
                        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                      }
                    });
                  }
                },
                child: provider.isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Log In"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, SignupScreen.routeName);
                },
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
