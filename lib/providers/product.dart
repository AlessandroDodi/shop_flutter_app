import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  bool isFavorite;
  Product(
      {required this.description,
      required this.id,
      required this.imageUrl,
      this.isFavorite = false,
      required this.price,
      required this.title});

  Future<void> toggleFavorite() async {
    final oldStatus = isFavorite;
    final url = Uri.parse(
        'https://w-flutter-meals-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');
    try {
      final response = await http.patch(url,
          body: json.encode({
            'isFavorite': !isFavorite,
          }));
      isFavorite = !isFavorite;
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (e) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
