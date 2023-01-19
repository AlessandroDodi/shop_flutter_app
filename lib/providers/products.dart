import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product.dart';

class Products with ChangeNotifier {
  final List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  Future<void> addProduct(Product product) {
    final url = Uri.parse(
        'https://w-flutter-meals-default-rtdb.europe-west1.firebasedatabase.app/products.json');
    return http
        .post(
      url,
      body: json.encode({
        'title': product.title,
        'price': product.price,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'isFavorite': product.isFavorite,
      }),
    )
        .then((response) {
      final newValue = Product(
          description: product.description,
          id: json.decode(response.body)['name'],
          imageUrl: product.imageUrl,
          price: product.price,
          title: product.title);
      _items.add(newValue);
      notifyListeners();
    }).catchError((onError) {
      throw onError;
    });
  }

  void removeProduct(String productId) {
    _items.removeWhere((element) => productId == element.id);
    notifyListeners();
  }

  List<Product> get favorites {
    return [..._items.where((element) => element.isFavorite)];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void updateProduct(String productId, Product newProduct) {
    var index = _items.indexWhere((element) => element.id == productId);
    _items[index] = Product(
        description: newProduct.description,
        id: newProduct.id,
        imageUrl: newProduct.imageUrl,
        price: newProduct.price,
        title: newProduct.title);
    notifyListeners();
  }
}
