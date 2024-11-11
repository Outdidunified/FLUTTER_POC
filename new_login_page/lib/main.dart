  // import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:login/src/routes/router.dart';
// import 'package:flutter/services.dart' as rootBundle;
import 'package:provider/provider.dart';
// import ''
// import 'register.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'session.dart';
// export 'pages/example.dart';
import './src/pages/login.dart';
import './src/pages/example.dart';
// import './src/pages/register.dart';
import './src/providers/session.dart';
import './src/pages/gifs_page.dart';
import './src/pages/video_player_page.dart';
import './src/pages/image_page.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SessionProvider(),
      child: MyApp(),

    ),
  );
}
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: LoginPage(),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SessionProvider(),
      child: MaterialApp(
        title: 'Your App',
        debugShowCheckedModeBanner: false,
        // home: SplashScreen(),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,

        // Check session state here
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('username');
    String? passwordToken = prefs.getString('password');  // Only retrieving userToken
// Only retrieving userToken

    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);

    if (userToken != null && passwordToken != null) {
      // If userToken exists, register the session
      sessionProvider.register(userToken, passwordToken);  // Register with only userToken

      // Navigate to HomePage
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => HomePage()), // Navigate to HomePage after successful login
      // );
      Navigator.pushReplacementNamed(context, '/homepage');
    } else {
      // If userToken is null, redirect to LoginPage
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => LoginPage()),
      // );
      Navigator.pushReplacementNamed(context, '/loginpage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Splash Screen')),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}




