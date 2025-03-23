import 'dart:convert';

import 'package:eco_recycler/services/Apiservice.dart';
import 'package:flutter/material.dart';

class CancelledScreen extends StatefulWidget {
  final String pickupId;

  CancelledScreen({required this.pickupId});

  @override
  State<CancelledScreen> createState() => _CancelledScreenState();
}

class _CancelledScreenState extends State<CancelledScreen> {
  Map<String, dynamic>? userDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCancelledPickupDetails();
  }

  Future<void> fetchCancelledPickupDetails() async {
    try {
      final ApiService apiService = ApiService();
      final response = await apiService.GetPickUPDetails(widget.pickupId);
      final responseJson = json.decode(response.body);

      if (responseJson['status_code'] == 200) {
        setState(() {
          userDetails = responseJson['userdetails']
              [0]; // Assuming there's only one user in the response.
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching pickup details: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF06193D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pick Up History',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userDetails != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rejected Pick Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 30,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Rejected',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'By ${userDetails!['cancel_by']} • ${userDetails!['cancel_reason']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16),
                      Divider(color: Colors.grey[700]),
                      SizedBox(height: 16),
                      Text(
                        'Reassigned To',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'ER - #${userDetails!['ecoid']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16),
                      Divider(color: Colors.grey[700]),
                      SizedBox(height: 16),
                      Text(
                        'Customer Details',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${userDetails!['firstname']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'OB ID: #${userDetails!['id']}',
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${userDetails!['address']}' +
                                "\n" +
                                '${userDetails!['landmark']}' +
                                " " +
                                '${userDetails!['pin'].toString()}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${userDetails!['pick_up_date']} | ${_getDayOfWeek(userDetails!['pick_up_date'])}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Between ${userDetails!['time_slot']}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Center(child: Text("No details available")),
    );
  }

  String _getDayOfWeek(String date) {
    // Parse the date string and return the day of the week
    DateTime parsedDate = DateTime.parse(date);
    List<String> daysOfWeek = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ];
    return daysOfWeek[parsedDate.weekday % 7];
  }
}
