import 'dart:convert';
import 'package:eco_recycler/presentation/home/home.dart';
import 'package:eco_recycler/presentation/login/login.dart';
import 'package:eco_recycler/presentation/pickup/all_pickups.dart';
import 'package:eco_recycler/presentation/pickup/upcoming_pickup.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      userName = 'Eco Recycler';
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
                      text: 'Home',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      }),
                  _createDrawerItem(
                      text: 'Upcoming Pickup',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpcomingScreen(),
                          ),
                        );
                      }),
                  _createDrawerItem(
                      text: 'Pickup',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllpickupScreen(),
                          ),
                        );
                      }),
                  //_createDrawerItem(text: 'Support', onTap: () {}),
                  SizedBox(height: 50),
                  _createDrawerItem(
                      text: 'Log Out',
                      onTap: () {
                        clearToken();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      }),
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
}
