import 'package:classic_bluetooth/classic_services/read_page.dart';
import 'package:classic_bluetooth/classic_services/write_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassicService extends StatefulWidget {
  final Map<String, dynamic> scannedDevice;
  final BluetoothConnection connection;
  final Function(String)? onValueWritten;

  const ClassicService(
      {super.key,
      required this.scannedDevice,
      required this.connection,
      this.onValueWritten});

  // const ClassicService({super.key, required this.scannedDevice, required this.connection}); // Add the connection field

  // const ClassicService({super.key, required this.scannedDevice});

  @override
  State<ClassicService> createState() => _ClassicServiceState();
}

class _ClassicServiceState extends State<ClassicService> {
  String receivedValue = '';

  @override

  void initState() {
    super.initState();
    _loadStoredValue();
  }

  void _handleValueWritten(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('receivedValue', value); // Store the value with a key

    setState(() {
      receivedValue = value; // Store the value received from the child
    });
    print("Value received from child: $value");
  }

  Future<void> _loadStoredValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      receivedValue = prefs.getString('receivedValue') ?? 'No value stored';
    });
    print("Stored value loaded: $receivedValue");
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.blue,
        title: Text(
          "Device Details",
          style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.05),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: widget.scannedDevice.isEmpty
            ? const Center(
                child: Text("No device details available."),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ADVERTIMENT DATA",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.05),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "connection:${widget.connection.isConnected}",
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    Divider(),
                    Text(
                      "${widget.scannedDevice['name']}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04),
                    ),
                    Text(
                      "Device Local Name",
                      style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.normal),
                    ),
                    Divider(),
                    Text(
                      "${widget.scannedDevice["address"]}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04),
                    ),
                    Text(
                      "Remote ID",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: screenWidth * 0.04),
                    ),
                    Divider(),
                    Text(
                      "${widget.scannedDevice["RSSI"]}",
                      style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Device RSSI(Recived Signal Strength Indicator)",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: screenWidth * 0.04),
                    ),
                    Divider(),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "SERVICES",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.05),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "CUSTOM SERVICES",
                      style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ClassicWritePage(
                                      connection: widget.connection,
                                      onValueWrittenData: _handleValueWritten,
                                    )));
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
                      child: Container(
                        // padding: const EdgeInsets.all(
                        //     1.0), // Optional padding to make the tap area larger

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "WRITE VALUE",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.05,
                              ),
                            ),
                            Spacer(), // Spacer to push the icon to the far right
                            Icon(
                              Icons.arrow_forward_ios, // Arrow icon
                              size: 20,
                              color: Colors
                                  .white, // Arrow color (you can customize this)
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    Text(
                      "Write",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04),
                    ),
                    Text(
                      "Properties",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: screenWidth * 0.04),
                    ),
                    Divider(),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Value - $receivedValue ",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: screenWidth * 0.04),
                    ),
                    Divider(),
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.push(context, MaterialPageRoute(builder: (context)=>ClassicReadPage(connection: widget.connection)));
                    //
                    //   },
                    //   child: Text(
                    //     "READ VALUE",
                    //     style: TextStyle(
                    //       color: Colors.blue,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 18,
                    //     ),
                    //   ),
                    // ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ClassicReadPage(
                                    connection: widget.connection)));
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
                      child: Container(
                        // padding: const EdgeInsets.all(
                        //     10.0), // Optional padding to make the tap area larger
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "READ VALUE",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.05,
                              ),
                            ),
                            Spacer(), // Spacer to push the icon to the far right
                            Icon(
                              Icons.arrow_forward_ios, // Arrow icon
                              size: 20,
                              color: Colors
                                  .white, // Arrow color (you can customize this)
                            ),
                          ],
                        ),
                      ),
                    ),

                    Divider(),
                    Text(
                      "Read",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04),
                    ),
                    Text(
                      "Properties",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: screenWidth * 0.04),
                    ),
                    Divider(),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Value - $receivedValue",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: screenWidth * 0.04),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
