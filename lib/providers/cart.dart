import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem>? _items;
  final String authToken;
  Cart(this.authToken, this._items);

  Map<String, CartItem> get items {
    return {...?_items};
  }

  int get itemCount {
    return _items?.length ?? 0;
  }

  double get totalAmount {
    var total = 0.0;
    _items?.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items!.containsKey(productId)) {
      _items?.update(
        productId,
        (value) => CartItem(
            id: value.id,
            price: value.price,
            title: value.title,
            quantity: value.quantity + 1),
      );
    } else {
      _items?.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            price: price,
            title: title,
            quantity: 1),
      );
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items?.remove(productId);

    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items!.containsKey(productId)) {
      return;
    }
    if (_items![productId]!.quantity > 1) {
      _items?.update(
          productId,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              quantity: value.quantity - 1,
              price: value.price));
    } else {
      _items?.remove(productId);
    }
    notifyListeners();
  }
}
