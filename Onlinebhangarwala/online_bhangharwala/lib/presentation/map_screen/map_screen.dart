import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:online_bhangharwala/presentation/k5_screen/k5_screen.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController; // Changed to nullable
  LatLng _currentLocation = LatLng(19.118214, 72.863352); // Default location
  Location _location = Location();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      // Permission granted
      _getCurrentLocation();
    } else if (status.isDenied) {
      // Permission denied
      print('Location permission denied');
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied
      openAppSettings();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final LocationData locationData = await _location.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          _currentLocation =
              LatLng(locationData.latitude!, locationData.longitude!);
        });
        if (_mapController != null) {
          _mapController!
              .animateCamera(CameraUpdate.newLatLngZoom(_currentLocation, 15));
        } else {
          print('Map controller is not initialized');
        }
      } else {
        print('Location data is null');
      }
    } catch (e) {
      // Handle errors
      print('Error getting location: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _getCurrentLocation(); // Fetch the current location once the map is created
  }

  void _onCompleteDetailsPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => K5Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 15,
            ),
            onMapCreated: _onMapCreated,
            markers: {
              Marker(
                markerId: MarkerId('current_location'),
                position: _currentLocation,
                infoWindow: InfoWindow(title: 'You are here'),
              ),
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onCompleteDetailsPressed,
                child: Text('Continue'),
                style: ElevatedButton.styleFrom(
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
