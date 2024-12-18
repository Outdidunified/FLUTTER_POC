import 'package:flutter/material.dart';
import 'package:my_proj/pages/google_map/mappage.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermission extends StatefulWidget {
  const LocationPermission({super.key});

  @override
  State<LocationPermission> createState() => _LocationPermissionState();
}

class _LocationPermissionState extends State<LocationPermission> {
  bool isLocationEnabled = false;

  @override
  void initState() {
    super.initState();
    // Request location permission when the widget is loaded
    checkLocationPermission();
  }

  Future<void> checkLocationPermission() async {
    PermissionStatus status = await Permission.location.status;

    if (status.isGranted) {
      setState(() {
        isLocationEnabled = true;
      });
    } else {
      // Automatically request location permission if not granted
      PermissionStatus requestStatus = await Permission.location.request();

      if (requestStatus.isGranted) {
        setState(() {
          isLocationEnabled = true;
        });
      } else if (requestStatus.isDenied) {
        // Handle denied permission
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
        setState(() {
          isLocationEnabled = false;
        });
      } else if (requestStatus.isPermanentlyDenied) {
        // Handle permanently denied permission
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Location permission permanently denied. Please enable it from settings.'),
          ),
        );
        await openAppSettings();
        setState(() {
          isLocationEnabled = false;
        });
      }
    }
  }

  Future<void> toggleLocationPermission(bool value) async {
    if (value) {
      PermissionStatus status = await Permission.location.request();
                 print("status:${status}");
      if (status.isGranted) {
        setState(() {
          isLocationEnabled = true;
        });
        // Navigate to the Google Map screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  MapScreen()),
        );
      } else if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
        setState(() {
          isLocationEnabled = false;
        });
      } else if (status.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Location permission permanently denied. Please enable it from settings.'),
          ),
        );
        await openAppSettings();
        setState(() {
          isLocationEnabled = false;
        });
      }
    } else {
      setState(() {
        isLocationEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.location_on),
      title: const Text("Location"),
      trailing: Switch(
        value: isLocationEnabled,
        onChanged: (value) {
          toggleLocationPermission(value);
        },
      ),
    );
  }
}
