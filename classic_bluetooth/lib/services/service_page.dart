import 'package:classic_bluetooth/services/custom_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ServicePage extends StatefulWidget {
  final List<ScanResult> scanResults; // List of ScanResult objects
  final String targetRemoteId; // The remoteId to filter by
  final BluetoothDevice device;

  const ServicePage({
    super.key,
    required this.scanResults,
    required this.targetRemoteId,
    required this.device,
  });

  // const ServicePage({
  //   super.key,
  //   required this.scanResults,
  //   required this.targetRemoteId,
  //   required this.device,
  // });

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  List<BluetoothService> _services = [];
  FlutterBluePlus flutterBluePlus =
      FlutterBluePlus(); // Define flutterBluePlus here

  @override
  void initState() {
    super.initState();
    _getDeviceServices();
    _listenToConnectionState();
  }

  void _listenToConnectionState() {
    widget.device.state.listen((state) {
      setState(() {});
    });
  }
  // void _listenToConnectionState() {
  //   widget.device.state.listen((connectionState) {
  //     if (!mounted) return; // Check if widget is still mounted
  //     setState(() {
  //       // Update the connection state here
  //       if (connectionState == BluetoothDeviceState.connected) {
  //         // Handle connected state
  //         print("Connected to ${widget.device.name}");
  //       } else if (connectionState == BluetoothDeviceState.disconnected) {
  //         // Handle disconnected state
  //         print("Disconnected from ${widget.device.name}");
  //       }
  //     });
  //   });
  // }

  // Function to discover services for the connected device
  Future<void> _getDeviceServices() async {
    try {
      // Connect to the device if not already connected
      await widget.device.connect();

      // Discover the services for the device
      List<BluetoothService> services = await widget.device.discoverServices();
      print("connectedStatus:${services}");

      // Filter out standard Bluetooth UUIDs based on their length or pattern
      List<BluetoothService> customServices = services.where((service) {
        return _isCustomUuid(service.uuid.toString());
      }).toList();
      setState(() {
        _services = customServices; // Store the filtered services
      });
    } catch (e) {
      print("Error discovering services: $e");
    }
  }

  // Function to check if a UUID is custom (based on length and format)
  bool _isCustomUuid(String uuid) {
    // Standard Bluetooth UUIDs are typically shorter (e.g., 4-6 characters, like 1800)
    // Custom UUIDs are usually longer (e.g., 128-bit UUIDs)
    return uuid.length > 4; // Adjust this length based on your needs
  }
  // @override
  // void initState() {
  //   super.initState();
  //   _getDeviceServices();
  // }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // Filter for the specific remoteId
    final filteredResults = widget.scanResults
        .where(
          (result) => result.device.id.toString() == widget.targetRemoteId,
        )
        .toList();

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
        child: filteredResults.isEmpty
            ? const Center(
                child: Text("Device not found."),
              )
            : SingleChildScrollView(
                // Use SingleChildScrollView to allow scrolling
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display filtered results
                      ...filteredResults.map((result) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Device Name Header
                            Container(
                              child: Text(
                                "ADVERTIMENT DATA",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Divider(),
                            Text(
                              "Device Name:",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider(), // Divider after header
                            Text(
                              result.advertisementData.localName.isNotEmpty
                                  ? result.advertisementData.localName
                                  : "Unknown Device",
                              style: TextStyle(fontSize: screenWidth * 0.04),
                            ),
                            Divider(), // Divider after data

                            // Remote ID Header
                            Text(
                              "Remote ID:",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider(), // Divider after header
                            Text(result.device.id.toString(),
                                style: TextStyle(fontSize: screenWidth * 0.04)),
                            Divider(), // Divider after data

                            // RSSI Header
                            Text(
                              "RSSI:",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider(), // Divider after header
                            Text(result.rssi.toString(),
                                style: TextStyle(fontSize: screenWidth * 0.04)),
                            Divider(), // Divider after data

                            // Connectable Header
                            Text(
                              "Connectable:",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider(), // Divider after header
                            Text(
                              result.advertisementData.connectable
                                  ? "Yes"
                                  : "No",
                              style: TextStyle(fontSize: screenWidth * 0.04),
                            ),
                            Divider(), // Divider after data

                            // Tx Power Level Header
                            Text(
                              "Tx Power Level:",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider(), // Divider after header
                            Text(
                              result.advertisementData.txPowerLevel
                                      ?.toString() ??
                                  "Unknown",
                              style: TextStyle(fontSize: screenWidth * 0.04),
                            ),
                            Divider(),
                            SizedBox(height: 20),
                            Text("SERVICES",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.05)),
                            Divider(),
                            Text(
                              "CUSTOM SERVICES",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider()
                          ],
                        );
                      }).toList(),

                      // Services Section
                      if (_services.isNotEmpty) ...[
                        // const SizedBox(height: 16),
                        ..._services.where((service) {
                          // Filter out services based on the length of their UUID string (directly from service.uuid)
                          // Example: Filter out standard 4-character UUIDs like "1800", "1801", etc.
                          return service.uuid.toString().length >
                              4; // Only display services with UUIDs longer than 4 characters
                        }).map((service) {
                          // Print for debugging
                          print("uuid:${service.uuid}");

                          return Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Navigate to the service details page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ServiceDetailsPage(
                                          service: service,
                                          device: widget.device,
                                          onValueWritten: null,
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
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text(
                                          service.uuid
                                              .toString(), // Directly display the UUID as a string
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.04,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios, // Arrow icon
                                          size: 20,
                                          // Size of the arrow
                                          color: Colors
                                              .grey, // Arrow color (you can customize this)
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "PRIMARY SERVICE",
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.04),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ]
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
