import 'dart:convert';
import 'package:eco_recycler/services/Apiservice.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isAvailable = true;
  int? id;
  String firstName = '';
  String lastName = '';
  String mobileNumber = '';
  String username = '';

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    final ApiService apiService = ApiService();
    final response = await apiService.Userinfoeco();

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);

      // Extract user details from the response
      final user = responseJson['user'];
      setState(() {
        id = user['id'];
        firstName = user['firstname'] ?? '';
        lastName = user['lastname'] ?? '';
        mobileNumber = user['mobile'] ?? '';
        username = user['username'] ?? '';
        isAvailable = user['active'] == 1 ? true : false;
      });
    } else {
      // Handle the error if needed
      print('Failed to load user info');
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
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color:
                          const Color(0xFF0B1120), // Dark blue color for icon
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$firstName $lastName', // Display the dynamic name
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Mobile Number',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      mobileNumber, // Display the dynamic mobile number
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Availability Status',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Switch(
                  value: isAvailable,
                  onChanged: (value) async {
                    // Update the state with the new value
                    setState(() {
                      isAvailable = value;
                    });

                    // Prepare data to send to the API
                    final data = {
                      'userid': id,
                      'status': value ? 1 : 0, // Set 1 for true, 0 for false
                    };

                    // Make the API call to update the status
                    final ApiService apiService = ApiService();
                    final response = await apiService.UpdateStatus(data);

                    if (response.statusCode == 200) {
                      final responseBody = json.decode(response.body);
                      print('Status updated successfully: $responseBody');
                    } else {
                      print('Failed to update status');
                    }
                  },
                  activeColor: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              isAvailable ? 'Available' : 'Unavailable',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
