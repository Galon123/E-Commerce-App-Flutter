import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  MyBottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(60), border: Border.all(width: 2)),
      child: GNav(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        color: Colors.blueGrey,
        activeColor: Colors.indigo,
        tabActiveBorder: Border.all(color: Colors.white),
        tabBackgroundColor: Colors.grey.shade200,
        tabBorderRadius: 40,
        onTabChange: (value) => onTabChange!(value),
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.monetization_on_sharp,
            text: 'My Bids ',
          ),
          GButton(
            icon: Icons.list,
            text: 'My Listings',
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