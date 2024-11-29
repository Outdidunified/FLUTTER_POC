import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:google_map/screens/search_city.dart'; // Import the SearchCity screen

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Location location = new Location();
  LatLng _currentLocation = LatLng(0, 0);
  Set<Marker> markers = {};

  void _getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionStatus;

    // Check if location services are enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }

    // Check if location permissions are granted
    _permissionStatus = await location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) return;
    }

    // Fetch the current location
    var currentLoc = await location.getLocation();
    setState(() {
      _currentLocation = LatLng(currentLoc.latitude!, currentLoc.longitude!);

      // Add a marker for the current location
      markers.add(
        Marker(
          markerId: MarkerId('current_location'),
          position: _currentLocation,
          infoWindow: InfoWindow(title: "You are here"),
        ),
      );
    });

    // Move the camera to the current location
    if (mapController != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation, 15.0),
      );
    }
  }

  // Callback function to update the map with the selected location
  void _onLocationSelected(LatLng newLocation) {
    setState(() {
      _currentLocation = newLocation;
      print("_currentLocation, $_currentLocation");
      markers.add(
        Marker(
          markerId: MarkerId('selected_location'),
          position: _currentLocation,
          infoWindow: InfoWindow(title: "Selected Location"),
        ),
      );
    });

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
      _getCurrentLocation();
    }

    void onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Google Maps'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                // Open the search page to select a city
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchCity(onLocationSelected: _onLocationSelected)),
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
            target: LatLng(12.972442, 77.580643), // Default location
            zoom: 10.0,
          ),
          mapType: MapType.normal,
          markers: markers,
          myLocationButtonEnabled: false,
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
