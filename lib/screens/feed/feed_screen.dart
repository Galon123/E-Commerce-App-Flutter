import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/services/api_client.dart';
import 'package:e_commerce_app/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late Future<List<Product>?> _listingsFuture;

  @override
  void initState(){
    super.initState();

    _listingsFuture = _fetchItems();
  }

  Future<List<Product>?> _fetchItems() async{

    try{
      final response = await ApiClient.dio.get('/items/feed?skip=0&limit=10');

      final List<dynamic> data = response.data;

      return data.map((json)=>Product.fromJson(json)).toList();
    }
    catch(e){
      debugPrint("Error Fetching data : ${e}");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed',style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),)),
      body: FutureBuilder(
        future: _listingsFuture, 
        builder: (context,snapshot){

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }

          if(snapshot.hasError){
            return  Center(child: Text("Error: ${snapshot.error}"));
          }

          final products = snapshot.data;
          return GridView.builder(
            padding: EdgeInsets.all(12.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75
            ), 
            itemCount: products?.length ?? 0,
            itemBuilder: (context, index){
              if(products!=null){
                final product = products[index];
                return _buildProductCard(product);
              }
            }
          );
        }
      ),
    );
  }


  Widget _buildProductCard(Product product){
    String imageUrl = product.img_url;
    if (imageUrl.contains('127.0.0.1') || imageUrl.contains('localhost')) {
      imageUrl = imageUrl.replaceAll('http://127.0.0.1:8000', BASE_URL); 
    }

    return Card(
      color: Colors.blue.shade100,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(15),
        side: BorderSide(
          color: Colors.black,
          width: 2
        )
      ),
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
               )
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                    style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 25,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.person_2_outlined),
                    Text(
                      'By ${product.sellerName}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15
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
          )
        ],
      ),
    );
  }
}