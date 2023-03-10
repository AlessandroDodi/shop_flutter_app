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

  Future<void> toggleFavorite(String token, String userId) async {
    final oldStatus = isFavorite;
    final url = Uri.parse(
        'https://w-flutter-meals-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token');
    try {
      final response = await http.put(url,
          body: json.encode({
            'isFavorite': !isFavorite,
          }));
      notifyListeners();

      isFavorite = !isFavorite;
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
      }
    } catch (e) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
