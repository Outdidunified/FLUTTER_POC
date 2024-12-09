import 'package:flutter/material.dart';
// import 'package:login_page_new/provider/provider.dart';
// import 'package:login_page_new/screens/homepage.dart';
// import 'package:login_page_new/screens/loginpage.dart';
import 'package:my_proj/provider/provider.dart';
import 'package:my_proj/screens/homepage.dart';
import 'package:my_proj/screens/loginpage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp (ChangeNotifierProvider(create: (_)=>LoginDataProvider(),
    child: const MyApp(),
  )) ;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void checkSession(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? email = pref.getString("email_id");
    String? username = pref.getString("username");
    String? userIdString = pref.getString("user_id");


    print("Checking session: userId=$userIdString, username=$username, email=$email");

    if (email != null && username != null && userIdString != null) {
      int userId = int.tryParse(userIdString) ?? 0;

      // Update provider with session data
      Provider.of<LoginDataProvider>(context, listen: false)
          .setData(userId, username, email, '');

      // Navigate to the Homepage
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(email:email, username: username, userId: userId,),
            // builder: (context) => Bottomnavigatorpage(),

          ));
    } else {
      // Navigate to the LoginPage
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Loginpage(),
          ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkSession(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CircularProgressIndicator(),
    );
  }
}
