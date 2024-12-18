import 'package:flutter/material.dart';
import 'package:my_proj/pages/google_map/mappage.dart';
import 'package:my_proj/provider/provider.dart';
// import 'package:my_proj/screens/bottomNavigatorPage.dart';
import 'package:my_proj/pages/home/home_layout.dart';
import 'package:my_proj/screens/registerPage.dart';
import 'package:my_proj/services/api_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

  googleLogin() async {
    print("Google login method called");

    GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
      'email', // Request access to the user's email
      'profile', // Request access to the user's profile
    ]);

    try {
      // Initiating Google Sign-In process
      var result = await _googleSignIn.signIn();

      if (result != null) {
        String email = result.email;
        // String id = result.id;
        // int userId = int.parse(id);

        // Update the Provider with the email and userId
        Provider.of<LoginDataProvider>(context, listen: false)
            .setEmail(email);

        // Navigating to the homepage after successful login
        Navigator.pushReplacement(
          context,
          // MaterialPageRoute(builder: (context) => Homepage(email: email)),
          MaterialPageRoute(builder: (context) => MapScreen()),

        );
      } else {
        print("Google login canceled");
      }
    } catch (error) {
      print("Error during Google login: $error");
      _showMessage("Google login failed. Please try again.");
    }
  }


  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(email);
  }

  // Function to display a snackbar message
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _login() async{
    String email = _emailController.text.trim();
    String password = _passwordcontroller.text.trim();
    final ApiService apiService = ApiService();

    // Validate input fields
    if (email.isEmpty || password.isEmpty) {
      _showMessage("Please fill in all fields.");
      return;
    }
    if (!_isValidEmail(email)) {
      _showMessage("Please enter a valid email address.");
      return;

    }
    final response = await apiService.login(email, password);
    print(response);
    if(response['success']== true){

      final userId = response['data']['data']['user_id']?? 0;
      final username = response['data']['data']['username']?? '';

      print(username);

      Provider.of<LoginDataProvider>(context, listen: false).setData(userId, username, email, password);


      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("user_id", userId.toString());
      await pref.setString("username", username);
      await pref.setString("email_id", email);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Success"),
            content: Text("Login Successful"),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Provider.of<LoginDataProvider>(context, listen: false).setData(userId, username, email, '');

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Homepage(email: email)));

                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Bottomnavigatorpage()));
                },
              ),
            ],
          );
        },
      );
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Failed"),
            content: Text("Login Failed"),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Loginpage()));
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
    return
      Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,

        ),
        body:Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: "Enter email here",
                      labelText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                ),
                SizedBox(height: 20,),

                TextField(
                  controller: _passwordcontroller,
                  decoration: InputDecoration(
                      hintText: "Enter password here",
                      labelText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                ),
                SizedBox(height: 20,),

                ElevatedButton(onPressed: (){
                  _login();
                },
                    child: Text("login")),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Registerpage()));
                }, child: Text("Don't have account? Register here")),

                SizedBox(height: 20,),
                TextButton(onPressed: (){
                  googleLogin();
                }, child: Text("Sign in Through google"))
              ],
            ),
          ),
        ),
      );
  }
}