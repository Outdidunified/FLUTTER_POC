import 'package:flutter/material.dart';
import 'package:my_proj/provider/provider.dart';
import 'package:my_proj/screens/loginpage.dart';
import 'package:my_proj/services/api_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _phonecontroller = TextEditingController();


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

  void _Register() async{
    String email = _emailController.text.trim();
    String password = _passwordcontroller.text.trim();
    String username = _usernamecontroller.text.trim();
    String phone_no = _phonecontroller.text.trim();
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
    final response = await apiService.Register(username, email, phone_no, password);
    print(response);
    if(response['success']== true){

      // Provider.of<LoginDataProvider>(context, listen: false).setData(userId, username, email, password);
      //
      //
      // SharedPreferences pref = await SharedPreferences.getInstance();
      // await pref.setString("user_id", userId.toString());
      // await pref.setString("username", username);
      // await pref.setString("email_id", email);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Registration Success"),
            content: Text("Registered Successfuly"),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Loginpage()));

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
            title: Text("Registration Failed"),
            content: Text("Registration Failed"),
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

      ),
      body:Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              TextField(
                controller: _usernamecontroller,
                decoration: InputDecoration(
                    hintText: "Enter username here",
                    labelText: "UserName",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              SizedBox(height: 20,),
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
                controller: _phonecontroller,
                decoration: InputDecoration(
                    hintText: "Enter phonenumber here",
                    labelText: "Phone No",
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
                // _login();
                _Register();
              },
                  child: Text("login")),

              // SizedBox(height: 20,),
              // TextButton(onPressed: (){
              //   // googleLogin();
              // }, child: Text("Sign in Through google"))
            ],
          ),
        ),
      ),
    );

  }
}
