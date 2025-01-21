import 'dart:async';
import 'package:classic_bluetooth/classic_services/clasic_service.dart';
import 'package:classic_bluetooth/services/service_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:permission_handler/permission_handler.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with AutomaticKeepAliveClientMixin {
  final _flutterBlueClassicPlugin = FlutterBlueClassic();

  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  StreamSubscription? _adapterStateSubscription;

  final Set<BluetoothDevice> _scanResults = {};
  StreamSubscription? _scanSubscription;

  bool _isScanning = false;
  int? _connectingToIndex;
  BluetoothDevice? connectedDevice; // Track the currently connected device
  // final Map<String, dynamic> scannedDevice;

  bool isDeviceConnected = false;  // Flag to track connection status
  String? connectedDeviceAddress;

  Map<String, BluetoothConnection?> _connections = {}; // Map to track connections
  final Map<String, dynamic> address = {};
  late BluetoothConnection connectionResult;


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    requestPermissions();
    initPlatformState();
    startAutomaticScan();
  }

  Future<void> initPlatformState() async {
    try {
      BluetoothAdapterState adapterState =
      await _flutterBlueClassicPlugin.adapterStateNow;

      _adapterStateSubscription =
          _flutterBlueClassicPlugin.adapterState.listen((current) {
            if (mounted) setState(() => _adapterState = current);
          });
      _scanSubscription =
          _flutterBlueClassicPlugin.scanResults.listen((device) {
            if (mounted) setState(() => _scanResults.add(device));
          });

      if (!mounted) return;
      setState(() => _adapterState = adapterState);
    } catch (e) {
      if (kDebugMode) print("Error initializing platform state: $e");
    }
  }

  Future<void> requestPermissions() async {
    if (await Permission.location.isDenied ||
        await Permission.location.isPermanentlyDenied) {
      await Permission.location.request();
    }
    if (await Permission.bluetoothScan.isDenied ||
        await Permission.bluetoothScan.isPermanentlyDenied) {
      await Permission.bluetoothScan.request();
    }
    if (await Permission.bluetoothConnect.isDenied ||
        await Permission.bluetoothConnect.isPermanentlyDenied) {
      await Permission.bluetoothConnect.request();
    }
  }

  List<Map<String, dynamic>> scannedDevices = [];

  void startAutomaticScan() async {
    if (_isScanning) return;

    _scanResults.clear();
    scannedDevices.clear(); // Clear the list to avoid duplicates
    _flutterBlueClassicPlugin.startScan();
    setState(() => _isScanning = true);

    // Stop scanning after a timeout (10 seconds here)
    await Future.delayed(const Duration(seconds: 10));

    for (var device in _scanResults) {
      scannedDevices.add({
        'name': device.name ?? 'Unknown',
        'bondState': device.bondState.toString(),
        'address': device.address,
        'RSSI': device.rssi,
      });
      print("Scanned Device: ${device.name}, ${device.bondState}, ${device.address}, ${device.rssi}");
    }

    _flutterBlueClassicPlugin.stopScan();
    setState(() => _isScanning = false);
  }

  @override
  void dispose() {
    _adapterStateSubscription?.cancel();
    _scanSubscription?.cancel();
    super.dispose();
  }


  Future<BluetoothConnection?> connectWithRetry(String address, {int retries = 3}) async {
    BluetoothConnection? connection;
    BluetoothDevice? device;

    for (int attempt = 1; attempt <= retries; attempt++) {
      try {
        print("Attempting to connect to $address");

        // Find the BluetoothDevice during the scan and attempt to connect
        device = _scanResults.firstWhere((d) => d.address == address);

        connection = await _flutterBlueClassicPlugin.connect(address).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException('Connection timed out.'),
        );

        print("Connection successful: $connection");

        if (connection != null && connection.isConnected) {
          setState(() {
            connectedDevice= device;
            connectedDeviceAddress = address; // Set the connected device address
            connectionResult = connection!;  // Save the connection result
          });
          print("connectionResult: ${connectionResult}");
          return connection;
        } else {
          print("Connection failed");
        }

      } catch (e) {
        if (attempt == retries) rethrow;
        await Future.delayed(const Duration(seconds: 2)); // Retry after 2 seconds
        print("Retrying connection...");
      }
    }

    print("Failed to connect to $address after $retries attempts.");
    return null;
  }


  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensure AutomaticKeepAliveClientMixin works
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    List<BluetoothDevice> scanResults = _scanResults.toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          if (_isScanning)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Scanning for Bluetooth devices...',
                style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
              ),
            ),
          if (scanResults.isEmpty)
            Center(child: Text("No devices found yet", style: TextStyle(fontSize: screenWidth * 0.04),))
          else
            for (var result in scanResults.asMap().entries)
              ListTile(
                title: Text(result.value.name ?? 'Unknown', style: TextStyle(fontSize: screenWidth * 0.04),),
                subtitle: Text(result.value.address, style: TextStyle(fontSize: screenWidth * 0.04),),
                onTap: () {
                  print("Device is connected: ${connectedDevice}, devicename:${connectedDevice?.name}, address:${connectedDevice?.address}");
                  print("result : ${connectionResult}");
                  // Check if the device is connected and connectedDevice is not null
                  if (isDeviceConnected && connectedDevice != null && connectedDevice?.address == result.value.address) {
                    // Device is connected, navigate to ClassicService
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClassicService(
                          scannedDevice: {
                            'name': result.value.name ?? 'Unknown',
                            'address': result.value.address,
                            'bondState': result.value.bondState.toString(),
                            'RSSI': result.value.rssi,
                          },
                          connection: connectionResult,  // Pass connection result
                        ),
                      ),
                    );
                  } else {
                    // If the device is not connected, show a message
                    print("Device is not connected. Cannot navigate.");
                    // Optionally, you can show a dialog or snackbar to notify the user
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Device is not connected. Please connect first.")),
                    );
                  }
                },
                trailing: _connectingToIndex == result.key
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button color
                  ),
                  onPressed: isDeviceConnected &&
                      connectedDeviceAddress != result.value.address
                      ? null // Disable button if a device is connected and it's not the currently connected one
                      : ()

                  {
                    final deviceAddress = result.value.address;

                    if (_connections[deviceAddress]?.isConnected == true) {
                      // Disconnect the device
                      _connections[deviceAddress]?.dispose();
                      setState(() {
                        _connections.remove(deviceAddress);
                        isDeviceConnected = false; // Update flag when disconnected
                        connectedDeviceAddress = null; // Reset the connected device address
                      });
                    } else {
                      setState(() {
                        _connectingToIndex = result.key; // Set connecting index
                        isDeviceConnected = true; // Update flag when connecting
                        connectedDeviceAddress = deviceAddress; // Set connected device address
                      });

                      // Connect with retry logic
                      connectWithRetry(deviceAddress).then((conn) {
                        if (conn != null && conn.isConnected) {
                          final connectionStatus = 'Connected';

                          // Show dialog for successful connection
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Material(
                                color: Colors.transparent,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    margin: const EdgeInsets.all(16),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 10),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Connected to ${result.value.name ?? 'Unknown'}",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        TextButton(
                                          child: const Text('X',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          onPressed: () {
                                            print("conn :${conn}");
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ClassicService(
                                                      scannedDevice: {
                                                        'name': result.value.name ?? 'Unknown',
                                                        'address': result.value.address,
                                                        'bondState': result.value.bondState.toString(),
                                                        'RSSI': result.value.rssi,
                                                      },
                                                      connection: conn,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );

                          setState(() {
                            _connections[deviceAddress] = conn; // Save the connection
                            _connectingToIndex = null; // Reset connecting index
                          });
                        }
                      }).catchError((e) {
                        if (mounted) {
                          setState(() => _connectingToIndex = null);
                        }
                        print("Connection error: $e");
                      });
                    }
                  },
                  child: Text(
                    _connections[result.value.address]?.isConnected == true
                        ? 'Disconnect'
                        : 'Connect',
                    style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.04),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
