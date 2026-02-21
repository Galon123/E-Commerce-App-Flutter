import 'package:e_commerce_app/models/product.dart';
import 'package:flutter/material.dart';

class ItemDetail extends StatelessWidget {
  final Product product;
  const ItemDetail({super.key, required this.product});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Item detail"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              product.img_url.replaceAll('127.0.0.1', '192.168.1.12'),
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    "₹${product.price}",
                    style: const TextStyle(
                      fontSize: 28, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.green
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  const Divider(height: 30),

                  // 3. Seller Info
                  Row(
                    children: [
                      const CircleAvatar(child: Icon(Icons.person)),
                      const SizedBox(width: 10),
                      Text("Listed by ${product.sellerName}", 
                           style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 4. Description
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${product.description}",
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16)],
        ),
        child:Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsetsGeometry.all(20)),
              backgroundColor: WidgetStateProperty.all(Colors.greenAccent.shade200),
              textStyle: WidgetStateProperty.all(TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white))
            ),
            onPressed: () {},
            child: const Text("Place Bid"),
          ),
        ),
      ),
    );
  }
}