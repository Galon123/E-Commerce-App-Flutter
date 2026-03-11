import 'package:e_commerce_app/assets/constants.dart';
import 'package:flutter/material.dart';

class MyListings extends StatelessWidget {
  const MyListings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: const Text("My Listings", style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.secondaryColor,
        foregroundColor: Colors.white
      ),
    );
  }
}