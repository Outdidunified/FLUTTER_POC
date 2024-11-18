import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocationMapPage(),
    );
  }
}

// Change the name to public
class LocationMapPage extends StatefulWidget {
  @override
  LocationMapPageState createState() => LocationMapPageState();
}

// Now use the state class without the leading underscore
class LocationMapPageState extends State<LocationMapPage> {
  late GoogleMapController mapController;
  late LatLng _currentLocation;

  @override
  void initState() {
    super.initState();
    _currentLocation = LatLng(37.7749, -122.4194); // San Francisco Coordinates
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location Map')),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 14.0, // Adjust the zoom level based on your needs
            ),
            markers: {
              Marker(
                markerId: MarkerId('current_location'),
                position: _currentLocation,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), // Red location icon
              ),
            },
          ),
          Positioned(
            bottom: 50,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                mapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _currentLocation,
                    zoom: 14.0,
                  ),
                ));
              },
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
