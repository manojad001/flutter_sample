import 'package:eco_recycler/core/utils/image_constant.dart';
import 'package:eco_recycler/presentation/home/home.dart';
import 'package:flutter/material.dart';
import 'package:eco_recycler/services/Apiservice.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  String? _usernameError;
  String? _passwordError;

  Future<void> _login() async {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    setState(() {
      _usernameError = username.isEmpty ? "Username is required" : null;
      _passwordError = password.isEmpty ? "Password is required" : null;
    });

    if (_usernameError != null || _passwordError != null) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final ApiService apiService = ApiService();
      final response = await apiService.Login(username, password);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == "fail") {
          setState(() {
            _errorMessage = data['message'];
          });
        } else {
          final String token = data['token'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', token);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Invalid username or password';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1C3F), // Dark blue background color
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = constraints.maxWidth;
          final double padding = screenWidth * 0.08;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: screenWidth * 0.1),
                  Image.asset(
                    ImageConstant.bannerLogo,
                    height: screenWidth * 0.25,
                  ),
                  SizedBox(height: screenWidth * 0.03),
                  Text(
                    'Eco Recycler',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2.0,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.1),
                  Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.06),
                  _buildLabelText('Username', screenWidth),
                  _buildTextField(
                    controller: _usernameController,
                    hintText: 'Enter your username',
                    errorText: _usernameError,
                  ),
                  SizedBox(height: screenWidth * 0.06),
                  _buildLabelText('Password', screenWidth),
                  _buildTextField(
                    controller: _passwordController,
                    hintText: 'Enter your password',
                    errorText: _passwordError,
                    obscureText: true,
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: EdgeInsets.only(top: screenWidth * 0.02),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 14.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  SizedBox(height: screenWidth * 0.08),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5663FF),
                      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                  SizedBox(height: screenWidth * 0.1),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabelText(String text, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.02),
      child: Text(
        text,
        style: TextStyle(
          fontSize: screenWidth * 0.045,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? errorText,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500]),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          ),
          style: const TextStyle(color: Colors.black),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 14.0),
            ),
          ),
      ],
    );
  }
}
