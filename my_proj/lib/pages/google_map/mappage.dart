import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:my_proj/pages/google_map/search_city.dart';
import 'package:my_proj/pages/google_map/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:permission_handler/permission_handler.dart' as permissionHandler;
// import 'package:sensors_plus/sensors_plus.dart'; // Import the SearchCity screen

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Location location = Location();
  LatLng _currentLocation = LatLng(0, 0);
  Set<Marker> markers = {};
  bool _permissionGrantedPreviously = false;
  bool _permissionRequestedOnce = false;
  bool _hasPermission = false;

  // Check permission status when the app starts
// Function to check permission status on app start
  Future<void> _checkPermissionStatusOnStartup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the flag to check if permission was granted permanently
    bool permanentlyGrantedPreviously =
        prefs.getBool('permanentlyGranted') ?? false;
    print("permanentlyGrantedPreviously:${permanentlyGrantedPreviously}");
    // Get the current permission status
    PermissionStatus status = await location.hasPermission();
    print("Permission status on app start: $status");

    if (status == PermissionStatus.granted) {
      if (permanentlyGrantedPreviously == true) {
        // Proceed normally for permanently granted permissions
        print("Permission permanently granted. No action needed.");
        prefs.setBool('permanentlyGranted', true);
        _getCurrentLocation();
      } else {
        // Treat "Allow only this time" as denied after restart
        print(
            "Permission granted temporarily, treating as denied after restart.");
        prefs.setBool('permanentlyGranted', false); // Mark as not permanent
        prefs.setBool('permissionGrantedThisSession',
            false); // Track that it was temporarily granted

        askPermission();
        print("tttttttttttttttttttttttttt");
// Re-request permission
      }
    } else if (status == PermissionStatus.denied) {
      // Handle explicitly denied permissions
      print("Permission is denied. Requesting permission again.");
      prefs.setBool('permanentlyGranted', false); // Ensure it's reset
      askPermission(); // Re-request permission
    } else if (status == PermissionStatus.deniedForever) {
      // Handle "denied forever" case
      print("Permission is permanently denied. Please enable from settings.");
      prefs.setBool('permanentlyGranted', false); // Ensure it's reset
      // askPermission(); // Re-request permission
    }
  }

  Future<void> askPermission() async {
    bool _serviceEnabled;

    // Check if location services are enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print("Location service not enabled.");
        return;
      }
    }

    // Request location permission
    PermissionStatus status = await location.requestPermission();
    print("Permission status after request: $status");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (status == PermissionStatus.granted) {
      // Permission granted, get the current location
      prefs.setBool("permissionAskedThisSession", true);
      var currentLoc = await location.getLocation();
      setState(() {
        _currentLocation = LatLng(currentLoc.latitude!, currentLoc.longitude!);
      });

      // Move the camera to the current location
      if (mapController != null) {
        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(_currentLocation, 15.0),
        );
      }
    } else if (status == PermissionStatus.denied) {
      // askPermission();
      // Handle denied permissions
      print("Permission denied. No location access.");
    } else if (status == PermissionStatus.deniedForever) {
      // askPermission();
      // Handle permission permanently denied
      print("Permission permanently denied. Guide user to settings.");
      // Optionally, show a dialog prompting the user to enable permission from settings
    }
  }

  void _getCurrentLocation() async {
    bool _serviceEnabled;

    // Check if location services are enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }

    // Request location permission
    PermissionStatus status = await location.requestPermission();
    print("status of selected option: $status");

    if (status == PermissionStatus.granted) {
      // Permission granted, get the current location
      var currentLoc = await location.getLocation();
      setState(() {
        _currentLocation = LatLng(currentLoc.latitude!, currentLoc.longitude!);
      });

      // Move the camera to the current location
      if (mapController != null) {
        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(_currentLocation, 15.0),
        );
      }
    } else if (status == PermissionStatus.denied) {
      // return
      askPermission();
      // If permission is denied, show the access denied message and request again
      print("Permission denied");
      // No need to request again here, it's already handled in the same flow
    } else if (status == PermissionStatus.deniedForever) {
      _hasPermission = false;
      askPermission();
      // If permission is permanently denied, just request permission again when button is clicked
      print("Permission permanently denied");
      // Request again on button click (no immediate action needed here)
    }
  }

  void _onLocationSelected(LatLng newLocation) {
    // if(_hasPermission == true) {
    setState(() {
      _currentLocation = newLocation;
    });

    // Add a marker at the selected location
    markers.clear(); // Clear previous markers if you want only one marker
    markers.add(
      Marker(
        markerId: MarkerId(newLocation.toString()),
        position: newLocation,
        infoWindow: InfoWindow(title: "Selected Location"),
        icon: BitmapDescriptor.defaultMarker, // Default marker icon
      ),
    );
    // Move the camera to the selected location
    if (mapController != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation, 15.0),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkPermissionStatusOnStartup(); // _getCurrentLocation();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(mapStyle); // Apply the black theme
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Google Maps'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              // Open the search page to select a city
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SearchCity(onLocationSelected: _onLocationSelected)),
              );

              // Handle location selection from the search screen
              if (result != null) {
                _onLocationSelected(result);
              }
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLocation, // Default location
          zoom: 10.0,
        ),
        mapType: MapType.normal,
        markers: markers,
        myLocationButtonEnabled: true, // Disable the location button
        myLocationEnabled: true, // Enable the default red marker
        compassEnabled: true, // Enable compass
        tiltGesturesEnabled: true,
        rotateGesturesEnabled: true,
        onMapCreated: onMapCreated,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // Get current location on button press
              _getCurrentLocation();
            },
            child: Icon(Icons.my_location),
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
