import 'package:flutter/material.dart';
import 'package:online_bhangharwala/presentation/change_pickup_address/change_pickup_address.dart';
import 'package:online_bhangharwala/presentation/edit_address/edit_address.dart';
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

class AddAdress extends StatefulWidget {
  final String? addressId; // Add a field for the address ID

  AddAdress({Key? key, this.addressId}) : super(key: key);

  @override
  _AddAdressState createState() => _AddAdressState();
}

class _AddAdressState extends State<AddAdress> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  String _selectedValue = '1';
  bool _isServiceable = true;
  bool _isCheckingServiceability = false;
  String _serviceabilityMessage = '';
  bool _isEditMode = false; // Track if we are in edit mode

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.addressId != null; // Check if an ID is provided
    if (_isEditMode) {
      print(widget.addressId);

      fetchAddressDetails(widget.addressId!); // Load details for editing
    }
  }

  Future<void> fetchAddressDetails(String addressId) async {
    final ApiService apiService = ApiService();
    int addressIdInt = int.parse(addressId);

    final response = await apiService.GetAddress(addressIdInt);
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      //print(responseBody);
      final sil = responseBody['Getadd'][0]?['address_type'];
      print(sil.toString());
      print(responseBody['Getadd'][0]['address']);
      setState(() {
        addressController.text = responseBody['Getadd'][0]?['address'];
        landmarkController.text = responseBody['Getadd'][0]?['landmark'];
        pincodeController.text = responseBody['Getadd'][0]?['pin'];
        _selectedValue = sil.toString();
      });
    } else {
      print("Failed to load address details");
    }
  }

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
          title: Text(
            _isEditMode ? 'Edit Pickup Address' : 'Set Pickup Address',
            style: const TextStyle(color: Colors.white, fontSize: 18),
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
            filled: true,
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
            filled: true,
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
          padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            "Save as",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Column(
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  child: RadioListTile(
                    activeColor: Colors.white,
                    title: Text(
                      "Home",
                      style: TextStyle(color: Colors.white),
                    ),
                    value: "1",
                    groupValue: _selectedValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value.toString();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    activeColor: Colors.white,
                    title: Text(
                      "Business",
                      style: TextStyle(color: Colors.white),
                    ),
                    value: "2",
                    groupValue: _selectedValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value.toString();
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RadioListTile(
                    activeColor: Colors.white,
                    title: Text(
                      "Friends and Family",
                      style: TextStyle(color: Colors.white),
                    ),
                    value: "3",
                    groupValue: _selectedValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value.toString();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    activeColor: Colors.white,
                    title: Text(
                      "Other",
                      style: TextStyle(color: Colors.white),
                    ),
                    value: "4", // Add another value for the new option
                    groupValue: _selectedValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value.toString();
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAddressForm(context),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        _buildSaveAsOptions(context),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        CustomElevatedButton(
          text: _isEditMode ? "Save Changes" : "Save and Proceed",
          onPressed: _isServiceable
              ? () => _submitForm(context)
              : null, // Disable button if not serviceable
        ),
      ],
    );
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      // Check if pincode serviceability is already verified, if not, verify it
      if (!_isServiceable) {
        await _checkPincodeServiceability(pincodeController.text);
      }

      // Only proceed if the pin code is serviceable
      if (_isServiceable) {
        final ApiService apiService = ApiService();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('user_id');
        final data = {
          'id': widget.addressId,
          'user_id': userId,
          'address': addressController.text,
          'pin': pincodeController.text,
          'landmark': landmarkController.text,
          'optradio': _selectedValue,
        };

        try {
          final response = _isEditMode
              ? await apiService.UpdateAddress(data)
              : await apiService.AddAddress(data);
          final response1 = json.decode(response.body);
          print(response1);
          if (response.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isEditMode
                      ? 'Address updated successfully!'
                      : 'Address added successfully!',
                ),
              ),
            );
            // Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => K6Screen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to submit form. Please try again.'),
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error occurred: $e')),
          );
        }
      } else {
        // Show error message if pincode is not serviceable
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Pincode is not serviceable. Please try again.')),
        );
      }
    }
  }
}
