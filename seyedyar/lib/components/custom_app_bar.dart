import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String name;
  final int studentID;
  final bool showProfileButton;
  final VoidCallback? onProfileTap;

  CustomAppBar({
    required this.title,
    required this.name,
    required this.studentID,
    this.showProfileButton = false,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromARGB(255, 28, 135, 83),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Image.asset(
              'lib/images/Logo1.png',
              height: 105,
              width: 105,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "$title        ",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (showProfileButton)
            IconButton(
              icon: Icon(Icons.person),
              color: Colors.black,
              onPressed: onProfileTap,
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
