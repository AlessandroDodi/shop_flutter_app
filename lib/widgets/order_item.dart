import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:shop_flutter_app/providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  const OrderItem(this.order, {super.key});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy')
                .format(widget.order.dateTime)
                .toString()),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_more : Icons.expand_less),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            SizedBox(
              height: min(widget.order.products.length * 20 + 100, 180),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(children: [
                  ...widget.order.products.map(
                    (e) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.title,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const Divider(),
                          Text('${e.quantity}x \$${e.price}'),
                        ]),
                  ),
                ]),
              ),
            ),
        ],
      ),
    );
  }
}
