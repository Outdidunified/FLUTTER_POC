import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WritePage extends StatefulWidget {
  final BluetoothService service;
  final BluetoothDevice device;
  final Function(String)? onValueWritten;

  const WritePage(
      {super.key,
      required this.service,
      required this.device,
      this.onValueWritten});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  String hintText = " ";
  TextEditingController _controller = TextEditingController();
  bool isHex = false; // Flag to track Hex/Text mode
  String _lastWrittenValue = ""; // Store the last written value
  String _selectedMode = "Text"; // Default mode

  @override
  void initState() {
    super.initState();
    _listenToConnectionState();
    _loadLastWrittenValue();
  }

  // Listen to connection state changes
  void _listenToConnectionState() {
    widget.device.state.listen((state) {
      setState(() {});
    });
  }

  // Function to write data to Bluetooth characteristic
  Future<void> writeData(BluetoothCharacteristic characteristic) async {
    if (_controller.text.isNotEmpty) {
      try {
        List<int> data;
        if (isHex) {
          // Convert Hex string to bytes
          data = _hexToBytes(_controller.text);
        } else {
          // Convert text to bytes (UTF-8 encoding)
          data = _controller.text.codeUnits;
        }
        print("data:${data}");
        // Write the data to the characteristic
        await characteristic.write(data);

        // Save the last written value in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String writtenValue =
            'Length: ${data.length}, Bytes: 0x${data.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}, \nValue written in BLE: ${_controller.text}';
        prefs.setString('lastWrittenValue', writtenValue);
        print("writtenValue:${writtenValue}");
        // Update the UI with the last written value
        setState(() {
          _lastWrittenValue = writtenValue;
        });

        // Trigger the callback to update the value in the parent widget
        if (widget.onValueWritten != null) {
          widget.onValueWritten!(_lastWrittenValue);
        }
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error writing data: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter some data to write')),
      );
    }
  }

  // Convert Hex string to List<int>
  List<int> _hexToBytes(String hex) {
    hex = hex.replaceAll(" ", ""); // Remove spaces
    List<int> bytes = [];
    for (int i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return bytes;
  }

  // Load the last written value from SharedPreferences
  Future<void> _loadLastWrittenValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedValue = prefs.getString('lastWrittenValue');
    if (savedValue != null) {
      setState(() {
        _lastWrittenValue = savedValue;
      });
    }
  }

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
    final writeCharacteristics = widget.service.characteristics
        .where((characteristic) => characteristic.properties.write)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text("Write Operation",
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
            if (writeCharacteristics.isNotEmpty)
              ...writeCharacteristics.map((characteristic) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text("UUID: ${characteristic.uuid}",
                      style: TextStyle(fontSize: screenWidth * 0.04)),
                );
              }).toList()
            else
              const Text("No write characteristics found.",
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
            Text(
              "Status: ${widget.device.isConnected ? "Connected" : "Disconnected"}",
              style: TextStyle(fontSize: screenWidth * 0.04),
            ),
            Divider(),
            SizedBox(height: 16),
            Text("WRITE VALUE",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04)),
            Divider(),
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
                                        if (writeCharacteristics.isNotEmpty) {
                                          writeData(writeCharacteristics.first);
                                          Navigator.pop(context);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "No write characteristics available."),
                                            ),
                                          );
                                        }
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
                        fontSize: 18),
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
            SizedBox(
              height: 5,
            ),
            Divider(),
            if (_lastWrittenValue.isNotEmpty) ...[
              Text("LAST WRITTEN VALUE:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.04)),
              const SizedBox(height: 8),
              Text(
                _lastWrittenValue,
                style: TextStyle(
                    fontSize: screenWidth * 0.04, color: Colors.black),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
