import 'package:e_commerce_app/assets/constants.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/providers/user_provider.dart';
import 'package:e_commerce_app/screens/extras/item_detail.dart';
import 'package:e_commerce_app/services/api_client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    // Initial fetch only if list is empty
    final provider = Provider.of<UserProvider>(context, listen: false);
    if (provider.allProducts.isEmpty) {
      provider.fetchItems();
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        // Tell the provider to load the next page
        Provider.of<UserProvider>(context, listen: false).fetchItems();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Rebuilds whenever notifyListeners() is called in UserProvider
    final provider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text("Feed", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.secondaryColor,
        leading: ElevatedButton(onPressed: ()async=>{await Provider.of<UserProvider>(context, listen: false).logout()}, child: Text("Logout", style: TextStyle(color: Colors.red),)),
      ),
      body: RefreshIndicator(
        onRefresh: () async{ await provider.refreshFeed(); },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(12.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildProductCard(provider.allProducts[index]),
                    childCount: provider.allProducts.length,
                  ),
                ),
              ),
              
              // Bottom Loader/Status
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  alignment: Alignment.center,
                  child: provider.hasMore
                      ? const CircularProgressIndicator()
                      : const Column(
                          children: [
                            Icon(Icons.check_circle_outline, color: Colors.green, size: 30),
                            SizedBox(height: 8),
                            Text("You're all caught up!", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                          ],
                        ),
                ),
              ),
            ],
          ),
      ),
    );
  }

  Widget _buildProductCard(Product product){

    String imageUrl = product.img_url;
    if (imageUrl.contains('127.0.0.1') || imageUrl.contains('localhost')) {
      imageUrl = imageUrl.replaceAll('http://127.0.0.1:8000', BASE_URL); 
    }

    return Card(
      color: Colors.deepOrange.shade100,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(15),
        side: BorderSide(
          color: Colors.black,
          width: 2
        )
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.all(4),
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(15)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                    child: Image.network(imageUrl, fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                        Container(color: Colors.grey[200], child: const Icon(Icons.image_not_supported),)
                    ),
                )
              ),
            ),
            GestureDetector(
              onTap: () =>{
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => ItemDetail(product: product,))
                )
              },
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          product.title,
                            style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 25,
                            color: Colors.green.shade400
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_2_outlined),
                            Text(
                              'By ${product.sellerName}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.green.shade400
                              ),
                            )
                          ],
                        ),
                        Text(
                          "₹${product.price}",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: Colors.green.shade600
                          ),
                        )
                      ],
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}