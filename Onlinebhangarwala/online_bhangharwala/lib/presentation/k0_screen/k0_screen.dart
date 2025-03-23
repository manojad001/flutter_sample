import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:online_bhangharwala/presentation/about_us/about_us.dart';
import 'package:online_bhangharwala/presentation/calculator/calculator.dart';
import 'package:online_bhangharwala/presentation/change_pickup_address/change_pickup_address.dart';
import 'package:online_bhangharwala/presentation/confirm_pickup/confirm_pickup.dart';
import 'package:online_bhangharwala/presentation/edit_address/edit_address.dart';
import 'package:online_bhangharwala/presentation/how_its_works/how_its_works.dart';
import 'package:online_bhangharwala/presentation/k1_screen/k1_screen.dart';
import 'package:online_bhangharwala/presentation/k3_screen/k3_screen.dart';
import 'package:online_bhangharwala/presentation/k5_screen/k5_screen.dart';
import 'package:online_bhangharwala/presentation/k6_screen/k6_screen.dart';
import 'package:online_bhangharwala/presentation/payment/payment.dart';
import 'package:online_bhangharwala/presentation/pickup_datetime/pickup_datetime.dart';
import 'package:online_bhangharwala/presentation/profile/profile.dart';
import 'package:online_bhangharwala/presentation/share_us/share_us.dart';
import 'package:online_bhangharwala/services/Apiservice.dart';
import 'package:online_bhangharwala/track_pickup/track_pickup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_export.dart';

class K0Screen extends StatefulWidget {
  const K0Screen({Key? key}) : super(key: key);

  @override
  _K0ScreenState createState() => _K0ScreenState();
}

class _K0ScreenState extends State<K0Screen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      _checkToken();
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => EditAddress()),
      // );
    });
  }

  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (accessToken != null && accessToken.isNotEmpty) {
      final ApiService apiService = ApiService();
      // Fetch user information
      final response1 = await apiService.getUserInfo();
      final response1Data = response1;
      print(response1Data);
      final name = prefs.getString('name');

      if (name == null) {
        await prefs.setString('name', response1Data['user']['firstname']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => K3Screen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => K6Screen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => K1Screen()),
      );
    }
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
