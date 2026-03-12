import 'package:e_commerce_app/assets/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  MyBottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.secondaryColor, borderRadius: BorderRadius.circular(60), border: Border.all(width: 2),),
      child: GNav(
        tabBackgroundGradient: LinearGradient(
          colors: [AppColors.secondaryColor, AppColors.primaryColor],
          begin: AlignmentGeometry.topCenter,
          end: AlignmentGeometry.bottomCenter
        ),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
        color: Colors.lightGreen,
        activeColor: Colors.greenAccent,
        tabActiveBorder: Border.all(color: Colors.white),
        tabBackgroundColor: Color.fromARGB(255, 30, 73, 126),
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