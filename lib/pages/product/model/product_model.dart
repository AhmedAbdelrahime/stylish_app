// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class ProductModel {
  final int id;
  final String name;
  final double price;
  final String title;
  final String des;
  final double rat;
  List<String> images;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.title,
    required this.des,
    required this.rat,
    required this.images,
  });
}

// class ProudectImages {
//   final String image1;
//   final String image2;
//   final String image3;

//   ProudectImages({
//     required this.image1,
//     required this.image2,
//     required this.image3,
//   });
// }

List<ProductModel> items = [
  ProductModel(
    id: 12,
    name: 'NIke Sneakers',
    price: 150,
    title: 'Vision Alta Men’s Shoes Size (All Colours)',
    des:
        'Perhaps the most iconic sneaker of all-time, this original "Chicago"? colorway is the cornerstone to any sneaker collection. Made famous in 1985 by Michael Jordan, the shoe has stood the test of time, becoming the most famous colorway of the Air Jordan ',
    rat: 4.5,
    images: [
      'assets/images/1.png',
      'assets/images/2.png',
      'assets/images/3.png',
    ],
  ),
];

List<int> sizeproduct = [6, 7, 8, 9, 10];

class Privacy {
  final String text;
  final IconData icon;
  Privacy({required this.text, required this.icon});
}

List<Privacy> privacy = [
  Privacy(text: 'Refund Policy', icon: Icons.lock),
  Privacy(text: 'Return Policy', icon: Icons.local_shipping),
  Privacy(text: 'Terms ', icon: Icons.description),
];

// ProudectImages(

// )

// List<ProductModel> items = [

// ];
