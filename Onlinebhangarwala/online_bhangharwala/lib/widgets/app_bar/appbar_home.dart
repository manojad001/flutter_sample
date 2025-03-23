import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData icon;

  CustomAppBar({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu,
              color: Colors.white), // Set menu icon color to white
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      title: Row(
        children: [
          Text(
            title,
            style:
                TextStyle(color: Colors.white), // Set title text color to white
          ),
          SizedBox(width: 8),
          Icon(icon, color: Colors.white), // Set icon color to white
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications,
              color: Colors.white), // Set notifications icon color to white
          onPressed: () {
            // Handle notifications button press
          },
        ),
      ],
      backgroundColor: Color(0xFF06193D), // Adjusted color format
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
