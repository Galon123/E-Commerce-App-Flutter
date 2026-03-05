import 'package:e_commerce_app/models/bid.dart';
import 'package:e_commerce_app/services/api_client.dart';
import 'package:flutter/material.dart';

class MyBids extends StatefulWidget {
  const MyBids({super.key});

  @override
  State<MyBids> createState() => _MyBidsState();
}

class _MyBidsState extends State<MyBids> {

  final ScrollController _scrollController = ScrollController();

  bool isLoading=false;
  bool _hasMore = true;
  int _skip = 0;
  final int _limit = 10;


  List<Bid> myBids=[];


  @override
  void initState(){
    super.initState();
    _fetchMyBids();

    _scrollController.addListener((){
      if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200){
        _fetchMyBids();
      }
    });
  }



  Future <void> _fetchMyBids() async{

    if(isLoading || !_hasMore) return;

    setState(() => isLoading=true);

    try{
      final response = await ApiClient.dio.get("/bids/mybids?skip=$_skip&limit=$_limit");

      if(response.statusCode == 404){
        setState(() {
          isLoading = false;
          _hasMore = false;
        });
      }

      final List<dynamic> data = response.data;

      final List<Bid> newBids = data.map((json)=>Bid.fromJson(json)).toList();

      setState(() {
        _skip += _limit;

        myBids.addAll(newBids);
        isLoading = false;

        if(newBids.isEmpty){
          _hasMore = false;
        }
      });
    }
    catch(e){
      debugPrint("Error Fetching Bids : $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Bids", style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Container(
        color: Colors.amberAccent.shade100,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(8.0),
              sliver: SliverGrid(
                delegate:SliverChildBuilderDelegate(
                  (context,index) => _buildBidCard(myBids[index]),
                  childCount: myBids.length
                ), 
                gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1.44,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10
                )
              ),
            ),
            SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              alignment: Alignment.center,
              child: _hasMore
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
      )
    );
  }



  Widget _buildBidCard(Bid bid){
    return SizedBox(
      height: 50,
      width: double.infinity, 
      child: (
        Card(
          color: Colors.orange.shade100,
          elevation: 4,
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(15),
          side: BorderSide(
            color: Colors.black,
            width: 2
          )
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Bid Status : ${bid.status}',style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  
                ),),
                Text('Your Bid Price : Rs.${bid.bidPrice}',style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  
                ),),
                Row(
                  children: [
                    Text('Seller Rating : ${bid.rating}',style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  
                ),),
                    Icon(Icons.star)
                  ],
                )
              ],
            ),
          ),
        )
      ),
    );
  }

}