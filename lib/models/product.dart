import 'dart:ffi';

class Product {

  final int id;
  final String title;
  final String sellerName;
  final String description;
  final double price;
  final String img_url;

  Product({required this.id, required this.title, required this.description, required this.price, required this.sellerName, required this.img_url});

  factory Product.fromJson(Map <String, dynamic> json){
    return Product(
      id: json['id'], 
      title: json['title'], 
      sellerName: json['username'],
      description: json['description'], 
      price: json['price'],
      img_url: json['primary_image']
      );
  }
}