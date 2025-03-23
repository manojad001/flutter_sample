import 'package:flutter/material.dart';
import 'package:online_bhangharwala/presentation/k2_screen/k2_screen.dart';
import 'package:online_bhangharwala/services/Apiservice.dart';
import '../../core/app_export.dart'; // ignore_for_file: must_be_immutable

class K1Screen extends StatefulWidget {
  K1Screen({Key? key}) : super(key: key);

  @override
  _K1ScreenState createState() => _K1ScreenState();
}

class _K1ScreenState extends State<K1Screen> {
  final TextEditingController mobileNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    mobileNumberController.addListener(_validateMobileNumber);
  }

  @override
  void dispose() {
    mobileNumberController.dispose();
    super.dispose();
  }

  void _validateMobileNumber() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() {
      _isButtonDisabled = !isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 66,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgObLogoColor,
                  height: 74,
                  width: 207,
                ),
                SizedBox(height: 60),
                _buildTypeYourMobile(context),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isButtonDisabled
                      ? null
                      : () {
                          setState(() {
                            _isButtonDisabled = true;
                          });
                          _sendOtp(context);
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: _isButtonDisabled
                        ? Colors.blueAccent
                        : Color(0xff3b61f4),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 9),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "By clicking, I accept the ",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextSpan(
                          text: "terms of service",
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                        ),
                        TextSpan(
                          text: " and ",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextSpan(
                          text: "privacy policy.",
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 23),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildTypeYourMobile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Type your mobile number",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: mobileNumberController,
          decoration: InputDecoration(
            hintText: "+91 ",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          style: TextStyle(color: Colors.black), // Text color
          validator: (value) {
            if (value == null || value.isEmpty || value.length != 9) {
              return 'Please enter a valid 10-digit mobile number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Future<void> _sendOtp(BuildContext context) async {
    final ApiService apiService = ApiService();
    final String mobile = mobileNumberController.text;

    try {
      final response = await apiService.sendOtp(mobile);

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => K2Screen(mobileNumber: mobile),
          ),
        );
      } else {
        _showErrorSnackbar(context, 'Failed to send OTP. Please try again.');
      }
    } catch (e) {
      _showErrorSnackbar(context, 'An error occurred. Please try again.');
    } finally {
      setState(() {
        _isButtonDisabled = false;
      });
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
