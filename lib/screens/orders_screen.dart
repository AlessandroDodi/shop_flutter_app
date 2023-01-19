import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/orders.dart';
import 'package:shop_flutter_app/widgets/app_drawer.dart';
import 'package:shop_flutter_app/widgets/order_item.dart' as o;

class OrderScreen extends StatelessWidget {
  static String routeName = '/product';

  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<Orders>(
                    builder: (context, value, child) => ListView.builder(
                      itemBuilder: ((context, index) =>
                          o.OrderItem(value.orders[index])),
                      itemCount: value.orders.length,
                    ),
                  );
          }),
    );
  }
}
