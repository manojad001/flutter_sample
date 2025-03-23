import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_bhangharwala/presentation/pickup_datetime/pickup_datetime.dart';
import 'package:online_bhangharwala/services/Apiservice.dart';
import 'package:online_bhangharwala/track_pickup/track_pickup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:online_bhangharwala/core/utils/image_constant.dart';
import 'package:online_bhangharwala/widgets/app_bar/appbar_home.dart';
import 'package:online_bhangharwala/widgets/bottomNavigation.dart';
import 'package:online_bhangharwala/widgets/drawer.dart';

class K6Screen extends StatefulWidget {
  @override
  _K6ScreenState createState() => _K6ScreenState();
}

class _K6ScreenState extends State<K6Screen> {
  int _currentIndex = 0;
  late Future<String?> _nameFuture;
  dynamic _pickupData;
  String? pickupData;
  String? pickupId;

  @override
  void initState() {
    super.initState();
    _nameFuture = _getNameFromPreferences();
    _fetchPickUpData();
  }

  Future<String?> _getNameFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  Future<void> _fetchPickUpData() async {
    try {
      final ApiService apiService = ApiService();
      final response = await apiService.getPickUpData();
      final responseJson = json.decode(response.body);
      print(responseJson);

      setState(() {
        DateTime parsedDate = DateTime.parse(responseJson['pickdata']
                ?["pick_up_date"] ??
            DateTime.now().toIso8601String());
        pickupData = DateFormat('d MMMM y, EEEE').format(parsedDate);
        pickupId = responseJson['pickdata']?["id"].toString();
      });
    } catch (e) {
      // Handle any errors
      print('Error: $e');
    }
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
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
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<String?>(
                        future: _nameFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error loading name');
                          } else {
                            String name = snapshot.data ?? 'Guest';
                            return Text(
                              'Good Morning, $name',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      Text(
                        'What would you like to sell?',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 16),
                      GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          _buildCategoryItem('Paper', ImageConstant.paper,
                              'Newspapers, books, magazines'),
                          _buildCategoryItem('Plastic', ImageConstant.plastic,
                              'Oil container, hard/soft plastics'),
                          _buildCategoryItem('Metals', ImageConstant.metals,
                              'Utensils, coolers, drums etc...'),
                          _buildCategoryItem('E-waste', ImageConstant.ewaste,
                              'Computers, keyboards etc...'),
                          _buildCategoryItem(
                              'More items',
                              ImageConstant.moreitems,
                              'Beer bottles, machines etc...'),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScrapPickupScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0), // Ensure consistent padding
                    textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.045), // Dynamic font size
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded edges for better UI
                    ),
                  ),
                  child: SizedBox(
                    height: 50, // Fixed height for uniformity
                    child: Center(
                      child: Text(
                        'Raise Pick Up Request',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),
              pickupId != null
                  ? Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05), // Responsive padding
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  ImageConstant.truck_home,
                                  width: constraints.maxWidth * 0.12, // Responsive image size
                                  height: constraints.maxWidth * 0.12,
                                ),
                                SizedBox(width: constraints.maxWidth * 0.04), // Responsive spacing
                                
                                Expanded( // Allows text to take available space
                                  child: GestureDetector(
                                    onTap: () {
                                      final pickupIdS = pickupId.toString();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TrackPickupRequestPage(pickupId: pickupIdS),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "We're coming to collect scrap",
                                          style: TextStyle(
                                            fontSize: constraints.maxWidth * 0.045, // Responsive font size
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: constraints.maxWidth * 0.02), // Spacing between text
                                        Text(
                                          pickupData ?? '',
                                          style: TextStyle(
                                            fontSize: constraints.maxWidth * 0.06,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  size: constraints.maxWidth * 0.08, // Responsive icon size
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildCategoryItem(String title, String imagePath, String subtitle) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(imagePath, height: 40),
              SizedBox(height: 3),
              Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(color: Colors.white70, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
