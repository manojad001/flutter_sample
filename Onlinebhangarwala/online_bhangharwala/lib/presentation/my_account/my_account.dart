import 'package:flutter/material.dart';
import 'package:online_bhangharwala/presentation/k1_screen/k1_screen.dart';
import 'package:online_bhangharwala/presentation/pickup_request/pickup_request.dart';
import 'package:online_bhangharwala/presentation/profile/profile.dart';
import 'package:online_bhangharwala/widgets/app_bar/appbar_home.dart';
import 'package:online_bhangharwala/widgets/bottomNavigation.dart';
import 'package:online_bhangharwala/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccountScreen extends StatefulWidget {
  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  int _currentIndex = 1;

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Home', icon: Icons.home),
      drawer: DrawerPage(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Account',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(16.0),
                    children: <Widget>[
                      ListTile(
                        title: Text('Profile'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Navigate to Profile screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(),
                            ),
                          );
                        },
                        textColor: Colors.white,
                        iconColor: Colors.white,
                      ),
                      Divider(color: Colors.white),
                      ListTile(
                        title: Text('Pickup History'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PickupRequestsScreen(),
                            ),
                          );
                          // Navigate to Pickup History screen
                        },
                        textColor: Colors.white,
                        iconColor: Colors.white,
                      ),
                      Divider(color: Colors.white),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  clearToken();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => K1Screen()),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Log Out', style: TextStyle(color: Colors.white)),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Color(0xff3b61f4),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
