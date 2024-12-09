import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_proj/provider/provider.dart';
import 'package:my_proj/screens/loginpage.dart';

class Homepage extends StatefulWidget {
  final String email;
  final String username;
  final int userId;

  const Homepage({super.key, required this.email, required this.username, required this.userId});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Keep track of visited indexes for back navigation
  List<int> _indexStack = [];
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Center(child: Text("Home Page", style: TextStyle(fontSize: 20, color: Colors.black),),),
    Center(child: Text("Search Page", style: TextStyle(fontSize: 20, color: Colors.black),),),
    Center(child: Text("Profile Page", style: TextStyle(fontSize: 20, color: Colors.black),),)
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
    return false; // Allow default back behavior if no previous index in stack
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginDataProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: _onWillPop, // Handle back button press
      child: Scaffold(
        appBar: AppBar(
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
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
          ],
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
