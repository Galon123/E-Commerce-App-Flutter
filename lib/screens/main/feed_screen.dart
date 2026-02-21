import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/screens/extras/item_detail.dart';
import 'package:e_commerce_app/services/api_client.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  final ScrollController _scrollController =ScrollController();

  int _skip = 0;
  final int _limit = 10;
  bool isLoading = false;
  bool hasMore = true;

  List<Product> allProducts =[];

  @override
  void initState(){
    super.initState();
    _fetchItems();

    _scrollController.addListener(() {
      if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200){
        _fetchItems();
      }
    });
  }

  

  Future <void> _fetchItems() async{

    if(isLoading || !hasMore) return;

    setState(()=> isLoading = true);

    try{
      final response = await ApiClient.dio.get('/items/feed?skip=${_skip}&limit=${_limit}');

      if(response.statusCode == 404){
        setState(() {
          hasMore = false;
          isLoading = false;
        });
        return;
      }

      final List<dynamic> data = response.data;

      final List<Product> newItems = data.map((json) => Product.fromJson(json)).toList();
      

      setState(() {
        _skip+=_limit;
        
        allProducts.addAll(newItems);
        isLoading = false;
      });
      
    }
    catch(e){
      debugPrint("Error Fetching data : ${e}");
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("Feed",style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),),
    body: CustomScrollView(
      controller: _scrollController,
      slivers: [
        // The Grid part
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
              (context, index) => _buildProductCard(allProducts[index]),
              childCount: allProducts.length,
            ),
          ),
        ),
    
        // The Bottom UI part (Loader OR "Caught up" message)
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            alignment: Alignment.center,
            child: hasMore
                ? const CircularProgressIndicator() // Still loading
                : const Column(
                    children: [
                      Icon(Icons.check_circle_outline, color: Colors.green, size: 30),
                      SizedBox(height: 8),
                      Text(
                        "You're all caught up!",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    ),
    extendBody: true,
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
                  MaterialPageRoute(builder: (context) => ItemDetail(product: product))
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
              ),
            )
          ],
        ),
      ),
    );
  }
}