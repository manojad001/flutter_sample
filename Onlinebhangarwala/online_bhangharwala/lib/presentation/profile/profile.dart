import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:online_bhangharwala/presentation/edit_address/edit_address.dart';
import 'package:online_bhangharwala/presentation/profile/edit.dart';
import 'package:online_bhangharwala/services/Apiservice.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditingGender = false;
  bool isEditingDOB = false;
  bool isEditingAddress = false;
  bool isEditingPayment = false;

  late TextEditingController nameController;
  late TextEditingController mobileController;
  late TextEditingController genderController;
  late TextEditingController dobController;
  late TextEditingController addressController;
  late TextEditingController paymentController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: '');
    mobileController = TextEditingController(text: '');
    genderController = TextEditingController(text: '');
    dobController = TextEditingController(text: '');
    addressController = TextEditingController(text: '');
    paymentController = TextEditingController(text: 'Cash');
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final ApiService apiService = ApiService();
    final response = await apiService.GetUserProfile();

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final profile = responseBody['data'];
      print(profile);
      setState(() {
        nameController.text = profile['firstname'] ?? '';
        mobileController.text = profile['mobile'] ?? '';
        genderController.text = profile['gender'] ?? '';
        dobController.text = profile['dob'] ?? '';
        addressController.text =
            '${profile['address'] ?? ''} ${profile['landmark'] ?? ''}\n${profile['pin'] ?? ''}';
      });
    } else {
      // Handle error or show a message to the user
      print("Failed to load profile");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF06193D),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 8),
                    Text(
                      nameController.text,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPage(
                              title: 'Name',
                              controller: nameController,
                            ),
                          ),
                        ).then((_) {
                          setState(() {});
                        });
                      },
                      child: Icon(Icons.edit, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              buildProfileSection('Mobile Number', mobileController, false),
              SizedBox(height: 8),
              // Row(
              //   children: [
              //     Expanded(
              //       child: buildProfileSection(
              //           'Gender', genderController, isEditingGender,
              //           onEditPressed: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => EditPage(
              //               title: 'Gender',
              //               controller: genderController,
              //               isGender: true,
              //             ),
              //           ),
              //         ).then((_) {
              //           setState(() {});
              //         });
              //       }),
              //     ),
              //     SizedBox(width: 10),
              //     Expanded(
              //       child: buildProfileSection(
              //           'DOB', dobController, isEditingDOB, onEditPressed: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => EditPage(
              //               title: 'DOB',
              //               controller: dobController,
              //             ),
              //           ),
              //         ).then((_) {
              //           setState(() {});
              //         });
              //       }),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 8),
              buildProfileSection(
                  'Pickup Address', addressController, isEditingAddress,
                  onEditPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditAddress(),
                  ),
                ).then((_) {
                  setState(() {});
                });
              }),
              SizedBox(height: 8),
              // buildProfileSection(
              //     'Payment Method', paymentController, isEditingPayment,
              //     onEditPressed: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => EditPage(
              //         title: 'Payment Method',
              //         controller: paymentController,
              //       ),
              //     ),
              //   ).then((_) {
              //     setState(() {});
              //   });
              // }),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFF06193D),
    );
  }

  Widget buildProfileSection(
      String title, TextEditingController controller, bool isEditing,
      {VoidCallback? onEditPressed}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            TextField(
              controller: controller,
              enabled: isEditing,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
            // Conditionally hide the edit button if the title is "Mobile Number"
            if (title != 'Mobile Number')
              Positioned(
                right: 0,
                child: TextButton(
                  onPressed: onEditPressed,
                  child: Text(
                    isEditing ? 'Save' : 'Edit',
                    style: TextStyle(color: Color(0xff3b61f4)),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
