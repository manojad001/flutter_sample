import 'package:flutter/material.dart';
import 'package:online_bhangharwala/presentation/k6_screen/k6_screen.dart';
import 'package:online_bhangharwala/services/Apiservice.dart';
import 'package:online_bhangharwala/widgets/app_bar/appbar_subtitle.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class K5Screen extends StatefulWidget {
  K5Screen({Key? key}) : super(key: key);

  @override
  _K5ScreenState createState() => _K5ScreenState();
}

class _K5ScreenState extends State<K5Screen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  String _selectedValue = '1';
  bool _isServiceable = false;
  bool _isCheckingServiceability = false;

  String _serviceabilityMessage = '';

  Future<void> _checkPincodeServiceability(String pincode) async {
    if (pincode.isEmpty) {
      setState(() {
        _isServiceable = false;
        _serviceabilityMessage = '';
      });
      return;
    }

    setState(() {
      _isCheckingServiceability = true;
    });

    final ApiService apiService = ApiService();
    try {
      final response = await apiService.checkAvailability(pincode);
      final r1 = json.decode(response.body);
      print(r1['status']);

      setState(() {
        _isCheckingServiceability = false;
        if (r1['status'].toLowerCase() == 'true') {
          _isServiceable = true;
        } else if (r1['status'].toLowerCase() == 'false') {
          _isServiceable = false;
        }
        _serviceabilityMessage =
            r1['message'] ?? ''; // Get message from response
      });
    } catch (e) {
      setState(() {
        _isCheckingServiceability = false;
        _isServiceable = false;
        _serviceabilityMessage = 'Error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color(0xFF06193D),
          title: const Text(
            'Set Pickup Address',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.03,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildLocationDetails(context),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressDetails(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "House / Flat / Block No.",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          CustomTextFormField(
            controller: addressController,
            hintText: "e.g., #123 house no, 3rd cross ...",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLandmarkDetails(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Landmark",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          CustomTextFormField(
            controller: landmarkController,
            hintText: "e.g., Opp to school ...",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPincodeDetails(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pincode",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          TextFormField(
            controller: pincodeController,
            decoration: InputDecoration(
              hintText: "e.g., 012345",
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10.0),
              ),
              fillColor: Colors.white,
              filled: true,
            ),
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
            onChanged: (value) {
              if (value.length == 6) {
                _checkPincodeServiceability(value);
              } else {
                setState(() {
                  _isServiceable = false;
                  _isCheckingServiceability = false;
                  _serviceabilityMessage = '';
                });
              }
            },
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          if (_isCheckingServiceability)
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          if (!_isCheckingServiceability && _serviceabilityMessage.isNotEmpty)
            Text(
              _serviceabilityMessage,
              style: TextStyle(
                color: _isServiceable ? Colors.green : Colors.red,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddressForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAddressDetails(context),
        _buildLandmarkDetails(context),
        _buildPincodeDetails(context),
      ],
    );
  }

  Widget _buildSaveAsOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: Text(
            "Save As",
            style: CustomTextStyles.titleMediumBold,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.04,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgHomeFill0Wght,
                    height: 20.adaptSize,
                    width: 20.adaptSize,
                    margin: EdgeInsets.only(left: 10.h),
                  ),
                  Radio<String>(
                    value: '1',
                    groupValue: _selectedValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value!;
                      });
                    },
                  ),
                  Text('Home'),
                ],
              ),
              Row(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgHomeFill0Wght,
                    height: 20.adaptSize,
                    width: 20.adaptSize,
                    margin: EdgeInsets.only(left: 10.h),
                  ),
                  Radio<String>(
                    value: '2',
                    groupValue: _selectedValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value!;
                      });
                    },
                  ),
                  Text('Business'),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.04,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgBusiness1Primarycontainer,
                    height: 20.adaptSize,
                    width: 20.adaptSize,
                    margin: EdgeInsets.only(left: 10.h),
                  ),
                  Radio<String>(
                    value: '3',
                    groupValue: _selectedValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value!;
                      });
                    },
                  ),
                  Text('Friend or Family'),
                ],
              ),
              Row(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgBusiness1Primarycontainer,
                    height: 20.adaptSize,
                    width: 20.adaptSize,
                    margin: EdgeInsets.only(left: 10.h),
                  ),
                  Radio<String>(
                    value: '4',
                    groupValue: _selectedValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value!;
                      });
                    },
                  ),
                  Text('Others'),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSaveAndProceed(BuildContext context) {
    return CustomElevatedButton(
      text: "Save and Proceed",
      onPressed: _isServiceable ? () => _submitForm(context) : null,
    );
  }

  Widget _buildLocationDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   children: [
        //     // CustomImageView(
        //     //   imagePath: ImageConstant.imgLocationOnFil,
        //     //   height: 30.0,
        //     //   width: 30.0,
        //     // ),
        //     // SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        //     // Text(
        //     //   "Kopar Khairane",
        //     //   style: CustomTextStyles.titleMediumBold18,
        //     // ),
        //   ],
        // ),
        // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        // Text(
        //   "Industrial Area, Kopar Khairane, Aurangabad",
        //   style: CustomTextStyles.bodyMediumPrimaryContainer,
        // ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        _buildAddressForm(context),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        _buildSaveAsOptions(context),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        _buildSaveAndProceed(context),
      ],
    );
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final ApiService apiService = ApiService();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      print(userId);
      final data = {
        'user_id': userId,
        'address': addressController.text,
        'pin': pincodeController.text,
        'landmark': landmarkController.text,
        'optradio': _selectedValue,
      };

      try {
        final response = await apiService.AddAddress(data);
        final response1 = json.decode(response.body);
        print(response1);
        if (response.statusCode == 200) {
          if (response1['status'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Address Updated successfully!')),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => K6Screen()),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit form. Please try again.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred: $e')),
        );
      }
    }
  }

  void onTapArrowdownone(BuildContext context) {
    Navigator.pop(context);
  }
}
