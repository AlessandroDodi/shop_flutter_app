import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/auth.dart';
import 'package:shop_flutter_app/providers/cart.dart';
import 'package:shop_flutter_app/providers/orders.dart';
import 'package:shop_flutter_app/providers/products.dart';
import 'package:shop_flutter_app/screens/auth_screen.dart';
import 'package:shop_flutter_app/screens/cart_screen.dart';
import 'package:shop_flutter_app/screens/edit_product_screen.dart';
import 'package:shop_flutter_app/screens/orders_screen.dart';
import 'package:shop_flutter_app/screens/user_products_screen.dart';
import '/screens/product_detail_screen.dart';
import '/screens/products_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, auth, previous) =>
              Products(auth.token ?? '', previous?.items ?? []),
          create: (context) => Products('', []),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, previous) =>
              Orders(auth.token ?? '', previous?.orders ?? []),
          create: (context) => Orders('', []),
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          update: (context, auth, previous) =>
              Cart(auth.token ?? '', previous?.items),
          create: (context) => Cart('', null),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
                .copyWith(secondary: Colors.teal[200]),
          ),
          home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (context) =>
                const ProductDetailScreen(),
            CartScreen.routeName: ((context) => const CartScreen()),
            OrderScreen.routeName: ((context) => const OrderScreen()),
            EditProductScreen.routeName: ((context) =>
                const EditProductScreen()),
            UserProductsScreen.routeName: ((context) =>
                const UserProductsScreen()),
            AuthScreen.routeName: ((context) => AuthScreen()),
          },
        ),
      ),
    );
  }
}
