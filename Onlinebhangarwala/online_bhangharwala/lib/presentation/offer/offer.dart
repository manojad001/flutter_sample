import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:online_bhangharwala/services/Apiservice.dart';

class CouponOffersBenefit extends StatefulWidget {
  @override
  State<CouponOffersBenefit> createState() => _CouponOffersBenefitState();
}

class _CouponOffersBenefitState extends State<CouponOffersBenefit> {
  @override
  void initState() {
    super.initState();
    GetCoupoonValue();
  }

  Future<void> GetCoupoonValue() async {
    final ApiService apiService = ApiService();
    final response = await apiService.GetCoupoonValue();

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final coupon = responseBody['data'];
      print(coupon);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Offers & Benefits',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Coupons',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            CouponCard(
              title: 'BHANGARWALA100',
              description:
                  'Get ₹50 extra on this request using this coupon code',
            ),
            const SizedBox(height: 20.0),
            CouponCard(
              title: 'BHANGARWALA50',
              description:
                  'Get ₹45 extra on this request using this coupon code',
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF06193D),
    );
  }
}

class CouponCard extends StatelessWidget {
  final String title;
  final String description;

  const CouponCard({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xff143b98),
      elevation: 8.0,
      shadowColor: Colors.black45,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade400,
                    Colors.green.shade800,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 6.0,
              ),
              child: Text(
                'EXTRA PRICE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {},
                  child: const Text(
                    '+ MORE',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Claim Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
