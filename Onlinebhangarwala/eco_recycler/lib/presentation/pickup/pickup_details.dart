import 'dart:async';
import 'dart:convert';
import 'package:eco_recycler/presentation/cancel_reason/cancel_reason.dart';
import 'package:eco_recycler/presentation/pickup/confirmation.dart';
import 'package:eco_recycler/services/Apiservice.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PickUpDetailsScreen extends StatefulWidget {
  final String pickupId;

  const PickUpDetailsScreen({required this.pickupId, Key? key}) : super(key: key);

  @override
  _PickUpDetailsScreenState createState() => _PickUpDetailsScreenState();
}

class _PickUpDetailsScreenState extends State<PickUpDetailsScreen> {
  late GoogleMapController _mapController;
  LatLng _currentLocation = LatLng(0, 0);
  late LatLng _destinationLocation;
  late StreamSubscription<Position> _positionStream;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  double _distance = 0.0;
  double _estimatedTime = 0.0;
  bool _hasReachedDestination = false;
  bool _isDrawerExpanded = false;

  String _address = '';
  String _landmark = '';
  String _pin = '';
  String _pickupDate = '';
  String _pickupTime = '';
  String _name = '';
  String _mobile = '';

  @override
  void initState() {
    super.initState();
    _fetchPickupDetails();
    _checkPermissionsAndGetLocation();
  }

  Future<void> _fetchPickupDetails() async {
    try {
      final ApiService apiService = ApiService();
      final response = await apiService.GetEcoRecyclerPickUP();
      final data = jsonDecode(response.body);
      if (data['pickEco'] != null && data['pickEco'].isNotEmpty) {
        final pickupDetails = data['pickEco'][0];
        final String address = [
          pickupDetails['address'] ?? '',
          "\n",
          pickupDetails['landmark'] ?? '',
          pickupDetails['pin'] != null ? pickupDetails['pin'].toString() : '',
        ].where((component) => component.isNotEmpty).join(' ');

        setState(() {
          _address = address;
          _pickupDate = pickupDetails['pick_up_date'];
          _name = pickupDetails['firstname'];
          _pickupTime = pickupDetails['time_slot'];
          _mobile = pickupDetails['mobile'];
        });

        final List<Location> locations = await locationFromAddress(address);
        if (locations.isNotEmpty) {
          setState(() {
            _destinationLocation = LatLng(
              locations.first.latitude,
              locations.first.longitude,
            );
          });
        }
      }
    } catch (e) {
      print('Error fetching pickup details: $e');
    }
  }

  Future<void> _checkPermissionsAndGetLocation() async {
    final status = await Permission.location.status;
    if (status.isGranted) {
      _getCurrentLocation();
    } else if (status.isDenied) {
      if (await Permission.location.request().isGranted) {
        _getCurrentLocation();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permission is required for this feature.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to access location.')),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _updateMarkers();
      });

      _fetchRealTimeData();
      _positionStream = Geolocator.getPositionStream(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      ).listen((Position position) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _updateMarkers();
          _mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: _currentLocation, zoom: 16.0),
            ),
          );
          _fetchRoute();
          _fetchRealTimeData();

          if (_isDestinationReached()) {
            setState(() {
              _hasReachedDestination = true;
            });
            _showDestinationReachedDialog();
          }
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving location: $e')),
      );
    }
  }

  void _showDestinationReachedDialog() {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents dismissal by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 30),
            SizedBox(width: 10),
            Text('Destination Reached'),
          ],
        ),
        content: Text(
          'Congratulations! You have arrived at your destination.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            child: Text('OK', style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


  Future<void> _fetchRealTimeData() async {
    final apiKey = 'AIzaSyDQM2wKHgnZBvh6Ekub-Sdn6CYkiPutokI';
    final origins = '${_currentLocation.latitude},${_currentLocation.longitude}';
    final destinations = '${_destinationLocation.latitude},${_destinationLocation.longitude}';

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/distancematrix/json?key=$apiKey&origins=$origins&destinations=$destinations&mode=driving',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final distance = data['rows'][0]['elements'][0]['distance']['value'] as int;
        final duration = data['rows'][0]['elements'][0]['duration']['value'] as int;

        setState(() {
          _distance = distance.toDouble(); 
          _estimatedTime = duration / 60; 
        });
      } else {
        throw Exception('Failed to load distance and time data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching real-time data: $e')),
      );
    }
  }

  Future<void> _fetchRoute() async {
    final apiKey = 'AIzaSyDQM2wKHgnZBvh6Ekub-Sdn6CYkiPutokI';
    final origin = '${_currentLocation.latitude},${_currentLocation.longitude}';
    final destination = '${_destinationLocation.latitude},${_destinationLocation.longitude}';

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final route = data['routes'][0]['overview_polyline']['points'];
        _updatePolyline(_decodePolyline(route));
      } else {
        throw Exception('Failed to load route data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching route data: $e')),
      );
    }
  }

  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  void _updateMarkers() {
    _markers = {
      Marker(
        markerId: MarkerId('currentLocation'),
        position: _currentLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
      Marker(
        markerId: MarkerId('destinationLocation'),
        position: _destinationLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };
  }

  void _updatePolyline(List<LatLng> polylinePoints) {
    setState(() {
      _polylines = {
        Polyline(
          polylineId: PolylineId('route'),
          visible: true,
          points: polylinePoints,
          color: Colors.blueAccent,
          width: 6,
          patterns: [PatternItem.dash(20), PatternItem.gap(10)],
        ),
      };
    });
  }


  bool _isDestinationReached() {
    const threshold = 50.0; // 50 meters threshold for reaching the destination
    final distance = Geolocator.distanceBetween(
      _currentLocation.latitude,
      _currentLocation.longitude,
      _destinationLocation.latitude,
      _destinationLocation.longitude,
    );
    return distance <= threshold;
  }

  @override
  void dispose() {
    _positionStream.cancel();
    _mapController.dispose();
    super.dispose();
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerExpanded = !_isDrawerExpanded;
    });
  }


Widget _buildDrawerHeader() {
    return Column(
      children: [
        const SizedBox(height: 8),
        GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta! < 0) _toggleDrawer();
          },
          child: Container(
            width: 60,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDrawerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "OB ID: ${widget.pickupId}",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle reject action
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CancellationReasonScreen(
                      pickupId: widget.pickupId, // Pass the ID here
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Reject',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Text(
              _name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              _pickupDate,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.access_time, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              _pickupTime,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _address,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Handle call action
                final Uri telUri = Uri(scheme: 'tel', path: '+91' + _mobile);
                if (await canLaunchUrl(telUri)) {
                  await launchUrl(telUri);
                } else {
                  // Handle the error, e.g., show a message to the user
                  print('Could not launch $telUri');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Call',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle start action
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmationScreen(
                      pickupId: widget.pickupId,
                      pickupdate: _pickupDate,
                      pickuptime: _pickupTime,
                      name: _name,
                      address: _address,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5663FF),
              ),
              child: const Text(
                'Start',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
        final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF06193D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Pickup Details',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 14.0,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
           Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                _toggleDrawer();
              },
              child: AnimatedContainer(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 300),
                height: _isDrawerExpanded
                    ? screenHeight * 0.6
                    : 60, // Reduced height
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFF06193D),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    _buildDrawerHeader(),
                    if (_isDrawerExpanded) ...[
                      const SizedBox(height: 16),
                      Expanded(child: _buildDrawerContent()),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            child: Column(
              children: [
              
                if (!_hasReachedDestination)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 8.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Distance: ${(_distance / 1000).toStringAsFixed(2)} km',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Estimated Time: ${_estimatedTime.toStringAsFixed(2)} minutes',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
