import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/orders.dart';
import 'package:shop_flutter_app/widgets/order_item.dart' as o;

class OrderScreen extends StatelessWidget {
  static String routeName = '/product';
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      body: ListView.builder(
        itemBuilder: ((context, index) =>
            o.OrderItem(ordersData.orders[index])),
        itemCount: ordersData.orders.length,
      ),
    );
  }
}
