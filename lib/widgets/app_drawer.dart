import 'package:flutter/material.dart';
import 'package:shop_flutter_app/screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text('Hello Friend!'),
          automaticallyImplyLeading: false,
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () => Navigator.of(context).pushReplacementNamed('/'),
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.history),
          title: Text('Orders'),
          onTap: () => Navigator.of(context).pushNamed(OrderScreen.routeName),
        ),
      ]),
    );
  }
}
