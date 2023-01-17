import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/cart.dart' show Cart;
import 'package:shop_flutter_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Your cart')),
      body: Column(
        children: [
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
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        label: Text('\$${cart.totalAmount}'),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {}, child: const Text('Order now'))
                  ],
                )),
          ),
          SizedBox(
              height: 500,
              child: Expanded(
                child: ListView.builder(
                  itemCount: cart.itemCount,
                  itemBuilder: (context, index) => CartItem(
                      // key: Key(cart.items.values.toList()[index].id.toString()),
                      id: cart.items.values.toList()[index].id,
                      productId: cart.items.keys.toList()[index],
                      title: cart.items.values.toList()[index].title,
                      price: cart.items.values.toList()[index].price,
                      quantity: cart.items.values.toList()[index].quantity),
                ),
              ))
        ],
      ),
    );
  }
}
