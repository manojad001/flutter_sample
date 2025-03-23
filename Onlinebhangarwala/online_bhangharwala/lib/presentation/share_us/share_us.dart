import 'package:flutter/material.dart';
import 'package:online_bhangharwala/presentation/k6_screen/k6_screen.dart';

class ShareUsScreen extends StatelessWidget {
  const ShareUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF06193D),
        title: Text(
          'Share Us',
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
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Handle share button press
            },
          ),
        ],
      ),
      body: Container(
        color: Color(0xFF001840),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ask your friends to sell their scrap with us.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Now sell your scrap easily from your doorsteps with Online Bhangarwala. Raise a pickup request.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 40),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blueGrey[700],
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueGrey[800],
                child: Icon(
                  Icons
                      .description, // You can use any icon or your custom image here
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 40),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  child: Text('Share'),
                ),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
