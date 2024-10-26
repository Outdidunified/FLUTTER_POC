import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final emailText = TextEditingController();
  final passText = TextEditingController();
  String? _emailError; // Holds the error message for email validation

  // Function to validate email format
  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: emailText,
                decoration: InputDecoration(
                  hintText: "Enter email",
                  errorText: _emailError, // Display error message if email is invalid
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.email, size: 30, color: Colors.blue),
                    onPressed: () {},
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passText,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter password",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.remove_red_eye, color: Colors.blue, size: 30),
                    onPressed: () {},
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 40,
                margin: const EdgeInsets.only(top: 10),
                child: Card(
                  elevation: 8,
                  shadowColor: Colors.blue,
                  child: ElevatedButton(
                    child: const Text(
                      "Login",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      String uEmail = emailText.text.trim();
                      String uPass = passText.text.trim();
                      print("Email: $uEmail, Password: $uPass");

                      // Reset email error message
                      setState(() {
                        _emailError = null; // Reset error message
                      });

                      // Check if fields are empty or email is invalid
                      if (uEmail.isEmpty || uPass.isEmpty) {
                        _showAlertDialog("Login Failed", "Please fill in all fields.");
                      } else if (!_validateEmail(uEmail)) {
                        setState(() {
                          _emailError = "Please enter a valid email address.";
                        });
                      } else {
                        // Show success message
                        _showAlertDialog("Login Successful", "Welcome!");

                        // Navigate to the NextPage after closing the alert dialog
                        Future.delayed(const Duration(seconds: 60), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NextPage(email: uEmail, password: uPass),
                            ),
                          );
                        });
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// New Page to display the entered email and password
class NextPage extends StatelessWidget {
  final String email;
  final String password;

  const NextPage({Key? key, required this.email, required this.password}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
      ),
      body: Center(
        child: Text(
          'Entered Email: $email',
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
