import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;
  CartItem(
      {required this.id,
      required this.price,
      required this.quantity,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: (ListTile(
          leading: CircleAvatar(
            child: FittedBox(child: Text('\$${price}')),
          ),
          title: Text(
            '${title}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Total: \$${price * quantity}'),
          trailing: Text('${quantity}x'),
        )),
      ),
    );
  }
}