import 'package:flutter/material.dart';
import 'package:online_bhangharwala/core/utils/image_constant.dart';
import 'package:online_bhangharwala/presentation/k6_screen/k6_screen.dart';

class HowitsWork extends StatelessWidget {
  const HowitsWork({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF06193D),
        title: Text(
          'How Online Bhangarwala Works?',
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
      ),
      body: Container(
        color: Color(0xFF06193D),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Sell your scrap in 4 easy steps.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    StepWidget(
                      imagePath: ImageConstant.how_works_scrap,
                      title: 'Select a scrap for pickup',
                      description:
                          'We collect scrap from a wide list of items like Newspaper, Iron, Electronic Machine, Beer Bottle etc. We do not pickup cloth, wood, and glass.',
                    ),
                    StepWidget(
                      imagePath: ImageConstant.how_works_calender,
                      title: 'Choose a date for scrap pickup',
                      description:
                          'Choose a date when you want our executives to come for scrap pickup. You can book a request for the next day. Our pickup time will be between your selected time.',
                    ),
                    StepWidget(
                      imagePath: ImageConstant.how_works_ecorecycler,
                      title:
                          'Pickup agents will arrive at your home (On the scheduled day)',
                      description:
                          'You will receive a notification when our pickup executives are ready to come. They will bring an electronic machine to weigh each scrap item separately.',
                    ),
                    StepWidget(
                      imagePath: ImageConstant.how_works_money,
                      title: 'Scrap sold',
                      description:
                          'You will get a bill on your mobile and the amount will be transferred to your bank account immediately. The rates are non-negotiable, please check the rates before booking a pickup request.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StepWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  StepWidget({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(imagePath, width: 40, height: 40),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
