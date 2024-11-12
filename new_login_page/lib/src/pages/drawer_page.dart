import 'package:flutter/material.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Dashboard Page', style: optionStyle,),
    Text('Contacts Page', style: optionStyle,),
    Text('Events Page', style: optionStyle,),
    Text('Notes Page', style: optionStyle,),
    Text('Settings Page', style: optionStyle,),
    Text('Notification Page', style: optionStyle,),
    Text('Privacy Policy', style: optionStyle,),
    Text('Feedback Page', style: optionStyle,),
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex= index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.red,
        title: Row(
          children: [
            Icon(Icons.email_outlined, color: Colors.black,),
            SizedBox(width: 10,),
            Text("Gmail Account"),
          ],
        ),
        leading: Builder(
       builder: (context){
         return IconButton(
             onPressed: (){
               Scaffold.of(context).openDrawer();

             },
             icon: Icon(Icons.menu));
       },
        ),
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
           child: ListView(
             children: [
               DrawerHeader(
               decoration:BoxDecoration(
                 color: Colors.red
               ) ,
                 child: Column(
                   children: [
                     // const Text("Drawer"),
                     CircleAvatar(
                       radius: 40.0,  // size of the circle
                       backgroundImage: AssetImage('assets/images/avatar.jpg'), // image inside the circle
                       backgroundColor: Colors.transparent,  // transparent background if no image is provided
                     ),
                     Text("Amit Patil", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                     Text("amitpatil@gmail.com", style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: Colors.white),)

                   ],
                 ),

               ),
               ListTile(
           title: Row(
             children: [
               Icon(Icons.dashboard_outlined),
               SizedBox(width: 10,),
               Text("Dashboard"),
             ],
           ),
                 selected: _selectedIndex == 0,
                 onTap: () {
                   // Update the state of the app
                   _onItemTapped(0);
                   // Then close the drawer
                   Navigator.pop(context);
                 },
               ),
               ListTile(
                 title: Row(
                   children: [
                     Icon(Icons.contacts_outlined),
                     SizedBox(width: 10,),
                     Text("Contacts"),
                   ],
                 ),
                 selected: _selectedIndex == 1,
                 onTap: () {
                   // Update the state of the app
                   _onItemTapped(1);
                   // Then close the drawer
                   Navigator.pop(context);
                 },
               ),
               ListTile(
                 title: Row(
                   children: [
                     Icon(Icons.event_note),
                     SizedBox(width: 10,),
                     Text("Events"),
                   ],
                 ),
                 selected: _selectedIndex == 2,
                 onTap: () {
                   // Update the state of the app
                   _onItemTapped(2);
                   // Then close the drawer
                   Navigator.pop(context);
                 },
               ),
               ListTile(
                 title: Row(
                   children: [
                     Icon(Icons.notes_outlined),
                     SizedBox(width: 10,),
                     Text("Notes"),
                   ],
                 ),
                 selected: _selectedIndex == 3,
                 onTap: () {
                   // Update the state of the app
                   _onItemTapped(3);
                   // Then close the drawer
                   Navigator.pop(context);
                 },
               ),
               ListTile(
                 title: Row(
                   children: [
                     Icon(Icons.settings),
                     SizedBox(width: 10,),
                     Text("Settings"),
                   ],
                 ),
                 selected: _selectedIndex == 4,
                 onTap: () {
                   // Update the state of the app
                   _onItemTapped(4);
                   // Then close the drawer
                   Navigator.pop(context);
                 },
               ),
               ListTile(
                 title: Row(
                   children: [
                     Icon(Icons.notifications),
                     SizedBox(width: 10,),
                     Text("Notifications"),
                   ],
                 ),
                 selected: _selectedIndex == 5,
                 onTap: () {
                   // Update the state of the app
                   _onItemTapped(5);
                   // Then close the drawer
                   Navigator.pop(context);
                 },
               ),
               ListTile(
                 title: Row(
                   children: [
                     Icon(Icons.privacy_tip_outlined),
                     SizedBox(width: 10,),
                     Text("Privacy Policy"),
                   ],
                 ),
                 selected: _selectedIndex == 6,
                 onTap: () {
                   // Update the state of the app
                   _onItemTapped(6);
                   // Then close the drawer
                   Navigator.pop(context);
                 },
               ),
               ListTile(
                 title: Row(
                   children: [
                     Icon(Icons.feedback_outlined),
                     SizedBox(width: 10,),
                     Text("Send Feedback"),
                   ],
                 ),
                 selected: _selectedIndex == 7,
                 onTap: () {
                   // Update the state of the app
                   _onItemTapped(7);
                   // Then close the drawer
                   Navigator.pop(context);
                 },
               )

             ],
           ),
      ),
    );
  }
}
