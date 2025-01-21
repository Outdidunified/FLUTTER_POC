import 'dart:async';
import 'dart:convert';
import 'package:classic_bluetooth/services/service_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BluetoothScanner extends StatefulWidget {
  const BluetoothScanner({super.key});

  @override
  BluetoothScannerState createState() => BluetoothScannerState();
}

class BluetoothScannerState extends State<BluetoothScanner>
    with AutomaticKeepAliveClientMixin {
  FlutterBluePlus flutterBluePlus = FlutterBluePlus();
  late Stream<List<ScanResult>> scanResultsStream;
  late StreamSubscription<List<ScanResult>> scanSubscription;
  List<ScanResult> scanResults = [];
  BluetoothDevice? connectedDevice; // Track the currently connected device
  Timer? scanTimer; // Timer to stop scanning automatically
  bool isScanning = false;
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;

  @override
  bool get wantKeepAlive => true;
  @override
  // void initState() {
  //   super.initState();
  //   scanning();
  //   requestPermissions();
  //   _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
  //     setState(() {
  //       _adapterState = state;
  //     });
  //
  //     // If Bluetooth is off, try to turn it on automatically
  //     if (_adapterState == BluetoothAdapterState.off) {
  //       _turnOnBluetooth();
  //     }
  //   });
  //   startAutomaticScanning();
  //   // }      // loadingData();
  //   scanResultsStream = FlutterBluePlus.scanResults.map((results) {
  //     // Include only devices with a non-empty name
  //     return results.where((result) => result.device.name.isNotEmpty).toList();
  //   });
  //
  //   scanSubscription = scanResultsStream.listen((filteredResults) {
  //     setState(() {
  //       scanResults = filteredResults;
  //       print("Filtered scan results (only named devices): $scanResults");
  //     });
  //   });
  // }

  void initState() {
    super.initState();
    scanning();
    requestPermissions();
    // Listen to Bluetooth adapter state changes
    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      setState(() {
        _adapterState = state;
      });

      print("Bluetooth adapter state: $_adapterState");

      // If Bluetooth is off, try to turn it on automatically
      if (_adapterState == BluetoothAdapterState.off) {
        _turnOnBluetooth();
        startAutomaticScanning();
      }
      print("now Bluetooth adapter state: $_adapterState");
      print("now scanning state: $isScanning");

      // If Bluetooth is on, start scanning automatically
      if (_adapterState == BluetoothAdapterState.on) {
        print("onnnnnnnnnnnnnnnnnnnn");
        startAutomaticScanning();
      }
    });

    // Start scanning if Bluetooth is already on during initialization
    if (_adapterState == BluetoothAdapterState.on) {
      startAutomaticScanning();
    }

    // Filter the scan results to include only devices with a non-empty name
    scanResultsStream = FlutterBluePlus.scanResults.map((results) {
      return results.where((result) => result.device.name.isNotEmpty &&  result.device.name != 'Unknown Device').toList();
    });

    // Subscribe to the filtered scan results
    scanSubscription = scanResultsStream.listen((filteredResults) {
      setState(() {
        scanResults = filteredResults;
        print("Filtered scan results (only named devices): $scanResults");
      });
    });
  }

  Future<void> _turnOnBluetooth() async {
    try {
      await FlutterBluePlus.turnOn();
      startAutomaticScanning();
      // await Future.delayed(const Duration(seconds: 2));  // Wait for Bluetooth to turn on
    } catch (e) {
      print("Error turning on Bluetooth: $e");
    }
  }

  Future<bool> requestPermissions() async {
    Location location = Location();

    // Check if location service is enabled
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw Exception("Location service is required but was not enabled.");
      }
    }

    if (await Permission.location.isDenied) {
      if (!await Permission.location.request().isGranted) {
        _showPermissionDialog('Location');
        return false;
      }
    }

    if (await Permission.bluetoothScan.isDenied) {
      if (!await Permission.bluetoothScan.request().isGranted) {
        _showPermissionDialog('Bluetooth Scan');
        return false;
      }
    }

    if (await Permission.bluetoothConnect.isDenied) {
      if (!await Permission.bluetoothConnect.request().isGranted) {
        _showPermissionDialog('Bluetooth Connect');
        return false;
      }
    }
    return true;
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    scanSubscription.cancel();
    scanTimer?.cancel();
    _adapterStateSubscription.cancel();

    super.dispose();
  }


  void _showPermissionDialog(String permissionName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$permissionName Permission Required'),
          content: Text(
              'Please enable $permissionName permission in settings to scan and connect to Bluetooth devices.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }


  void scanning() async {
    if (!await requestPermissions()) {
      return;
    }

    setState(() {
      isScanning = true;
    });
    // Stop any ongoing scan before starting a new one
    await FlutterBluePlus.stopScan();

    // Start scanning for new devices
    FlutterBluePlus.startScan(timeout: Duration(seconds: 10));
    // Stop scan after 10 seconds
    scanTimer = Timer(Duration(seconds: 10), () async {
      await FlutterBluePlus.stopScan();
      setState(() {
        isScanning = false;
      });
    });
  }

  // Save the connected device's remoteId to SharedPreferences
  Future<void> _saveDeviceToSharedPreferences(BluetoothDevice device) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('connectedDeviceId', device.remoteId.toString());
  }

  // Remove the device ID from SharedPreferences when disconnected
  Future<void> _removeDeviceFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('connectedDeviceId');
  }

  void startAutomaticScanning() async {
    if (isScanning) return; // If already scanning, do nothing

    if (!await requestPermissions()) {
      return;
    }

    setState(() {
      isScanning = true; // Set scanning to true when starting
    });

    // Stop any ongoing scan before starting a new one
    await FlutterBluePlus.stopScan();

    // Start scanning for new devices, timeout increased for better coverage
    FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

    // Listen to the scan results
    FlutterBluePlus.scanResults.listen((results) async {
      print("Scan Results: ${results.length} devices found");

      // Filter out devices without a name
      List<ScanResult> filteredResults =
          results.where((result) => result.device.name.isNotEmpty).toList();

      // Log each scanned device
      for (var result in filteredResults) {
        print("Scanned Device: ${result.device.name}, RSSI: ${result.rssi}");
      }

      // Get the list of currently connected devices
      List<BluetoothDevice> connectedDevices = FlutterBluePlus.connectedDevices;
      print("Connected Devices: $connectedDevices");

      // Create a list to hold both the connected devices and the filtered scanned devices
      List<ScanResult> combinedResults = List.from(filteredResults);

      // Add the connected devices to the list of results if they are not already included
      for (var connectedDevice in connectedDevices) {
        // Check if the connected device is already in the scan results list
        bool isAlreadyPresent = combinedResults.any((result) =>
            result.device.id ==
            connectedDevice.id); // Use device.id for equality check

        print(
            "Checking connected device: ${connectedDevice.name}, already present: $isAlreadyPresent");

        if (!isAlreadyPresent) {
          print("Adding Connected Device: ${connectedDevice.name}");

          // Create a new ScanResult for the connected device
          ScanResult connectedResult = ScanResult(
            device: connectedDevice,
            advertisementData: AdvertisementData(
              advName: connectedDevice.name.isNotEmpty
                  ? connectedDevice.name
                  : "Connected Device",
              manufacturerData: {},
              serviceData: {},
              serviceUuids: [],
              txPowerLevel: null,
              connectable: true,
              appearance: null,
            ),
            rssi: 0, // Set RSSI to 0 for connected devices
            timeStamp: DateTime.now(),
          );

          // Add the connected device to the results list
          combinedResults.add(connectedResult);
        }
      }

      // Log the combined results for debugging
      print(
          "Combined Results after adding connected devices: ${combinedResults.length} devices found");
      for (var result in combinedResults) {
        print("Device: ${result.device.name}, RSSI: ${result.rssi}");
      }

      // Update the state with the combined results
      setState(() {
        scanResults = combinedResults;
        // _hasScanned = true; // Set to true once scanning is complete

        isScanning = false; // Stop scanning after data is loaded
      });

      // Save the loaded scan results to SharedPreferences (or another storage method)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'scanResults',
          jsonEncode(scanResults.map((result) {
            return {
              'deviceName': result.device.name,
              'deviceId': result.device.id.toString(),
              'rssi': result.rssi,
            };
          }).toList()));
      print("Scan results saved to SharedPreferences");
    });

    // Stop scan after the specified timeout
    scanTimer = Timer(Duration(seconds: 10), () async {
      await FlutterBluePlus.stopScan();
      setState(() {
        isScanning = false;
      });
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      if (connectedDevice != null && connectedDevice == device) {
        await connectedDevice!.disconnect();
        setState(() {
          connectedDevice = null;
        });
        _removeDeviceFromSharedPreferences;
        showDialog(
          context: context,
          builder: (context) {
            return Material(
              color: Colors.transparent,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10)
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Disconnected from ${device.name}",
                          style: TextStyle(color: Colors.white)),
                      TextButton(
                        child: Text('X', style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      } else {
        await device.connect();
        setState(() {
          connectedDevice = device;
        });
        String targetRemoteId = device.remoteId.toString();
        _saveDeviceToSharedPreferences;

        showDialog(
          context: context,
          builder: (context) {
            return Material(
              color: Colors.transparent,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10)
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Connected to ${device.name}",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      TextButton(
                        child: Text('X', style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ServicePage(
                                      scanResults: scanResults,
                                      targetRemoteId: targetRemoteId,
                                      device: device)));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      print("Error connecting to device: $e");
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Connection Failed'),
            content: Text('Failed to connect to the device. Please try again.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _disconnectDevice() async {
    try {
      await connectedDevice?.disconnect();
      setState(() {
        connectedDevice = null;
      });
    } catch (e) {
      print('Failed to disconnect: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(
        context); // Call this to ensure the `AutomaticKeepAliveClientMixin` works
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          if (isScanning)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Scanning for Bluetooth devices...',
                style: TextStyle(
                    fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: scanResults.length,
              itemBuilder: (context, index) {
                ScanResult result = scanResults[index];
                BluetoothDevice device = result.device;
                bool isConnected = connectedDevice == device;

                return ListTile(
                  title: Text(
                    device.name.isNotEmpty ? device.name : 'Unknown Device',
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                  subtitle: Text(
                    device.remoteId.toString(),
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                  onTap: () {
                    if (isConnected) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServicePage(
                            scanResults: scanResults,
                            targetRemoteId: device.remoteId.toString(),
                            device: device,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Device is not connected')),
                      );
                    }
                  },
                  trailing: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed:
                        connectedDevice != null && connectedDevice != device
                            ? null
                            : () async {
                                if (isConnected) {
                                  await _disconnectDevice();
                                } else {
                                  await _connectToDevice(device);
                                }
                              },
                    child: Text(isConnected ? 'Disconnect' : 'Connect',
                        style: TextStyle(
                            color: Colors.white, fontSize: screenWidth * 0.04)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
