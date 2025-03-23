import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:online_bhangharwala/core/utils/image_constant.dart';
import 'package:online_bhangharwala/presentation/k6_screen/k6_screen.dart';
import 'package:online_bhangharwala/presentation/reschedule/reschedule.dart';
import 'package:online_bhangharwala/services/Apiservice.dart';

class TrackPickupRequestPage extends StatefulWidget {
  final String pickupId;

  TrackPickupRequestPage({required this.pickupId});

  @override
  _TrackPickupRequestPageState createState() => _TrackPickupRequestPageState();
}

class _TrackPickupRequestPageState extends State<TrackPickupRequestPage> {
  late Future<Map<String, dynamic>> _pickupData;
  String? pickup_data;
  String? pickup_time;
  String? pickup_address;
  String _addressType = 'Other';
  String? _instruction;
  String? _selectedReason;

  void _showCancellationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Tell us your reason for cancellation'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RadioListTile<String>(
                  title: const Text('I will not be available at the address.'),
                  value: 'I will not be available at the address.',
                  groupValue: _selectedReason,
                  onChanged: (value) {
                    setState(() {
                      _selectedReason = value;
                    });
                    Navigator.of(context).pop();
                    _showCancellationDialog();
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Already sold to other vendor.'),
                  value: 'Already sold to other vendor',
                  groupValue: _selectedReason,
                  onChanged: (value) {
                    setState(() {
                      _selectedReason = value;
                    });
                    Navigator.of(context).pop();
                    _showCancellationDialog();
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Material quantity is less than 15 kg.'),
                  value: 'Material quantity is less than 15 kg.',
                  groupValue: _selectedReason,
                  onChanged: (value) {
                    setState(() {
                      _selectedReason = value;
                    });
                    Navigator.of(context).pop();
                    _showCancellationDialog();
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Duplicate request / By mistake.'),
                  value: 'Duplicate request / By mistake.',
                  groupValue: _selectedReason,
                  onChanged: (value) {
                    setState(() {
                      _selectedReason = value;
                    });
                    Navigator.of(context).pop();
                    _showCancellationDialog();
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Just checking: No material at my place.'),
                  value: 'Just checking: No material at my place.',
                  groupValue: _selectedReason,
                  onChanged: (value) {
                    setState(() {
                      _selectedReason = value;
                    });
                    Navigator.of(context).pop();
                    _showCancellationDialog();
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Pickup not on time.'),
                  value: 'Pickup not on time',
                  groupValue: _selectedReason,
                  onChanged: (value) {
                    setState(() {
                      _selectedReason = value;
                    });
                    Navigator.of(context).pop();
                    _showCancellationDialog();
                  },
                ),
                RadioListTile<String>(
                  title: const Text('No response from Online Bhangarwala.'),
                  value: 'No response from Online Bhangarwala',
                  groupValue: _selectedReason,
                  onChanged: (value) {
                    setState(() {
                      _selectedReason = value;
                    });
                    Navigator.of(context).pop();
                    _showCancellationDialog();
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Rate issue.'),
                  value: 'Rate issue',
                  groupValue: _selectedReason,
                  onChanged: (value) {
                    setState(() {
                      _selectedReason = value;
                    });
                    Navigator.of(context).pop();
                    _showCancellationDialog();
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Don\'t cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // Implement your cancellation logic here

                  final data = {
                    'id': widget.pickupId,
                    'name': _selectedReason,
                  };
                  final ApiService apiService = ApiService();
                  final response = await apiService.CancelPickup(data);
                  final response1 = json.decode(response.body);
                  print(response1);
                  if (response.statusCode == 200) {
                    Navigator.of(context).pop();
                    _showCancellationConfirmationPopup();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Failed to submit form. Please try again.'),
                      ),
                    );
                  }
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCancellationConfirmationPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white, // Dark background for contrast
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Icon(Icons.cancel, size: 80, color: Colors.red),
              const SizedBox(height: 20),
              const Text(
                'Your Pick Up Request Has Been Cancelled',
                style:
                    TextStyle(fontSize: 16, color: Colors.black), // White text
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => K6Screen()),
                  );
                },
                child: const Text(
                  'Back To Home Page',
                  style: TextStyle(color: Colors.white), // White button text
                ),
                style: TextButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Color(0xff3b61f4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _pickupData = _fetchPickupData(
        widget.pickupId); // Use the actual pickupId passed to the widget
  }

  Future<Map<String, dynamic>> _fetchPickupData(String pickupId) async {
    final ApiService apiService = ApiService();
    final response = await apiService.GetSchedulePickUpData(pickupId);

    if (response.statusCode == 200) {
      final response1 = json.decode(response.body);
      print(response1);

      final String address = [
        response1['pickdata']?['address'] ?? '',
        response1['pickdata']?['landmark'] ?? '',
        response1['pickdata']?['pin'] ?? '',
      ].join(' ');
      print(address);

      // Ensure address_type is parsed as an integer
      final int addressTypeValue =
          int.tryParse(response1['pickdata']!['address_type'].toString()) ?? 0;

      setState(() {
        DateTime parsedDate =
            DateTime.parse(response1['pickdata']?["pick_up_date"]);
        pickup_data = DateFormat('d MMMM y, EEEE').format(parsedDate);
        pickup_time = response1['pickdata']?["time_slot"];
        pickup_address = address;
        _instruction = response1['pickdata']?['instructions'];
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
      });
      return response1; // Return the decoded data
    } else {
      throw Exception('Failed to load pickup data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double padding = MediaQuery.of(context).size.width * 0.04;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF06193D),
        title: const Text(
          'Track Pickup Request',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => K6Screen()),
            );
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle the menu actions
              if (value == 'Reschedule') {
                print('Reschedule selected');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RescheduleScreen(pickId: widget.pickupId)),
                );
              } else {
                print('Cancel selected');
                _showCancellationDialog();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Reschedule',
                  child: Text('Reschedule'),
                ),
                const PopupMenuItem<String>(
                  value: 'Cancel',
                  child: Text('Cancel'),
                ),
              ];
            },
            icon: const Icon(Icons.more_vert,
                color: Colors.white), // Set the color of 3 dots to white
            color: Colors.white,
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _pickupData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: padding),
                  Center(
                    child: Image.asset(
                      ImageConstant.trackPickup,
                      width: MediaQuery.of(context).size.width * 0.40,
                      height: MediaQuery.of(context).size.width * 0.40,
                    ),
                  ),
                  SizedBox(height: padding),
                  Center(
                    child: Text(
                      'We are assigning your request to our pickup team',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: padding),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: padding / 2),
                    decoration: BoxDecoration(
                      color: const Color(0xff3b61f4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatusColumn(
                            Icons.check_circle, 'Request received'),
                        _buildStatusColumn(
                            Icons.assignment_turned_in, 'Request assigned'),
                        _buildStatusColumn(
                            Icons.directions_car, 'Out for pickup'),
                      ],
                    ),
                  ),
                  SizedBox(height: 2),
                  ListTile(
                    leading:
                        const Icon(Icons.calendar_today, color: Colors.white),
                    title: const Text(
                      'Expected Pickup',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '${pickup_data ?? 'Unknown Date'}\nBetween ${pickup_time ?? 'Unknown Time Slot'}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 0.6,
                    indent: 20,
                    endIndent: 20,
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.white),
                    title: Text('Address - $_addressType',
                        style: const TextStyle(color: Colors.white)),
                    subtitle: Text(
                      pickup_address ?? 'No address provided',
                      style: const TextStyle(color: Colors.white),
                    ),
                    // trailing: TextButton(
                    //   onPressed: () {
                    //     // Implement your edit action here
                    //   },
                    //   child: const Text('Edit'),
                    // ),
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 0.6,
                    indent: 20,
                    endIndent: 20,
                  ),
                  ListTile(
                    leading: const Icon(Icons.integration_instructions,
                        color: Colors.white),
                    title: const Text(
                      'Any Instructions',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '${_instruction ?? ''}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 4),
                  Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.white,
                      unselectedWidgetColor: Colors.white,
                    ),
                    child: Container(
                      color: Colors.white,
                      child: ExpansionTile(
                        backgroundColor: Colors.white,
                        title: const Text(
                          'Pickup instructions',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        children: [
                          _buildInstructionTile(
                              '1. Please take out scrap items for faster pickup.'),
                          _buildInstructionTile(
                              '2. Show pickup code to our executive.'),
                          _buildInstructionTile(
                              '3. Prices are not negotiable. Check price list.'),
                          _buildInstructionTile(
                              '4. Our prices are dynamic based on recycling industry.'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => K6Screen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        padding: EdgeInsets.symmetric(
                            horizontal: padding * 4, vertical: padding * 1.5),
                        backgroundColor: const Color(0xff3b61f4),
                      ),
                      child: const Text(
                        'Back To Home Page',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }

  Widget _buildStatusColumn(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildInstructionTile(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: ListTile(
        title: Text(
          text,
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
      ),
    );
  }
}
