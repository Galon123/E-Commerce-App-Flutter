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
    return Scaffold(
      appBar: AppBar(
        title:const Text("HomeScreen"),
        backgroundColor: Colors.green[300],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () { Scaffold.of(context).openDrawer; }, 
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          }
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text("Text1"),
            ),
            ListTile(
              title: const Text("Text2"),
            ),
            ListTile(
              title: const Text("Text3"),
            )
          ],
        ),
      ),
    );
  }
}