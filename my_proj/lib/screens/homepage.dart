
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_proj/provider/provider.dart';
import 'package:my_proj/screens/loginpage.dart';

class Homepage extends StatefulWidget {
  final String email;
  // final String username;
  // final int userId;

  const Homepage({super.key, required this.email});
  // const Homepage({super.key, required this.email, required this.userId});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Keep track of visited indexes for back navigation
  List<int> _indexStack = [];
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Center(child: Text("Home Page", style: TextStyle(fontSize: 20, color: Colors.white),),),
    Center(child: Text("Wallet Page", style: TextStyle(fontSize: 20, color: Colors.white),),),
    Center(child: Text("History Page", style: TextStyle(fontSize: 20, color: Colors.white),),),

    Center(child: Text("Profile Page", style: TextStyle(fontSize: 20, color: Colors.white),),),
    // Center(child: Text("Profile Page", style: TextStyle(fontSize: 20, color: Colors.black),),)
  ];

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

  // Handle the back button press
  Future<bool> _onWillPop() async {
    if (_indexStack.isNotEmpty) {
      setState(() {
        _selectedIndex = _indexStack.last; // Pop the last index from stack
        _indexStack.removeLast();
      });
      return false; // Prevent default back behavior
    }
    return true; // Allow default back behavior if no previous index in stack
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginDataProvider>(context, listen: false).email;
    print(provider);
    return WillPopScope(
      onWillPop: _onWillPop, // Handle back button press
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("gmail:$provider", style: TextStyle(fontSize: 15),),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loginpage()));
                logout();
              },
              icon: Icon(Icons.logout),
            )
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     // Action for FAB button click
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(content: Text('FAB Button Pressed')),
        //     );
        //   },
        //   child: Icon(Icons.add),
        //   backgroundColor: Colors.green,
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: Colors.green,
              icon: Column(
                children: [
                  SizedBox(height: 10),
                  Icon(Icons.home, size: 30, color: Colors.black,),
                  Text("Home", style: TextStyle(color: Colors.black)),
                ],
              ),
              label: '',  // Empty label if you only want the icon and text within the column
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  SizedBox(height: 10),
                  Icon(Icons.wallet, size: 30, color: Colors.black,),
                  Text("Wallet", style: TextStyle(color: Colors.black)),
                ],
              ),
              label: '',  // Empty label if you only want the icon and text within the column
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  SizedBox(height: 10),
                  Icon(Icons.history, size: 30, color: Colors.black,),
                  // AnimatedIcon(icon: AnimatedIcons.menu_close, progress: ,)
                  Text("History", style: TextStyle(color: Colors.black)),
                ],
              ),
              label: '',  // Empty label if you only want the icon and text within the column
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  SizedBox(height: 10),
                  Icon(Icons.person, size: 30, color: Colors.black,),
                  Text("Profile", style: TextStyle(color: Colors.black)),
                ],
              ),
              label: '',  // Empty label if you only want the icon and text within the column
            ),
          ],
          // Color of the curved button

          backgroundColor: Colors.green, // Background color of the screen
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        body: IndexedStack(

          index: _selectedIndex,
          children: _screens,
        ),
      ),
    );
  }
}