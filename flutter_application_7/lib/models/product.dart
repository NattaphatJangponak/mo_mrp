// model/product.dart

import 'dart:convert';

class Product {
  int id;
  String title;
  String description;
  int price;
  double star;
  String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.star,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        price: json["price"],
        star: json["star"]?.toDouble() ?? 0.0,
        imageUrl: json["imageUrl"],
      );
}
