import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_bhangharwala/presentation/confirm_pickup/confirm_pickup.dart';
import 'package:online_bhangharwala/services/Apiservice.dart';
import 'package:online_bhangharwala/widgets/stepper.dart';

class ScrapPickupScreen extends StatefulWidget {
  @override
  _ScrapPickupScreenState createState() => _ScrapPickupScreenState();
}

class _ScrapPickupScreenState extends State<ScrapPickupScreen> {
  String? _selectedDateTimeSlot;
  int _currentStep = 0; // 0 for Pickup date, 1 for Confirm
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
                                onTap: () {
                                  setState(() {
                                    _selectedDateTimeSlot =
                                        '${dateTimeSlots[index]['date']} - $slot';
                                    _currentStep =
                                        1; // Move to the Confirm step
                                  });
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ConfirmDetailsPage(
                                        selectedDateTimeSlot:
                                            _selectedDateTimeSlot!,
                                        slot: slot,
                                      ),
                                    ),
                                  );
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
                StepProgressIndicator(currentStep: _currentStep),
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
                    if (_currentStep == 1) {
                      _showDateTimeSlotDialog(context);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Select Date & Time',
                        style: TextStyle(color: Colors.white)),
                  ),
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: Colors.blue,
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
