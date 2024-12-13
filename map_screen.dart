import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'search_page.dart';
import 'package:cached_network_image/cached_network_image.dart';


class HotelScreen extends StatefulWidget {
  @override
  _HotelScreenState createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  GoogleMapController? mapController;
  Location _location = Location();
  double? userLat;
  double? userLng;
  bool _isLocationEnabled = false;
  Set<Marker> _markers = {};
  List<dynamic> _hotels = [];
  CameraPosition? _initialPosition;
  String? selectedCity;
  double? cityLat;
  double? cityLng;
  double _radius=500;
  bool _isSliderVisible = false;
  bool _isViewingCurrentLocation = true;

  @override
  void initState() {
    super.initState();
    _initializeLocation(); // Fetch hotels near current location initially
  }

  Future<void> _initializeLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) return;
    }

    final locationData = await _location.getLocation();
    setState(() {
      userLat = locationData.latitude;
      userLng = locationData.longitude;
      _isLocationEnabled = true;
      _isViewingCurrentLocation = true;  // Set flag for current location
      _initialPosition = CameraPosition(
        target: LatLng(userLat!, userLng!),
        zoom: 10.0,
      );
    });
    _fetchNearbyHotels(); // Fetch hotels based on current location
  }

  Future<void> _fetchNearbyHotels() async {
    if (userLat != null && userLng != null && _isViewingCurrentLocation) {
      final response = await http.get(Uri.parse(
          'http://192.168.175.148:5000/api/hotels/nearby?lat=$userLat&lng=$userLng&radius=${_radius.toInt()}'));
      print(response);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _hotels = data['hotels'];
        });
        _addHotelMarkers(data['hotels']);
      }
    }
  }


  Future<void> _fetchCityCoordinates(String city) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$city&key=AIzaSyD4_6anlN09mZ1H6hhnfryibQdAWfygUbo'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        final lat = data['results'][0]['geometry']['location']['lat'];
        final lng = data['results'][0]['geometry']['location']['lng'];
        setState(() {
          cityLat = lat;
          cityLng = lng;
          _isViewingCurrentLocation = false;  // Set flag for city search
          _initialPosition = CameraPosition(
            target: LatLng(cityLat!, cityLng!),
            zoom: 12.0,
          );
        });

        // Animate the camera to the new city location
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(cityLat!, cityLng!),
              zoom: 12.0, // Adjust zoom level to fit the city view
            ),
          ),
        );

        // Fetch the hotels for the city
        _fetchHotels(cityLat!, cityLng!);  // Fetch hotels after getting coordinates
      }
    }
  }

  Future<void> _fetchHotels(double lat, double lng) async {
    String requestUrl =
        'http://192.168.175.148:5000/api/hotels/search?city=$selectedCity';  // API to search hotels by city name

    final response = await http.get(Uri.parse(requestUrl));
    print(response);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _hotels = data['hotels'];
        _markers.clear();  // Clear the previous markers
      });
      _addHotelMarkers(data['hotels']);
    }
  }

  void _addHotelMarkers(List hotels) {
    Set<Marker> markers = {};
    for (var hotel in hotels) {
      final hotelLat = hotel['coordinates']['coordinates'][1];
      final hotelLng = hotel['coordinates']['coordinates'][0];
      final hotelName = hotel['name'];
      final distance = hotel['distanceFromCityCenter'];  // Update to match backend response
      markers.add(
        Marker(
          markerId: MarkerId(hotelName),
          position: LatLng(hotelLat, hotelLng),
          infoWindow: InfoWindow(
              title: hotelName, snippet: 'Distance: $distance'),
        ),
      );
    }
    setState(() {
      _markers = markers;  // Set the markers for the fetched hotels
    });
  }


  void _animateToHotel(double lat, double lng) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 16.0, // Adjust zoom level for closer view
        ),
      ),
    );
  }
  Color _getSliderTrackColor(double radius) {
    // Define the thresholds for the different colors
    if (radius <= 3000) {
      // Red color for values up to 3 km
      return Colors.red;
    } else if (radius <= 7000) {
      // Green color for values between 3 km and 7 km
      return Colors.green;
    } else {
      // Blue color for values greater than 7 km
      return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  _isLocationEnabled && _initialPosition != null
                      ? GoogleMap(
                    initialCameraPosition: _initialPosition!,
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    // Disable default button
                    markers: _markers,
                  )
                      : const Center(child: CircularProgressIndicator()),
                  Positioned(
                    top: 30,
                    left: 10,
                    right: 10,
                    child: Column(
                      children: [
                        Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 4),
                                blurRadius: 6,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              hintText: selectedCity ?? 'Search City.......',
                              hintStyle: TextStyle(color: Colors.grey.shade600),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                    Icons.search, color: Colors.blue),
                                onPressed: () async {
                                  final city = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchScreen()),
                                  );
                                  if (city != null) {
                                    SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                    prefs.setString('selectedCity', city);
                                    setState(() {
                                      selectedCity = city;
                                    });
                                    _fetchCityCoordinates(
                                        city); // Show hotels in searched city
                                  }
                                },
                              ),
                              prefixIcon: selectedCity != null
                                  ? IconButton(
                                icon: Icon(Icons.clear, color: Colors.blueGrey),
                                onPressed: () async {
                                  SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                                  prefs.remove('selectedCity');
                                  setState(() {
                                    selectedCity = null;
                                    cityLat = null;
                                    cityLng = null;
                                    _markers.clear();
                                    _hotels.clear();
                                    _initialPosition = null;
                                  });
                                  _initializeLocation(); // Go back to current location hotels
                                },
                              )
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      // Positioned Toggle Button
                      Positioned(
                        top: 80, // Adjust as per your layout
                        left: 10, // Align to the left side
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            // Toggle Button to show/hide the Slider
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isSliderVisible = !_isSliderVisible;
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                width: _isSliderVisible ? 35.0 : 35.0,
                                height: 60.0,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _isSliderVisible
                                          ? Icons.arrow_right
                                          : Icons.arrow_left,
                                      color: Colors.white,
                                      size: 35.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Slider positioned beside the toggle button
                      Positioned(
                        top: 100, // Keep aligned to the same height as the button
                        left: 38, // Position the slider next to the button
                        child: AnimatedOpacity(
                          opacity: _isSliderVisible ? 1.0 : 0.0, // Hide when not visible
                          duration: const Duration(milliseconds: 300),
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 4.0, // Reduced track height for a thinner line
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 12, // Thumb size for better visibility
                                elevation: 4,
                              ),
                              activeTrackColor: _getSliderTrackColor(_radius),
                              inactiveTrackColor: Colors.blueGrey.shade200,
                              thumbColor: Colors.white, // Use white for a contrasting thumb
                              overlayColor: Colors.blueAccent.withOpacity(0.2),
                              valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                              valueIndicatorColor: Colors.blueAccent,
                              valueIndicatorTextStyle: const TextStyle(color: Colors.white),
                            ),
                            child: Slider(
                              value: _radius,
                              min: 50,
                              max: 10000,
                              divisions: 199,
                              label: "${(_radius / 1000).toStringAsFixed(1)} km",
                              onChanged: (double value) {
                                setState(() {
                                  _radius = value;
                                });
                                _fetchNearbyHotels();
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),



                  Positioned(
                    top: 400,
                    // Vertical positioning from the top
                    right: 6,
                    // Positioning the icon at the rightmost edge of the screen
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // Background color of the box
                        borderRadius: BorderRadius.circular(12),
                        // Optional: to give rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 2), // Position of the shadow
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.my_location,
                          // Unique icon (you can replace this with any custom icon)
                          size: 30,
                          color: Colors.blueGrey, // Custom color for the icon
                        ),
                        onPressed: _fetchNearbyHotels, // Function to fetch nearby hotels
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: _hotels.isNotEmpty
                  ? PageView.builder(
                controller: PageController(viewportFraction: 0.9),
                itemCount: _hotels.length,
                itemBuilder: (context, index) {
                  final hotel = _hotels[index];
                  return GestureDetector(
                    onTap: () {
                      _animateToHotel(
                        hotel['coordinates']['coordinates'][1],
                        hotel['coordinates']['coordinates'][0],
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 4.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hotel['name'],
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6.0),
                                  const Divider(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.orange,
                                          size: 22.0),
                                      const SizedBox(width: 6.0),
                                      Text(
                                        hotel['rating'].toString(),
                                        style: const TextStyle(
                                          fontSize: 10.0,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6.0),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          color: Colors.green, size: 22.0),
                                      const SizedBox(width: 6.0),
                                      Expanded(
                                        child: Text(
                                          hotel['address'],
                                          style: const TextStyle(
                                            fontSize: 10.0,
                                            color: Colors.black54,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6.0),
                                  Row(
                                    children: [
                                      const Icon(
                                          Icons.access_time, color: Colors.blue,
                                          size: 20.0),
                                      const SizedBox(width: 6.0),
                                      Text(
                                        'Distance: ${hotel['distanceFromCityCenter']}',
                                        style: const TextStyle(
                                          fontSize: 10.0,
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12.0),
                                bottomRight: Radius.circular(12.0),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: hotel['image'],
                                fit: BoxFit.cover,
                                height: double.infinity,
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.image, size: 50.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                onPageChanged: (index) {
                  final hotel = _hotels[index];
                  _animateToHotel(
                    hotel['coordinates']['coordinates'][1],
                    hotel['coordinates']['coordinates'][0],
                  );
                },
              )
                  : const Center(child: Text('No hotels found')),
            ),
          ],
        ),
      ),
    );
  }
}