import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_bhangharwala/core/utils/image_constant.dart';
import 'package:online_bhangharwala/services/Apiservice.dart';
import 'package:online_bhangharwala/track_pickup/track_pickup.dart';

class RescheduleScreen extends StatefulWidget {
  final String pickId;
  RescheduleScreen({required this.pickId});

  @override
  _RescheduleScreenState createState() => _RescheduleScreenState();
}

class _RescheduleScreenState extends State<RescheduleScreen> {
  String? _selectedDateTimeSlot;
  int _currentStep = 0; 
  List<String> _timeSlots = [];

   @override
  void initState() {
    super.initState();
    _fetchTimeSlots();
  }

  Future<void> _fetchTimeSlots() async {
    try {
      final ApiService apiService = ApiService();
      final response = await apiService.GetTimeSlot();
      final data = json.decode(response.body);
      setState(() {
        _timeSlots = (data['data'] as List<dynamic>)
            .map((item) => item['timeslot'] as String)
            .toList();
      });
    } catch (e) {
      print('Failed to load time slots: $e');
    }
  }
  List<Map<String, dynamic>> _generateDateTimeSlots() {
    List<Map<String, dynamic>> dateTimeSlots = [];
    DateFormat dateFormatter = DateFormat('d MMMM, EEEE');

    for (int i = 0; i <= 7; i++) {
      DateTime date = DateTime.now().add(Duration(days: i));
      String formattedDate = dateFormatter.format(date);
      dateTimeSlots.add({'date': formattedDate, 'slots': _timeSlots});
    }
    return dateTimeSlots;
  }

  void _showDateTimeSlotDialog(BuildContext context) {
    List<Map<String, dynamic>> dateTimeSlots = _generateDateTimeSlots();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Date and Time Slot'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: dateTimeSlots.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        dateTimeSlots[index]['date'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black),
                      ),
                    ),
                    Column(
                      children: dateTimeSlots[index]['slots']
                          .map<Widget>((slot) => ListTile(
                                title: Text(slot),
                                onTap: () async {
                                  setState(() {
                                    _selectedDateTimeSlot =
                                        '${dateTimeSlots[index]['date']} - $slot';
                                    _currentStep = 1;
                                  });
                                  Navigator.pop(context); // Close the dialog
                                  _showConfirmationDialog(context);

                                  final String dateTime =
                                      _selectedDateTimeSlot.toString();
                                  List<String> splitData =
                                      dateTime.split(' - ');
                                  String date = splitData[0];
                                  String time =
                                      '${splitData[1]} - ${splitData[2]}'; // '11.00 AM - 12.00 PM'

                                  final data = {
                                    'id': widget.pickId,
                                    'DaySlot': _formatDate(date),
                                    'TimeSlot': time,
                                  };
                                  print(data);

                                  final ApiService apiService = ApiService();
                                  final response =
                                      await apiService.ChangeSchedule(data);
                                  final response1 = json.decode(response.body);
                                  print(response1);
                                  if (response.statusCode == 200) {
                                    // if (response1["reschedule"] == 1) {
                                    // }
                                  }

                                  // _showConfirmationDialog(
                                  //     context); // Show confirmation popup
                                },
                                selected: _selectedDateTimeSlot ==
                                    '${dateTimeSlots[index]['date']} - $slot',
                              ))
                          .toList(),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          content: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    ImageConstant
                        .confirmed, // Replace with your image asset path
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Your Pick Up Request Had Been\nRescheduled Successfully",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Your selected time slot is: ',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: _selectedDateTimeSlot!,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrackPickupRequestPage(
                            pickupId: widget.pickId, // Pass the ID here
                          ),
                        ),
                      ); // Close the dialog
                    },
                    child: Text(
                      'Track Pick Up Request',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: const Color(0xff3b61f4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(String pickUpDate) {
    final DateFormat inputFormat = DateFormat('dd MMMM, EEEE');
    final currentYear = DateTime.now().year;
    final String dateWithYear = '$pickUpDate, $currentYear';
    final DateTime parsedDate =
        DateFormat('dd MMMM, EEEE, yyyy').parse(dateWithYear);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF06193D),
        title: Text(
          'Select Date and Time',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32),
                Text(
                  'Select a date & time for scrap pickup',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Pickup date and time according to your availability',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 32),
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title:
                        Text(_selectedDateTimeSlot ?? 'Select Date and Time'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      _showDateTimeSlotDialog(context);
                    },
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedDateTimeSlot != null) {
                      _showDateTimeSlotDialog(context);
                    } else {
                      // Show validation or error message
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Select Date & Time',
                        style: TextStyle(color: Colors.white)),
                  ),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
