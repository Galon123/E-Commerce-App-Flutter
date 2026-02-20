import 'dart:ui';

import 'package:e_commerce_app/screens/auth/register_screen.dart';
import 'package:e_commerce_app/screens/feed/feed_screen.dart';
import 'package:e_commerce_app/screens/profile/profile_screen.dart';
import 'package:e_commerce_app/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class MainNavigationHub extends StatefulWidget {
  const MainNavigationHub({super.key});

  @override
  State<MainNavigationHub> createState() => _MainNavigationHubState();
}

class _MainNavigationHubState extends State<MainNavigationHub> {
  int _currentIndex=0;

  void navigateBottomBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _screens =[
    const FeedScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 15, horizontal: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: MyBottomNavBar(
                  onTabChange:(index)=> navigateBottomBar(index)
                ),
          ),
        ),
      ),
      body: _screens[_currentIndex],
    );
  }
}