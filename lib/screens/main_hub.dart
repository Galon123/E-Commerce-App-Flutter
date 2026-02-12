import 'package:e_commerce_app/screens/feed/feed_screen.dart';
import 'package:flutter/material.dart';

class MainNavigationHub extends StatefulWidget {
  const MainNavigationHub({super.key});

  @override
  State<MainNavigationHub> createState() => _MainNavigationHubState();
}

class _MainNavigationHubState extends State<MainNavigationHub> {
  int _currentIndex=0;

  final List<Widget> _screens =[
    const FeedScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
    );
  }
}