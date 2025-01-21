import 'package:classic_bluetooth/services/read_operation.dart';
import 'package:classic_bluetooth/services/write_operation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceDetailsPage extends StatefulWidget {
  final BluetoothService service;
  final BluetoothDevice device;
  final Function(String)? onValueWritten;

  const ServiceDetailsPage(
      {super.key,
      required this.service,
      required this.device,
      this.onValueWritten}); // Callback to pass the value back

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  String finaldata = '';
  String displayData = '';

  @override
  void initState() {
    super.initState();
    _listenToConnectionState();
    _loadStoredData();
  }

  void _listenToConnectionState() {
    widget.device.state.listen((state) {
      setState(() {});
    });
  }

  // This function will handle the data received from WritePage
  void _handleWrittenData(String writtenData) async {
    // Print the written data (you can log it for debugging)
    print('Data written: $writtenData');

    // Save the written data to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the written data (you can store the data with a key like 'writtenData')
    await prefs.setString('writtenData', writtenData);

    // Update the UI with the new data
    setState(() {
      finaldata = writtenData;
    });
  }

  // Load stored data from SharedPreferences
  Future<void> _loadStoredData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedData =
        prefs.getString('writtenData'); // Retrieve stored value
    if (storedData != null) {
      setState(() {
        finaldata = storedData; // Update the UI with the stored value
      });
    }
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
          "Service Details",
          style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.05),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "CUSTOM SERVICES",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: screenWidth * 0.05),
              ),
              Divider(),
              Text(
                "${widget.service.uuid}",
                style: TextStyle(
                    fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
              ),
              Text(
                "PRIMARY DEVICE",
                style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              Divider(),

              // List the characteristics of the service
              ...widget.service.characteristics.map((characteristic) {
                String uuid = characteristic.uuid.toString();
                List<Widget> characteristicDetails = [];

                // Check if the characteristic is writable and add it to the list
                if (characteristic.properties.write) {
                  characteristicDetails.add(Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$uuid",
                          style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "(CUSTOM)",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.04),
                        ),
                        Divider(),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     // Navigate to the WritePage and pass the onValueWritten callback
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => WritePage(
                        //           service: widget.service,
                        //           device: widget.device,
                        //           onValueWritten:
                        //               _handleWrittenData, // Pass the callback here
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Colors.blue,  // Background color
                        //     foregroundColor: Colors.white,  // Text and icon color
                        //     shadowColor: Colors.blueGrey,  // Shadow color
                        //     elevation: 5,  // Shadow depth for the floating effect
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(30),  // Rounded corners
                        //     ),
                        //     padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),  // Padding around button content
                        //   ),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,  // Center the row
                        //
                        //     children: [
                        //       Text(
                        //         "WRITE",
                        //         style: TextStyle(
                        //             color: Colors.white,
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: screenWidth * 0.05),
                        //       ),
                        //       Spacer(), // Spacer to push the icon to the far right
                        //       Icon(
                        //         Icons.arrow_forward_ios, // Arrow icon
                        //         size: 20,
                        //         // Size of the arrow
                        //         color: Colors
                        //             .white, // Arrow color (you can customize this)
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        ElevatedButton(
                            onPressed: () {
                              // Navigate to the WritePage and pass the onValueWritten callback
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WritePage(
                                    service: widget.service,
                                    device: widget.device,
                                    onValueWritten:
                                        _handleWrittenData, // Pass the callback here
                                  ),
                                ),
                              );
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
                            mainAxisAlignment: MainAxisAlignment.center,  // Center the row
                            children: [
                              Text(
                                "WRITE",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.05,
                                ),
                              ),
                              SizedBox(width: 10),  // Space between text and icon
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.white,  // Icon color
                              ),
                            ],
                          ),
                        ),

                        Divider(),
                        Text(
                          "Write",
                          style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Properties",
                          style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.normal),
                        ),
                        Divider(),
                        Text(
                          "Value - ${finaldata} ",
                          style: TextStyle(fontSize: screenWidth * 0.04),
                        ),
                        Divider()
                      ],
                    ),
                  ));
                }

                // Check if the characteristic is readable and add it to the list
                if (characteristic.properties.read) {
                  characteristicDetails.add(Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$uuid",
                          style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "(CUSTOM)",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.04),
                        ),
                        Divider(),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     // Navigate to the service details page
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => ReadPage(
                        //           service: widget.service,
                        //           device: widget.device,
                        //           characteristics:
                        //               widget.service.characteristics,
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   child: Container(
                        //     // Wrap the Row inside a Container for better touch handling
                        //     padding: const EdgeInsets.all(
                        //         10.0), // Optional padding to make the tap area larger
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       mainAxisSize: MainAxisSize.max,
                        //       children: [
                        //         Text(
                        //           "READ",
                        //           style: TextStyle(
                        //               color: Colors.blue,
                        //               fontWeight: FontWeight.bold,
                        //               fontSize: screenWidth * 0.05),
                        //         ),
                        //         Spacer(), // Spacer to push the icon to the far right
                        //         Icon(
                        //           Icons.arrow_forward_ios, // Arrow icon
                        //           size: 20,
                        //           color: Colors
                        //               .blue, // Arrow color (you can customize this)
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),

                        ElevatedButton(
                          onPressed: () {
                            // Navigate to the service details page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReadPage(
                                  service: widget.service,
                                  device: widget.device,
                                  characteristics: widget.service.characteristics,
                                ),
                              ),
                            );
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
                            mainAxisAlignment: MainAxisAlignment.center,  // Center the row
                            children: [
                              Text(
                                "READ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.05,
                                ),
                              ),
                              SizedBox(width: 10),  // Space between text and icon
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.white,  // Icon color
                              ),
                            ],
                          ),
                        ),

                        Divider(),
                        Text(
                          "Read",
                          style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Properties",
                          style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.normal),
                        ),
                        Divider(),
                        Text(
                          "Value - ${finaldata}",
                          style: TextStyle(fontSize: screenWidth * 0.04),
                        ),
                        Divider()
                      ],
                    ),
                  ));
                }

                // Return the list of characteristics that were either readable or writable
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: characteristicDetails,
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
