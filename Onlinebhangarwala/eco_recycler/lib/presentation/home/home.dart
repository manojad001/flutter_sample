import 'dart:convert';
import 'package:eco_recycler/core/utils/image_constant.dart';
import 'package:eco_recycler/presentation/pickup/pickup_details.dart';
import 'package:eco_recycler/services/Apiservice.dart';
import 'package:eco_recycler/widgets/app_bar/app_bar.dart';
import 'package:eco_recycler/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, dynamic>> _assignedPickupsFuture;

  @override
  void initState() {
    super.initState();
    _assignedPickupsFuture = _fetchAssignedPickups();
  }

  Future<Map<String, dynamic>> _fetchAssignedPickups() async {
    final ApiService apiService = ApiService();
    var response = await apiService.GetEcoRecyclerPickUP();
    final data = jsonDecode(response.body);

    if (data != null) {
      return data;
    } else {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home',
        icon: Icons.home,
      ),
      drawer: DrawerPage(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _assignedPickupsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              var data = snapshot.data!;
              var pickupList = data['pickEco'] ?? [];
              var todayAssign = data['todayassign'] ?? 0;
              var totalAssign = data['totalassign'] ?? 0;

              if (pickupList.isNotEmpty) {
                var firstPickup = pickupList[0];

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upcoming Pick Up',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'OB ID: ${firstPickup["id"]}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Pin Code: ${firstPickup["pin"]}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today, size: 16),
                                          SizedBox(width: 4),
                                          Text(
                                            DateFormat('dd/MM/yyyy').format(
                                                DateTime.parse(firstPickup[
                                                    "pick_up_date"])),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.access_time, size: 16),
                                          SizedBox(width: 4),
                                          Text(firstPickup["time_slot"] ?? '',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Handle details button click
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PickUpDetailsScreen(
                                            pickupId: firstPickup["id"]
                                                .toString(), // Pass the ID here
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(
                                          0xFF5663FF), // Blue button color

                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                    child: Text(
                                      'Details',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Today\'s Pick Ups'),
                              SizedBox(height: 8),
                              Text(
                                '$todayAssign',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Assigned Pick Ups'),
                              SizedBox(height: 8),
                              Text(
                                '$totalAssign',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return _buildNoPickupsWidget();
              }
            } else {
              return _buildNoPickupsWidget();
            }
          },
        ),
      ),
    );
  }

  Widget _buildNoPickupsWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 32),
          Text(
            'No Pick Ups Assign',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 32),
          Container(
            width: 200,
            height: 200,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.asset(
                ImageConstant.noAssignPickup,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
