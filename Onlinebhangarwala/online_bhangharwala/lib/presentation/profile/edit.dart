import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:online_bhangharwala/core/utils/image_constant.dart';
import 'package:online_bhangharwala/services/Apiservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPage extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final bool isGender;

  EditPage({
    required this.title,
    required this.controller,
    this.isGender = false,
  });

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String _selectedGender = 'Male';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  bool get _isFormValid {
    if (widget.isGender) {
      return _selectedGender.isNotEmpty;
    } else if (widget.title == "Name") {
      return widget.controller.text.isNotEmpty;
    } else {
      return widget.controller.text.isNotEmpty && _selectedDate != null;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime initialDate = _selectedDate ?? currentDate;

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: currentDate,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        widget.controller.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _updateProfile() async {
    Map<String, dynamic> requestBody = {};

    if (widget.title == "Name") {
      requestBody['name'] = widget.controller.text;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', requestBody['name']);
    } else if (widget.title == "DOB") {
      requestBody['dob'] =
          _selectedDate?.toLocal().toString().split(' ')[0] ?? '';
    }

    // Add gender only if the `isGender` flag is true
    if (widget.isGender) {
      requestBody['gender'] = _selectedGender;
    }

    try {
      final ApiService apiService = ApiService();
      final response = await apiService.UpdateProfile(requestBody);

      if (response.statusCode == 200) {
        final response1 = json.decode(response.body);
        print(response1);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF06193D),
        title: Text(
          'Update ${widget.title}',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF06193D),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Image.asset(
                    ImageConstant.bannerLogo,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                widget.isGender
                    ? 'Select Your Gender'
                    : 'Add Your ${widget.title}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              widget.isGender
                  ? Column(
                      children: [
                        ListTile(
                          title: Text('Male',
                              style: TextStyle(color: Colors.white)),
                          leading: Radio<String>(
                            value: 'Male',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                            activeColor: Colors.white,
                          ),
                        ),
                        ListTile(
                          title: Text('Female',
                              style: TextStyle(color: Colors.white)),
                          leading: Radio<String>(
                            value: 'Female',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                            activeColor: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : widget.title == "Name"
                      ? TextField(
                          controller: widget.controller,
                          decoration: InputDecoration(
                            hintText: 'Enter Your Name',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                          ),
                          style: TextStyle(color: Colors.black),
                        )
                      : GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: TextField(
                              controller: widget.controller,
                              decoration: InputDecoration(
                                hintText: _selectedDate == null
                                    ? 'Enter Date of Birth'
                                    : 'Date of Birth',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 15.0),
                              ),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isFormValid ? _updateProfile : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Color(0xff3b61f4),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
