import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:online_bhangharwala/presentation/change_pickup_address/change_pickup_address.dart';
import 'package:online_bhangharwala/presentation/payment/payment.dart';
import 'package:online_bhangharwala/services/Apiservice.dart';
import 'package:online_bhangharwala/widgets/stepper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmDetailsPage extends StatefulWidget {
  final String selectedDateTimeSlot;
  final String slot;

  ConfirmDetailsPage({required this.selectedDateTimeSlot, required this.slot});

  @override
  _ConfirmDetailsPageState createState() => _ConfirmDetailsPageState();
}

class _ConfirmDetailsPageState extends State<ConfirmDetailsPage> {
  int _currentStep = 1; // 0 for Pickup date, 1 for Confirm
  String? _address;
  String _addressType = '';
  late LatLng _addressLatLng;
  late GoogleMapController _mapController;
  bool _isMapReady = false;
  bool _isDrawerExpanded = true; // Open drawer by default
  String _instructions = ''; // To store the TextField value
  String _landmark = ''; // To store the TextField value
  String _pin = ''; // To store the TextField value
  String _addr = ''; // To store the TextField value
  String _addrtype = ''; // To store the TextField value
  bool _isContinueButtonEnabled = false; // To manage the Continue button state

  @override
  void initState() {
    super.initState();
    _getCoordinatesFromAddress();
  }

  void _getCoordinatesFromAddress() async {
    try {
      final apiService = ApiService();
      final userDetails = await apiService.getUserInfoDetail();

      final String address = [
        userDetails['user']?['address'] ?? '',
        userDetails['user']?['address'] != null ? '\n' : '',
        userDetails['user']?['landmark'] ?? '',
        userDetails['user']?['pin'] ?? '',
      ].where((component) => component.isNotEmpty).join(' ');

      if (address.isEmpty) {
        throw Exception("Address is empty. Cannot fetch coordinates.");
      }

      final int? addressTypeValue = userDetails['user']?['address_type'];

      final String addr = userDetails['user']?['address'] ?? '';
      final String landmark = userDetails['user']?['landmark'] ?? '';
      final String pin = userDetails['user']?['pin'] ?? '';
      final String addrType =
          userDetails['user']?['address_type'].toString() ?? "";

      setState(() {
        _address = address;
        _addr = addr;
        _landmark = landmark;
        _pin = pin;
        _addrtype = addrType;

        switch (addressTypeValue) {
          case 1:
            _addressType = 'Home';
            break;
          case 2:
            _addressType = 'Business';
            break;
          case 3:
            _addressType = 'Friend and Family';
            break;
          default:
            _addressType = 'Other';
        }

        // Call this after setting the state to check the field status
        _checkAllFieldsFilled();
      });

      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        setState(() {
          _addressLatLng =
              LatLng(locations.first.latitude, locations.first.longitude);
          _isMapReady = true;
        });
      } else {
        throw Exception("No locations found for the address.");
      }
    } catch (e) {
      print('Error getting coordinates: $e');
    }
  }

  // void _checkAllFieldsFilled() {
  //   setState(() {
  //     print('Address: $_addr, Landmark: $_landmark, Pin: $_pin'); // Debug print
  //     _isContinueButtonEnabled =
  //         _addr.isNotEmpty && _landmark.isNotEmpty && _pin.isNotEmpty;
  //     print(
  //         'Continue Button Enabled: $_isContinueButtonEnabled'); // Debug print
  //   });
  // }

  void _checkAllFieldsFilled() {
    setState(() {
      _isContinueButtonEnabled =
          _addr.isNotEmpty && _landmark.isNotEmpty && _pin.isNotEmpty;
    });
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerExpanded = !_isDrawerExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF06193D),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Confirm Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 18 : 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: _isMapReady
                ? GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _addressLatLng,
                      zoom: 14.0,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.primaryDelta! < 0) {
                  _toggleDrawer();
                }
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: _isDrawerExpanded ? screenHeight * 0.8 : 50,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF06193D),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 8),
                    if (_isDrawerExpanded) ...[
                      StepProgressIndicator(currentStep: _currentStep),
                      SizedBox(height: 16),
                      _pickupConfirmation(),
                    ],
                    Spacer(),
                    if (_isDrawerExpanded)
                      ElevatedButton(
                        onPressed: _isContinueButtonEnabled
                            ? () {
                                final String pickUp =
                                    widget.selectedDateTimeSlot.split(' - ')[0];
                                final String timeSlot = widget.slot;

                                Navigator.pop(context);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentMethodScreen(
                                      pickUp: pickUp,
                                      timeSlot: timeSlot,
                                      instructions: _instructions,
                                      addrType: _addrtype,
                                      address: _addr,
                                      landmark: _landmark,
                                      pin: _pin,
                                    ),
                                  ),
                                );
                              }
                            : null, // Disable the button if fields are not filled
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: _isDrawerExpanded ? screenHeight * 0.8 - 20 : 0,
            right: screenWidth / 2 - 28,
            child: FloatingActionButton(
              backgroundColor: Color(0xFF06193D),
              onPressed: _toggleDrawer,
              child: Icon(
                _isDrawerExpanded
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pickupConfirmation() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pickup confirmation',
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 16 : 18,
            ),
          ),
          SizedBox(height: 16),
          _infoRow(
            'Address -  $_addressType',
            _address ?? '',
            'Edit',
            Icons.map,
          ),
          SizedBox(height: 16),
          _infoRow(
            widget.selectedDateTimeSlot.split(' - ')[0],
            widget.slot,
            '',
            Icons.date_range,
          ),
          SizedBox(height: 16),
          Text(
            'Any Instructions',
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 16 : 18,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            onChanged: (value) {
              setState(() {
                _instructions = value;
              });
            },
            maxLines: 3,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 14 : 16,
            ),
            decoration: InputDecoration(
              hintText: 'Optional instructions',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.6),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value, String action, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        if (action.isNotEmpty)
          TextButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangePickupAddressScreen()),
              );

              if (result != null) {
                final address = [
                  result['address'] + "\n",
                  result['landmark'],
                  result['pin'],
                ].where((component) => component.isNotEmpty).join(' ');

                setState(() {
                  _addr = result['address'];
                  _landmark = result['landmark'];
                  _pin = result['pin'];
                  _addressType = result['address_type'].toString();
                  _addrtype = result['addrType'].toString();
                  _address = address;

                  print(result['address_type'].toString());

                  print(_addrtype);
                  _checkAllFieldsFilled();
                });
                List<Location> locations = await locationFromAddress(address);
                if (locations.isNotEmpty) {
                  setState(() {
                    _addressLatLng = LatLng(
                        locations.first.latitude, locations.first.longitude);
                    _isMapReady = true;
                  });
                  _mapController.animateCamera(
                    CameraUpdate.newLatLng(_addressLatLng),
                  );
                } else {
                  throw Exception("No locations found for the address.");
                }
              }
            },
            child: Text(
              action,
              style: TextStyle(color: Colors.white),
            ),
          ),
      ],
    );
  }
}
