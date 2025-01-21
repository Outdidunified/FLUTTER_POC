import 'package:classic_bluetooth/advanced_devices/classic_page.dart';
import 'package:classic_bluetooth/ble_Devices/ble_page.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        // showPerformanceOverlay: true,

        debugShowCheckedModeBanner: false, home: ScreenPage());
  }
}

class ScreenPage extends StatefulWidget {
  const ScreenPage({super.key});

  @override
  State<ScreenPage> createState() => _ScreenPageState();
}

class _ScreenPageState extends State<ScreenPage> with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _nestedTabController1;
  late TabController _nestedTabController2;
  late TabController _nestedTabController3;
  int counter = 0;

  @override
  void initState() {
    _mainTabController = TabController(length: 3, vsync: this);
    _nestedTabController1 = TabController(length: 2, vsync: this);
    _nestedTabController2 = TabController(length: 2, vsync: this);
    _nestedTabController3 = TabController(length: 2, vsync: this);

    // TODO: implement initState
    super.initState();
  }

  // Create keys for the BluetoothScanner and MainScreen widgets
  final GlobalKey<BluetoothScannerState> _bluetoothScannerKey =
      GlobalKey<BluetoothScannerState>();
  final GlobalKey<MainScreenState> _mainScreenKey =
      GlobalKey<MainScreenState>();

  // Method to reset scanning for both BluetoothScanner and MainScreen
  void resetScanning() {
    if (_bluetoothScannerKey.currentState != null) {
      print("reloading");
      _bluetoothScannerKey.currentState?.startAutomaticScanning();
    }

    if (_mainScreenKey.currentState != null) {
      _mainScreenKey.currentState?.startAutomaticScan();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.qr_code_scanner,
                size: screenWidth * 0.06, // Dynamic icon size
              )),
          // SizedBox(width: 200,),
          // Text("Bluetooth", style: TextStyle(color: Colors.white),),
          IconButton(
              onPressed: () {
                print("refreshing");
                resetScanning();
              },
              icon: Icon(
                Icons.refresh, size: screenWidth * 0.06, // Dynamic icon size
              )),
        ],
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color of the drawer icon here
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          "Bluetooth",
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.05, // Dynamic title font size
          ),
        ),
        bottom: TabBar(
          labelStyle: TextStyle(fontSize: screenWidth * 0.04),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
          controller: _mainTabController,
          tabs: [
            Tab(text: "Nearby"),
            Tab(text: "History"),
            Tab(text: "Favorites"),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,

        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Bluetooth',
                style: TextStyle(
                    fontSize: screenWidth * 0.06), // Dynamic header font size
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings, size: screenWidth * 0.06),
              title: Text(
                'Settings',
                style: TextStyle(fontSize: screenWidth * 0.045),
              ),
              // selected: _selectedIndex == 0,
              // onTap: () {
              //   // Update the state of the app
              //   _onItemTapped(0);
              //   // Then close the drawer
              //   Navigator.pop(context);
              // },
            ),
            ListTile(
              leading: Icon(Icons.mobile_friendly, size: screenWidth * 0.06),
              title: Text('About Device',
                  style: TextStyle(fontSize: screenWidth * 0.045)),
              // selected: _selectedIndex == 1,
              // onTap: () {
              //   // Update the state of the app
              //   _onItemTapped(1);
              //   // Then close the drawer
              //   Navigator.pop(context);
              // },
            ),
            ListTile(
              leading: Icon(Icons.feedback, size: screenWidth * 0.06),
              title: Text('Feedback',
                  style: TextStyle(fontSize: screenWidth * 0.045)),
              // selected: _selectedIndex == 2,
              // onTap: () {
              //   // Update the state of the app
              //   _onItemTapped(2);
              //   // Then close the drawer
              //   Navigator.pop(context);
              // },
            ),
            ListTile(
              leading: Icon(Icons.info, size: screenWidth * 0.06),
              title:
                  Text('Help', style: TextStyle(fontSize: screenWidth * 0.045)),
              // selected: _selectedIndex == 1,
              // onTap: () {
              //   // Update the state of the app
              //   _onItemTapped(1);
              //   // Then close the drawer
              //   Navigator.pop(context);
              // },
            ),
            ListTile(
              leading: Icon(Icons.help, size: screenWidth * 0.06),
              title:
                  Text('FAQ', style: TextStyle(fontSize: screenWidth * 0.045)),
              // selected: _selectedIndex == 1,
              // onTap: ()
              //   // Update the state of the app
              //   _onItemTapped(1);
              //   // Then close the drawer
              //   Navigator.pop(context);
              // },
            ),
            ListTile(
              leading: Icon(Icons.people, size: screenWidth * 0.06),
              title: Text('About Us',
                  style: TextStyle(fontSize: screenWidth * 0.045)),
              // selected: _selectedIndex == 1,
              // onTap: () {
              //   // Update the state of the app
              //   _onItemTapped(1);
              //   // Then close the drawer
              //   Navigator.pop(context);
              // },
            ),
            ListTile(
              leading:
                  Icon(Icons.privacy_tip_outlined, size: screenWidth * 0.06),
              title: Text('Privacy Policy',
                  style: TextStyle(fontSize: screenWidth * 0.045)),
              // selected: _selectedIndex == 1,
              // onTap: () {
              //   // Update the state of the app
              //   _onItemTapped(1);
              //   // Then close the drawer
              //   Navigator.pop(context);
              // },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _mainTabController,
        children: [
          // Nearby Tab
          Column(
            children: [
              TabBar(
                controller: _nestedTabController1,
                labelStyle: TextStyle(fontSize: screenWidth * 0.04),
                tabs: [
                  Tab(text: "BLE Devices"),
                  Tab(text: "Classic Devices"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _nestedTabController1,
                  children: [
                    BluetoothScanner(key: _bluetoothScannerKey),
                    MainScreen(key: _mainScreenKey),
                    // Center(child: Text("Nearby - BLE Devices")),
                    // Center(child: Text("Nearby - Classic Devices")),
                  ],
                ),
              ),
            ],
          ),
          // History Tab
          Column(
            children: [
              TabBar(
                controller: _nestedTabController2,
                labelStyle: TextStyle(fontSize: screenWidth * 0.04),
                tabs: [
                  Tab(text: "BLE Devices"),
                  Tab(text: "Classic Devices"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _nestedTabController2,
                  children: [
                    Center(child: Text("History - BLE Devices")),
                    Center(child: Text("History - Classic Devices")),
                  ],
                ),
              ),
            ],
          ),
          // Favorites Tab
          Column(
            children: [
              TabBar(
                controller: _nestedTabController3,
                labelStyle: TextStyle(fontSize: screenWidth * 0.04),
                tabs: [
                  Tab(text: "BLE Devices"),
                  Tab(text: "Classic Devices"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _nestedTabController3,
                  children: [
                    Center(child: Text("Favorites - BLE Devices")),
                    Center(child: Text("Favorites - Classic Devices")),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
