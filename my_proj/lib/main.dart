import 'package:flutter/material.dart';
import 'package:my_proj/pages/google_map/mappage.dart';
// import 'package:login_page_new/provider/provider.dart';
// import 'package:login_page_new/screens/homepage.dart';
// import 'package:login_page_new/screens/loginpage.dart';
import 'package:my_proj/provider/provider.dart';
import 'package:my_proj/pages/home/home_layout.dart';
import 'package:my_proj/provider/theme_provider.dart';
import 'package:my_proj/screens/loginpage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // Create an instance of ThemeProvider
  final themeProvider = ThemeProvider();
  await themeProvider.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginDataProvider()),
        ChangeNotifierProvider(create: (_) => themeProvider),
      ],
      child: const MyApp(),
    ),
  );
}


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//
//       color: Colors.black,
//       debugShowCheckedModeBanner: false,
//       home: SplashScreen(),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            color: Colors.white,
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
            // theme: ThemeData.light(), // Light theme
            // darkTheme: ThemeData.dark(), // Dark theme
            // themeMode: ThemeProvider().themeMode,
            home: SplashScreen(),
            // theme: ThemeData(
            //   // Set the primary color of the app
            //   primaryColor: Colors.black,
            //
            //   // Set the background color of the app
            //   scaffoldBackgroundColor: Colors.black,
            //
            //
            //   // Set text theme for the app
            //   textTheme: TextTheme(
            //     displayLarge: TextStyle(color: Colors.white), // Headline text color
            //     displayMedium: TextStyle(color: Colors.white), // Sub-headline text color
            //     displaySmall: TextStyle(color: Colors.white), // Sub-sub-headline text color
            //     bodyLarge: TextStyle(color: Colors.white), // Body text color
            //     bodyMedium: TextStyle(color: Colors.white), // Body text color
            //     bodySmall: TextStyle(color: Colors.white), // Smaller body text color
            //     labelLarge: TextStyle(color: Colors.white), // Labels text color
            //     labelMedium: TextStyle(color: Colors.white), // Labels text color
            //     labelSmall: TextStyle(color: Colors.white), // Smaller labels text color
            //   ),
            //
            //   // Set button theme
            //   buttonTheme: ButtonThemeData(
            //     buttonColor: Colors.white, // Button color
            //     textTheme: ButtonTextTheme.primary, // Button text color
            //   ),
            //
            //   // Set the icon theme
            //   iconTheme: IconThemeData(
            //     color: Colors.white, // Icon color
            //   ),
            //
            //   // App bar theme
            //   appBarTheme: AppBarTheme(
            //     backgroundColor: Colors.black, // App bar background color
            //     iconTheme: IconThemeData(color: Colors.white), // App bar icon color
            //     titleTextStyle: TextStyle(color: Colors.white), // App bar text color
            //   ),
            // ),
          );
        }
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
            // builder: (context) => Homepage(email: email),
            builder: (context) => MapScreen(),

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
      backgroundColor: Colors.black,
      body: CircularProgressIndicator(),
    );
  }
}
