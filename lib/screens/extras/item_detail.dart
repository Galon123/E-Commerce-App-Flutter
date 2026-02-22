import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/screens/extras/create_bid.dart';
import 'package:e_commerce_app/services/api_client.dart';
import 'package:flutter/material.dart';

class ItemDetail extends StatelessWidget {
  final Product product;
  const ItemDetail({super.key, required this.product});

  void _showBidSheet(BuildContext context, int itemId, double minPrice) {
    final TextEditingController _bidController = TextEditingController();
    String? errorMessage; // To hold our validation message

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder( // Allows the sheet to update itself
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20, right: 20, top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Place Your Bid (Min: ₹$minPrice)",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _bidController,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  prefixText: "₹ ",
                  labelText: "Your Bid Amount",
                  errorText: errorMessage, // Displays the error red text
                  border: const OutlineInputBorder(),
                ),
                onChanged: (val) {
                  // Clear error as user types
                  if (errorMessage != null) {
                    setSheetState(() => errorMessage = null);
                  }
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                  onPressed: () {
                    final double? enteredAmount = double.tryParse(_bidController.text);
                    
                    // Validation Logic
                    if (enteredAmount == null) {
                      setSheetState(() => errorMessage = "Please enter a valid number");
                    } else if (enteredAmount < minPrice) {
                      setSheetState(() => errorMessage = "Bid must be at least ₹$minPrice");
                    } else {
                      _placeBid(context, itemId, enteredAmount);
                    }
                  },
                  child: const Text("Confirm Bid", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _placeBid(BuildContext context, int itemId, double amount) async {
    try {
      final response = await ApiClient.dio.post("/bids/create", data: {
        "item_id": itemId,
        "bid_price": amount,
      });

      if (response.statusCode == 200) {
        Navigator.pop(context); // Close sheet
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Bid of ₹$amount placed successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // If backend returns a 400 (e.g., bid too low compared to others)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not place bid. Try a higher amount.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Item detail"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              product.img_url.replaceAll('127.0.0.1', BASE_URL.replaceAll('http://', '').replaceAll(':8000', '')),
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
          child:ElevatedButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsetsGeometry.all(20)),
              backgroundColor: WidgetStateProperty.all(Colors.greenAccent.shade400),
              textStyle: WidgetStateProperty.all(TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white))
            ),
            onPressed: () => _showBidSheet(context, product.id, product.price),
            child: const Text("Place Bid"),
          ),
        ),
      ),
    );
  }
}