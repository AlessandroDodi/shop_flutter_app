import 'package:flutter/material.dart';
import 'package:shop_flutter_app/screens/orders_screen.dart';
import 'package:shop_flutter_app/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: const Text('Hello Friend!'),
          automaticallyImplyLeading: false,
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () => Navigator.of(context).pushReplacementNamed('/'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('Orders'),
          onTap: () =>
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Manage products'),
          onTap: () => Navigator.of(context)
              .pushReplacementNamed(UserProductsScreen.routeName),
        ),
      ]),
    );
  }
}
