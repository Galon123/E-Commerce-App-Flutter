import 'dart:ffi';

class Product {

  final int id;
  final String title;
  final String sellerName;
  final String description;
  final Float price;

  Product({required this.id, required this.title, required this.description, required this.price, required this.sellerName});

  factory Product.fromJson(Map <String, dynamic> json){
    return Product(
      id: json['id'], 
      title: json['title'], 
      sellerName: json['username'],
      description: json['description'], 
      price: json['price']
      );
  }
}