import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  MyBottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.transparent,borderRadius: BorderRadius.circular(15)),
      child: GNav(
        color: Colors.blueGrey,
        activeColor: Colors.white,
        tabActiveBorder: Border.all(color: Colors.white),
        tabBackgroundColor: const Color.fromARGB(125, 0, 0, 0),
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        tabBorderRadius: 40,
        onTabChange: (value) => onTabChange!(value),
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.person_2_outlined,
            text: 'Profile',
          )
        ]
      ),
    );
  }
}