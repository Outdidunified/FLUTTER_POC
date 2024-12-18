import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_proj/components/bottom_bar.dart';
import 'package:my_proj/pages/history_page.dart';
import 'package:my_proj/pages/home_page.dart';
import 'package:my_proj/pages/profile_page.dart';
import 'package:my_proj/pages/wallet_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_proj/provider/provider.dart';
import 'package:my_proj/screens/loginpage.dart';

class Homepage extends StatefulWidget {
  final String email;

  const Homepage({super.key, required this.email});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<int> _indexStack = [];
  int _selectedIndex = 0;

  // Handle back button press
  Future<bool> _onWillPop() async {
    if (_indexStack.isNotEmpty) {
      setState(() {
        _selectedIndex = _indexStack.last; // Pop the last index from stack
        _indexStack.removeLast();
      });
      return false; // Prevent default back behavior
    }
    SystemNavigator.pop();
    return false; // Allow default back behavior if no previous index in stack
  }

  void _onItemTapped(int index) {
    setState(() {
      if (_selectedIndex != index) {
        _indexStack.add(_selectedIndex); // Add current index to stack
      }
      _selectedIndex = index;
    });
  }

  void logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();

    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signOut(); // Sign out from Google
      print("User signed out from Google");
    } catch (error) {
      print("Error signing out from Google: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.email;
    final loginDataProvider = Provider.of<LoginDataProvider>(context);

    final List<Widget> _screens = [
      HomeFooterPage(username: loginDataProvider.username,
          email: email,
          userId: loginDataProvider.userId),
      WalletPage(username: loginDataProvider.username,
          email: email,
          userId: loginDataProvider.userId),
      HistoryPage(username: loginDataProvider.username,
          email: email,
          userId: loginDataProvider.userId),
      ProfilePage(username: loginDataProvider.username,
          email: email,
          userId: loginDataProvider.userId),
    ];

    final provider = loginDataProvider.email;
    return WillPopScope(
      onWillPop: _onWillPop, // Handle back button press
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("gmail:$provider", style: TextStyle(fontSize: 15)),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Loginpage()));
                logout();
              },
              icon: Icon(Icons.logout),
            )
          ],
        ),
        floatingActionButton: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFCB535), Color(0xFFFFD27F)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                shape: BoxShape.circle,
              ),
              child: FloatingActionButton(
                onPressed: () {
                  print("Center Button Pressed");
                },
                child: Icon(Icons.electric_car, color: Colors.white),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
      ),
    );
  }
}
