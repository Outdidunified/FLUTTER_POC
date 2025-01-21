import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassicWritePage extends StatefulWidget {
  final BluetoothConnection connection;
  final Function(String)? onValueWrittenData;

  const ClassicWritePage(
      {super.key, required this.connection, this.onValueWrittenData});

  // const ClassicWritePage({super.key, required this.connection});

  @override
  State<ClassicWritePage> createState() => _ClassicWritePageState();
}

class _ClassicWritePageState extends State<ClassicWritePage> {
  String hintText = "Enter Value";
  final TextEditingController _controller = TextEditingController();
  bool isHex = false;
  // String writtenData = ""; // To store the last written data
  String readValue = "No data read yet"; // To store the read data
  String _selectedMode = "Text"; // Default mode
  String writeData = ""; // To store the last written data

  // StreamSubscription to handle listening to the input stream

  @override
  void initState() {
    super.initState();
    _loadLastWrittenValue();
    // _loadLastReadValue();
  }

  //
  @override
  void dispose() {
    // Cancel the subscription when the widget is disposed to avoid memory leaks
    // _readSubscription?.cancel();
    super.dispose();
  }

  Future<void> writeDataAndVerify(String data) async {
    try {
      print("Checking connection status...");
      if (!widget.connection.isConnected) {
        throw Exception("Device is not connected.");
      }
      // Append '\n' to the data for sending
      String dataToSend = "$data\n";
      print("Data after appending newline: $dataToSend");

      // Convert data to bytes (Hex or UTF-8)
      List<int> originalBytes =
          isHex ? _hexToBytes(data) : utf8.encode(data); // Without \n
      List<int> bytesToSend =
          isHex ? _hexToBytes(dataToSend) : utf8.encode(dataToSend); // With \n
      print("Prepared data to send: $bytesToSend");

      // Send data to the device
      widget.connection.output.add(Uint8List.fromList(bytesToSend));
      await widget.connection.output.allSent; // Ensures all data is sent
      print("Data successfully sent to device: $bytesToSend");

      // Wait for a short delay
      await Future.delayed(Duration(milliseconds: 500));

      final prefs = await SharedPreferences.getInstance();
      String formattedData = 'Length: ${originalBytes.length}, '
          'Bytes: 0x${originalBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}, \n'
          'Value written in BLE: $data';
      await prefs.setString("writeData", formattedData);

      // Update the UI without including the newline character
      setState(() {
        writeData = formattedData;
      });
      print("writeData:$writeData");
      // Trigger the callback to update the value in the parent widget
      // Trigger the callback to update the value in the parent widget
      if (widget.onValueWrittenData != null) {
        setState(() {
          widget.onValueWrittenData!(writeData); // Pass the written data here
        });
      }
      print("widget.onValueWritten: ${widget.onValueWrittenData}");

      // Listen for the response from the device
      // await _listenForResponse();
    } catch (e) {
      print("Error during write operation: $e");
    }
  }


  //
  // Future<void> _listenForResponse() async {
  //   try {
  //     print("Waiting for response...");
  //     if (widget.connection.input == null) {
  //       throw Exception("Input stream is null. No data can be received.");
  //     }
  //
  //     // Listen for a single response from the device
  //     List<int> readData = await widget.connection.input!.first;
  //     print("Data read from device: $readData");
  //
  //     // Decode and handle the response
  //     String response = utf8.decode(readData).replaceAll(RegExp(r'[\r\n]+'), '');
  //     print("Decoded response: $response");
  //     final pref = await SharedPreferences.getInstance();
  //
  //
  //     String finalData = 'Length: ${readData.length}, '
  //         'Bytes: 0x${readData.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}, \n'
  //         'Value written in BLE: $response';
  //     await pref.setString("readValue", finalData);
  //
  //     // Update UI with response data in the required format
  //     setState(() {
  //       readValue = finalData;
  //     });
  //   } catch (e) {
  //     print("Error while waiting for response: $e");
  //   }
  // }

  List<int> _hexToBytes(String hex) {
    final buffer = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      buffer.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return buffer;
  }

  // Load the last written value from SharedPreferences
  Future<void> _loadLastWrittenValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedValue = prefs.getString('writeData');
    if (savedValue != null) {
      setState(() {
        writeData = savedValue;
      });
    }
  }

  // Load the last written value from SharedPreferences

  // Function to handle Hex input validation
  void _onHexInputChanged(String value) {
    // Allow only valid Hex characters (0-9, A-F, a-f)
    if (RegExp(r'^[0-9A-Fa-f]*$').hasMatch(value)) {
      setState(() {
        _controller.text =
            value.toUpperCase(); // Convert to uppercase for consistency
        _controller.selection = TextSelection.collapsed(
            offset: _controller.text.length); // Keep cursor at the end
      });
    }
  }

  // Function to handle Text input validation
  void _onTextInputChanged(String value) {
    setState(() {
      _controller.text = value;
      _controller.selection = TextSelection.collapsed(
          offset: _controller.text.length); // Keep cursor at the end
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    print("WriteConnection: ${widget.connection.isConnected}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.blue,
        title: Text("Write Operation",
            style:
                TextStyle(color: Colors.white, fontSize: screenWidth * 0.05)),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Status : ${widget.connection.isConnected}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04)),
              Divider(),
              Text("CUSTOM CHARACTERISTICS",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04)),
              Text("Status: ${widget.connection.isConnected}",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: screenWidth * 0.04)),
              Divider(),
              SizedBox(height: 18),
              // GestureDetector(
              //   onTap: () {
              //     showDialog(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return Dialog(
              //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              //           child: Container(
              //             padding: const EdgeInsets.all(16.0),
              //             child: Column(
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 const Text(
              //                   'Write Value',
              //                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              //                 ),
              //                 const SizedBox(height: 16),
              //                 TextField(
              //                   controller: _controller,
              //                   decoration: InputDecoration(
              //                     labelText: "Enter Value",
              //                     hintText: hintText,
              //                     border: const OutlineInputBorder(),
              //                   ),
              //                 ),
              //                 const SizedBox(height: 16),
              //                 Row(
              //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                   children: [
              //                     ElevatedButton(
              //                       onPressed: () {
              //                         setState(() {
              //                           hintText = "Hex Value";
              //                           isHex = true; // Set to Hex mode
              //                         });
              //                       },
              //                       child: const Text('Hex', style: TextStyle(fontSize: 18)),
              //                     ),
              //                     ElevatedButton(
              //                       onPressed: () {
              //                         setState(() {
              //                           hintText = "UTF-8 value";
              //                           isHex = false; // Set to Text mode
              //                         });
              //                       },
              //                       child: const Text('Text', style: TextStyle(fontSize: 18)),
              //                     ),
              //                   ],
              //                 ),
              //                 const SizedBox(height: 16),
              //                 Row(
              //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //                   children: [
              //                     TextButton(
              //                       onPressed: () {
              //                         Navigator.of(context).pop(); // Close dialog
              //                       },
              //                       child: const Text('Cancel', style: TextStyle(color: Colors.blue, fontSize: 18)),
              //                     ),
              //                     TextButton(
              //                       onPressed: () async {
              //                         String data = _controller.text.trim();
              //                         if (data.isNotEmpty) {
              //                           writeDataAndVerify(data);
              //                      // Call the writeData function
              //                           Navigator.of(context).pop(); // Close dialog
              //                         } else {
              //                           ScaffoldMessenger.of(context).showSnackBar(
              //                             const SnackBar(content: Text("Please enter a value")),
              //                           );
              //                         }
              //                       },
              //                       child: const Text('Write', style: TextStyle(color: Colors.blue, fontSize: 18)),
              //                     ),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           ),
              //         );
              //       },
              //     );
              //   },
              //   child: const Text(
              //     "Write Value",
              //     style: TextStyle(
              //       color: Colors.blue,
              //       fontWeight: FontWeight.bold,
              //       fontSize: 18,
              //     ),
              //   ),
              // ),

              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Dialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Title with icon
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: const [
                                          Icon(Icons.edit, color: Colors.blue),
                                          SizedBox(width: 8),
                                          Text(
                                            "Write Value",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.close,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  // Dropdown menu with modern style
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Mode",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      DropdownButton<String>(
                                        value: _selectedMode,
                                        items: const [
                                          DropdownMenuItem(
                                            value: "Text",
                                            child: Text("Text",
                                                style: TextStyle(fontSize: 16)),
                                          ),
                                          DropdownMenuItem(
                                            value: "Hex",
                                            child: Text("Hex",
                                                style: TextStyle(fontSize: 16)),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedMode = value!;
                                            _controller.clear();
                                          });
                                          debugPrint(
                                              "Dropdown selected: $_selectedMode");
                                        },
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 16),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // Input field with custom label
                                  TextField(
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      labelText: _selectedMode == "Hex"
                                          ? "Enter Hex Value"
                                          : "Enter Text",
                                      labelStyle:
                                          const TextStyle(color: Colors.blue),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    keyboardType: _selectedMode == "Hex"
                                        ? TextInputType.text
                                        : TextInputType.multiline,
                                    inputFormatters: _selectedMode == "Hex"
                                        ? [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9A-Fa-f]'))
                                          ]
                                        : null,
                                    onChanged: _selectedMode == "Hex"
                                        ? _onHexInputChanged
                                        : _onTextInputChanged,
                                  ),
                                  const SizedBox(height: 20),
                                  // Buttons with rounded corners
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _controller.clear();
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey[300],
                                          foregroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        child: const Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          String data = _controller.text.trim();
                                          if (data.isNotEmpty) {
                                            writeDataAndVerify(data);
                                            // Call the writeData function
                                            Navigator.of(context)
                                                .pop(); // Close dialog
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      "Please enter a value")),
                                            );
                                          }
                                          // if (writeCharacteristics.isNotEmpty) {
                                          //   writeData(writeCharacteristics.first);
                                          //   Navigator.pop(context);
                                          // } else {
                                          //   ScaffoldMessenger.of(context).showSnackBar(
                                          //     const SnackBar(
                                          //       content: Text("No write characteristics available."),
                                          //     ),
                                          //   );
                                          // }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        child: const Text("Write"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
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
                  children: [
                    Text(
                      "Write Value",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.05),
                    ),
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
              SizedBox(height: 10),
              Text("Value: ",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: screenWidth * 0.04)),
              SizedBox(height: 10),
              // Display the written data at the bottom
              Text(
                writeData.isNotEmpty ? writeData : "No data written yet",
                style: TextStyle(
                    fontSize: screenWidth * 0.04, fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 10),
              Text("Read Value:",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: screenWidth * 0.04)),
              SizedBox(height: 10),
              // Display the read data here
              Text(
                writeData.isNotEmpty ? writeData : "No data read yet",
                style: TextStyle(
                    fontSize: screenWidth * 0.04, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
