import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadPage extends StatefulWidget {
  final BluetoothService service;
  final BluetoothDevice device;
  final List<BluetoothCharacteristic> characteristics;

  const ReadPage({
    super.key,
    required this.service,
    required this.device,
    required this.characteristics,
  });

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  String hintText = "Enter Value";
  String readData = '';
  String displayData = '';
  bool _isOpen =
      false; // Variable to track whether the content is open or closed

  @override
  void initState() {
    super.initState();
    _listenToConnectionState();
    _loadLastWrittenData();
  }

  void _listenToConnectionState() {
    widget.device.state.listen((state) {
      setState(() {});
    });
  }

  // Load the last written data from SharedPreferences
  Future<void> _loadLastWrittenData() async {
    final prefs = await SharedPreferences.getInstance();
    String? lastWrittenData = prefs.getString('onValueWritten');
    if (lastWrittenData != null) {
      setState(() {
        displayData = lastWrittenData;
      });
    }
  }

  void _togglePage() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  // Save data in SharedPreferences

  Future<void> _readData(BluetoothCharacteristic characteristic) async {
    try {
      print("Reading data from characteristic: ${characteristic.uuid}");
      // Perform read operation
      List<int> data = await characteristic.read();
      print("Read data: $data"); // Convert bytes to a readable string (UTF-8)
      String value = String.fromCharCodes(data);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('bleData', displayData);

      print("Data stored in SharedPreferences: $displayData");

      setState(() {
        displayData =
            'Display Data: Length: ${data.length}, Bytes: 0x${data.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}, \nValue read from BLE: $value';
      });

      print("Read data: $displayData");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error reading data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // Filter the characteristics with the read property
    final readCharacteristics = widget.characteristics
        .where((characteristic) => characteristic.properties.read)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text("Read Operation",
            style:
                TextStyle(color: Colors.white, fontSize: screenWidth * 0.05)),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${widget.service.uuid}",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04)),
            Divider(),
            Text("CUSTOM CHARACTERISTICS",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: screenWidth * 0.05)),
            SizedBox(height: 10),
            if (readCharacteristics.isNotEmpty)
              ...readCharacteristics.map((characteristic) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "UUID: ${characteristic.uuid}",
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                );
              })
            else
              const Text(
                "No Read characteristics found.",
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            Text(
              "Status: ${widget.device.isConnected ? "Connected" : "Disconnected"}",
              style: TextStyle(fontSize: screenWidth * 0.04),
            ),
            Divider(),
            SizedBox(height: 16),
            Text("READ VALUE",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04)),
            Divider(),
            // const Text(
            //   "Read Value",
            //   style: TextStyle(
            //     color: Colors.blue,
            //     fontWeight: FontWeight.bold,
            //     fontSize: 18,
            //   ),
            // ),
            // Divider(),
            ElevatedButton(
              onPressed: () {
                if (readCharacteristics.isNotEmpty) {
                  _readData(readCharacteristics[
                      0]); // Read from the first characteristic
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('No read characteristics available')),
                  );
                }
                _togglePage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,  // Background color
                foregroundColor: Colors.white,  // Text and icon color
                shadowColor: Colors.blueGrey,  // Shadow color
                elevation: 5,  // Shadow depth for the floating effect
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),  // Rounded corners
                ),
                // padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),  // Padding around button content
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Read Value", // Display passed value or default message
                    style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        if (readCharacteristics.isNotEmpty) {
                          _readData(readCharacteristics[
                              0]); // Read from the first characteristic
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('No read characteristics available')),
                          );
                        }
                      },
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 20,
                      )),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios, // Arrow icon
                    size: 20,
                    // Size of the arrow
                    color: Colors.white, // Arrow color (you can customize this)
                  ),
                ],
              ),
            ),
            Divider(),
            Text(
              displayData,
              style: TextStyle(fontSize: screenWidth * 0.04),
            ), // Display the result of the read operation
          ],
        ),
      ),
    );
  }
}
