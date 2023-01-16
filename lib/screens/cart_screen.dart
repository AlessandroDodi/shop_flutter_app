import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/cart.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your cart')),
      body: Column(children: [
        Card(
          margin: const EdgeInsets.all(10),
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const Text(
                    'total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Chip(
                    label: Text('\$${Provider.of<Cart>(context).totalAmount}'),
                    backgroundColor: Theme.of(context).primaryColor,
                  )
                ],
              )),
        )
      ]),
    );
  }
}
