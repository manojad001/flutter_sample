import 'package:eco_recycler/core/utils/image_constant.dart';
import 'package:eco_recycler/presentation/home/home.dart';
import 'package:eco_recycler/presentation/login/login.dart';
import 'package:eco_recycler/services/Apiservice.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      _checkToken();
    });
  }

  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (accessToken != null && accessToken.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFF0E1C3F), // Dark blue background color
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Increased space added at the top
            SizedBox(height: 100), // Adjusted the height for more space
            // Logo Section
            Column(
              children: [
                Image.asset(
                  ImageConstant.bannerLogo, // Use your logo image here
                  height: 100,
                ),
                SizedBox(height: 10),
                Text(
                  'Eco Recycler',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Spacer(),
            // Bottom Design Section
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 100), // Increased bottom padding
                child: Image.asset(
                  ImageConstant.splash, // Use your bottom image here
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
