import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class SearchCity extends StatefulWidget {
  final Function(LatLng) onLocationSelected;

  SearchCity({required this.onLocationSelected});

  @override
  _SearchCityState createState() => _SearchCityState();
}

class _SearchCityState extends State<SearchCity> {
  TextEditingController _controller = TextEditingController();
  List<String> places = [];
  final Uuid uuid = Uuid();
  String sessionToken = '';

  /// Fetch place suggestions dynamically
  Future<void> _fetchPlaceSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() {
        places = [];
      });
      return;
    }

    // Generate session token if not already available
    if (sessionToken.isEmpty) {
      sessionToken = uuid.v4();
    }

    final String apiKey = 'AIzaSyD4_6anlN09mZ1H6hhnfryibQdAWfygUbo'; // Replace with your API key
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&sessiontoken=$sessionToken';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List predictions = data['predictions'];
        setState(() {
          places = predictions.map((p) => p['description'] as String).toList();
        });
      } else {
        print('Failed to fetch places: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching places: $e');
    }
  }

  /// Search for city coordinates
  Future<void> _searchCity(String place) async {
    try {
      // Get coordinates using geocoding
      List<Location> locations = await locationFromAddress(place);
      if (locations.isNotEmpty) {
        Location location = locations[0];
        widget.onLocationSelected(LatLng(location.latitude, location.longitude));
        setState(() {
          _controller.text = place; // Update the text field
          places = []; // Clear suggestions
        });
        Navigator.pop(context); // Close the search screen
      }
    } catch (e) {
      print('Error searching city: $e');
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
              onChanged: _fetchPlaceSuggestions,
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: places.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(places[index]),
                    onTap: () => _searchCity(places[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
