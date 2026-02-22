import 'package:flutter/material.dart';

class CreateBid extends StatelessWidget {
  final int itemId;
  const CreateBid({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Bid Screen"),),
    );
  }
}