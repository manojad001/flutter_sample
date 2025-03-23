import 'package:flutter/material.dart';
import 'package:online_bhangharwala/core/utils/image_constant.dart';
import 'package:online_bhangharwala/presentation/k6_screen/k6_screen.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF001840), // Background color matching the image
      appBar: AppBar(
        backgroundColor: Color(0xFF06193D),
        title: Text(
          'Who We Are?',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => K6Screen()),
            );
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Image.asset(
                ImageConstant.aboutusFav), // Replace with your image path
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              ImageConstant.aboutusLogo, // Replace with your image path
            ),
            SizedBox(height: 20.0),
            Text(
              'Online Bhangarwala is a doorstep service intends to help out people to sell their household scrap like Newspaper, Iron, Plastic, Books, Copies, Metal etc, and get paid for it.\n\n'
              'It is intended to recycle, reuse, reduce up-cycle and resell the scrap. It is a platform for the residents to participate in responsible waste management and is best in class technology, logistics to process the scrap.',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
