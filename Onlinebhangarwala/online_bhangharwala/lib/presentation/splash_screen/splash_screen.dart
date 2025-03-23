import 'package:flutter/material.dart';
import 'package:online_bhangharwala/presentation/k6_screen/k6_screen.dart';
import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => K6Screen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 39.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgObLogoColor,
            height: 112.v,
            width: 311.h,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
