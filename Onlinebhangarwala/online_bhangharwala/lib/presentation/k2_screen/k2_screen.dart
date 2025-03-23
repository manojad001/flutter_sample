import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online_bhangharwala/presentation/k1_screen/k1_screen.dart';
import 'dart:convert';
import 'dart:async';
import 'package:online_bhangharwala/presentation/k3_screen/k3_screen.dart';
import 'package:online_bhangharwala/presentation/k6_screen/k6_screen.dart';
import 'package:online_bhangharwala/services/Apiservice.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class K2Screen extends StatefulWidget {
  final String mobileNumber;

  const K2Screen({Key? key, required this.mobileNumber}) : super(key: key);

  @override
  _K2ScreenState createState() => _K2ScreenState();
}

class _K2ScreenState extends State<K2Screen> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  bool _isSubmitButtonEnabled = false; // Initially set to false
  bool _isResendButtonEnabled = true;
  int _resendTimer = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _mobileController.text = widget.mobileNumber;

    // Add listener to OTP controller to check button state
    _otpController.addListener(_checkSubmitButtonState);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  // Method to check if the submit button should be enabled
  void _checkSubmitButtonState() {
    setState(() {
      _isSubmitButtonEnabled = _otpController.text.isNotEmpty;
    });
  }

  Future<void> _submit() async {
    if (!_isSubmitButtonEnabled) return;
    setState(() {
      _isSubmitButtonEnabled = false;
    });

    final ApiService apiService = ApiService();
    final String mobile = _mobileController.text;
    final String otp = _otpController.text;
    print(mobile);

    try {
      final response = await apiService.userLogin(mobile, otp);
      final responseData = jsonDecode(response.body);
      print(responseData);

      if (response.statusCode == 200) {
        if (responseData['status_code'] == 200) {
          final String token = responseData['token'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', token);

          final url = Uri.parse(
              'https://backend.onlinebhangarwala.com/api/newuserinfo');
          final response1 = await http.post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );

          if (response1.statusCode == 200) {
            final response1Data = jsonDecode(response1.body);
            print(response1Data);

            if (response1Data['user'] != null &&
                response1Data['user']['firstname'] == null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => K3Screen()),
              );
            } else {
              await prefs.setString('name', response1Data['user']['firstname']);
              await prefs.setInt('user_id', response1Data['user']['id']);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => K6Screen()),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Failed to retrieve user information. Please try again.')),
            );
            setState(() {
              _isSubmitButtonEnabled = true;
            });
          }
        } else {
          final errorMessage =
              responseData['data'] ?? 'Failed to login. Please try again.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
          setState(() {
            _isSubmitButtonEnabled = true;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to login. Please try again.')),
        );
        setState(() {
          _isSubmitButtonEnabled = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
      setState(() {
        _isSubmitButtonEnabled = true;
      });
    }
  }

  Future<void> _resend() async {
    setState(() {
      _isResendButtonEnabled = false;
      _resendTimer = 30;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _isResendButtonEnabled = true;
          _timer?.cancel();
        }
      });
    });

    final ApiService apiService = ApiService();
    final String mobile = _mobileController.text;
    print(mobile);
    try {
      final response = await apiService.resendOtp(mobile);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final msg = responseData['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 28,
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(right: 66),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => K1Screen()),
                            );
                          },
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgObLogoColor,
                          height: 74,
                          width: 207,
                          margin: EdgeInsets.only(left: 40),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 39),
                CustomImageView(
                  imagePath: ImageConstant.imgGroup3223,
                  height: 169,
                  width: 169,
                ),
                SizedBox(height: 41),
                Text(
                  "Verification Code",
                  style: CustomTextStyles.headlineMediumOnPrimary,
                ),
                SizedBox(height: 22),
                Text(
                  "We have sent an OTP to your mobile number",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 38),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 27),
                  child: CustomPinCodeTextField(
                    context: context,
                    controller: _otpController,
                    onChanged: (value) {
                      _checkSubmitButtonState(); // Check button state when text changes
                    },
                  ),
                ),
                SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 27),
                    child: Row(
                      children: [
                        Container(
                          height: 18,
                          width: 18,
                          margin: EdgeInsets.only(bottom: 1),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            borderRadius: BorderRadius.circular(
                              9,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 11),
                          child: Text(
                            "Auto fetching OTP.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 35),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Color(0xff3b61f4),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _isSubmitButtonEnabled ? _submit : null,
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
                _isResendButtonEnabled
                    ? CustomOutlinedButton(
                        text: "Send Again",
                        onPressed: _resend,
                      )
                    : Text('Resend available in $_resendTimer seconds'),
                SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
