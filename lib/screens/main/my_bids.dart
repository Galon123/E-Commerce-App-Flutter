import 'package:e_commerce_app/assets/constants.dart';
import 'package:e_commerce_app/models/bid.dart';
import 'package:e_commerce_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBids extends StatefulWidget {
  const MyBids({super.key});

  @override
  State<MyBids> createState() => _MyBidsState();
}

class _MyBidsState extends State<MyBids> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState(){
    super.initState();

    final provider = Provider.of<UserProvider>(context, listen: false);
    if(provider.allBids.isEmpty){
      provider.fetchBids();
    }

    _scrollController.addListener((){
      if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200){
        provider.fetchBids();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: const Text("My Bids", style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.refreshBids(),
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(8.0),
              sliver: SliverGrid(
                delegate:SliverChildBuilderDelegate(
                  (context,index) => _buildBidCard(provider.allBids[index]),
                  childCount: provider.allBids.length
                ), 
                gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 2.88,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10
                )
              ),
            ),
            SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              alignment: Alignment.center,
              child: provider.hasMoreBids
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
    final provider = Provider.of<UserProvider>(context);
    return(
      Container(
        width: double.infinity,
        height: 20,
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(width: 3)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Bid Status : ", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textColour),),
                      Text(bid.status, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: const Color.fromARGB(255, 166, 243, 192)),)
                    ],
                  ),
                  Row(
                    children: [
                      Text("Bid Price : ", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textColour),),
                      Text("Rs.${bid.bidPrice}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: const Color.fromARGB(255, 170, 243, 195)),)
                    ],
                  ),
                  Row(
                    children: [
                      Text("Seller Rating : ${bid.rating}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textColour),),
                      Icon(Icons.star, color: AppColors.textColour,)
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () => {}, 
                icon: Icon(Icons.delete_rounded),
                color: Colors.red,
                iconSize: AppSizes.largeSize,
              )
            ],
          ),
        ),
      )
    );
  }

}