import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/k6_screen');
        break;
      case 1:
        Navigator.pushNamed(context, '/my_account');
        break;
      case 2:
        Navigator.pushNamed(context, '/calculator');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        onTap(index);
        _navigateToPage(context, index);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Schedule Pickup',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'My Account',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calculate),
          label: 'Calculator',
        ),
      ],
      selectedItemColor: Color(0xff3b61f4), // Color for the selected item
    );
  }
}
