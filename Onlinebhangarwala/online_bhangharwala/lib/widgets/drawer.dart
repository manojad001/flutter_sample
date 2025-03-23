import 'package:flutter/material.dart';
import 'package:online_bhangharwala/presentation/about_us/about_us.dart';
import 'package:online_bhangharwala/presentation/how_its_works/how_its_works.dart';
import 'package:online_bhangharwala/presentation/k1_screen/k1_screen.dart';
import 'package:online_bhangharwala/presentation/offer/offer.dart';
import 'package:online_bhangharwala/presentation/pickup_request/pickup_request.dart';
import 'package:online_bhangharwala/presentation/scrap_pickup/scrap_pickup.dart';
import 'package:online_bhangharwala/presentation/share_us/share_us.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  String userName = 'User';

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name') ?? 'Guest';
    setState(() {
      userName = name;
    });
  }

  Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0XFF06193D),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0XFF06193D),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Center(
                  child: Text(
                    'Welcome,\n$userName',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _createDrawerItem(
                    text: 'Pickup Requests',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PickupRequestsScreen()),
                      );
                    },
                  ),
                  _createDrawerItem(
                    text: 'Offers & Benefits',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CouponOffersBenefit()),
                      );
                    },
                  ),
                  _createDrawerItem(
                    text: 'How It Works',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HowitsWork()),
                      );
                    },
                  ),
                  _createDrawerItem(
                    text: 'Share Us',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShareUsScreen()),
                      );
                    },
                  ),
                  _createDrawerItem(
                    text: 'About Us',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutUs()),
                      );
                    },
                  ),
                  _createDrawerItem(
                    text: 'Call Us',
                    onTap: () {
                      _callNumber('9028213888');
                    },
                  ),
                  _createDrawerItem(
                    text: 'Log Out',
                    onTap: () async {
                      await clearToken();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => K1Screen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createDrawerItem(
      {required String text, required GestureTapCallback onTap}) {
    return ListTile(
      title: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
      onTap: onTap,
    );
  }

  void _callNumber(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        _showSnackBar('Could not launch $number');
      }
    } catch (e) {
      _showSnackBar('An error occurred: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
