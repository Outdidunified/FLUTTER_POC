import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';  // geocoding package for location search
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchCity extends StatefulWidget {
  final Function(LatLng) onLocationSelected;

  SearchCity({required this.onLocationSelected});

  @override
  _SearchCityState createState() => _SearchCityState();
}

class _SearchCityState extends State<SearchCity> {
  TextEditingController _controller = TextEditingController();
  String? _selectedCity;


  void _searchCity() async {
    String city = _controller.text;
    if (city.isNotEmpty) {
      try {
        // Get coordinates of the city using the geocoding package
        List<Location> locations = await locationFromAddress(city);
        print(locations);

        if (locations.isNotEmpty) {
          // Get the first location result
          Location location = locations[0];
          setState(() {
            _selectedCity = city; // Store the selected city name
          });
          print('City: $city, Latitude: ${location.latitude}, Longitude: ${location.longitude}'); // Debug statement

          // Pass the selected location back to the parent (MapScreen)
          widget.onLocationSelected(LatLng(location.latitude, location.longitude));

          Navigator.pop(context); // Close the search screen after selecting the location
        } else {
          print('No results found for city: $city'); // Debug: no result found
          setState(() {
            _selectedCity = null; // Clear the city if no result is found
          });
        }
      } catch (e) {
        print('Error searching city: $e'); // Catch errors and display them
        setState(() {
          _selectedCity = null; // Clear the city in case of error
        });
      }
    } else {
      print('Please enter a city name'); // Debug: no input
      setState(() {
        _selectedCity = null; // Clear the city if input is empty
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search for City')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter city name',
                hintText: 'e.g. New York',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchCity,
              child: Text('Search'),
            ),
            SizedBox(height: 20),
            if (_selectedCity != null)
              Text(
                'Selected City: $_selectedCity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            if (_selectedCity == null && _controller.text.isNotEmpty)
              Text(
                'No results found for the city.',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
