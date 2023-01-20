import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_flutter_app/models/http_exception.dart';
import 'dart:convert';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items;
  final String authToken;
  final String userId;
  List<Product> get items {
    return [..._items];
  }

  Products(this.authToken, this._items, this.userId);

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://w-flutter-meals-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final favoiteResponse = await http.get(
        Uri.parse(
            'https://w-flutter-meals-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken'),
      );
      final favoriteData = json.decode(favoiteResponse.body);
      print("favoritedata:$favoriteData");
      final List<Product> loadedProducts = [];
      //if (extractedData == null) return;
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            description: prodData['description'],
            id: prodId,
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            isFavorite:
                favoriteData?[prodId]?['isFavorite'].toString().toLowerCase() ==
                    'true',
            title: prodData['title'],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://w-flutter-meals-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        }),
      );
      final newValue = Product(
          description: product.description,
          id: json.decode(response.body)['name'],
          imageUrl: product.imageUrl,
          price: product.price,
          title: product.title);
      _items.add(newValue);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  void removeProduct(String productId) {
    final url = Uri.parse(
        'https://w-flutter-meals-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.json?auth=$authToken');

    final existingProductIndex =
        _items.indexWhere((element) => element.id == productId);
    // ignore: unused_local_variable
    final existingProduct = _items[existingProductIndex];
    http.delete(url).then((response) {
      if (response.statusCode >= 400) {
        throw HttpException('Could not delete product');
      }
    }).catchError((onError) {
      _items.insert(existingProductIndex, existingProduct);
    });
    _items.removeAt(existingProductIndex);
    notifyListeners();
  }

  List<Product> get favorites {
    return [..._items.where((element) => element.isFavorite)];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> updateProduct(String productId, Product newProduct) async {
    var index = _items.indexWhere((element) => element.id == productId);
    final url = Uri.parse(
        'https://w-flutter-meals-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.json?auth=$authToken');
    if (index >= 0) {
      http.patch(url,
          body: json.encode(
            {
              'title': newProduct.title,
              'price': newProduct.price,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
            },
          ));

      _items[index] = Product(
          description: newProduct.description,
          id: newProduct.id,
          imageUrl: newProduct.imageUrl,
          price: newProduct.price,
          title: newProduct.title);
      notifyListeners();
    }
  }
}
