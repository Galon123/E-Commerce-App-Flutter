class Bid {

  final int id;
  final double bidPrice;
  final String username;
  final double rating;
  final String status;

  Bid({required this.id, required this.bidPrice, required this.username, required this.rating, required this.status, });


  factory Bid.fromJson(Map<String, dynamic>json){
    return Bid(
      id: json['id'], 
      bidPrice: json['bid_price'], 
      username: json['username'], 
      rating: json['rating'], 
      status: json['status']
    );
  }
}