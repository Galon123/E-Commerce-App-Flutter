import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/services/api_client.dart';
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
      final response = await ApiClient.dio.get('/items/feed');

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
      appBar: AppBar(title: const Text("Placeholder")),
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
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(product.title),
                    Text(product.sellerName)
                  ],
                ),
                Text("Rs.${product.price}")
              ],
            ),
          )
        ],
      ),
    );
  }
}