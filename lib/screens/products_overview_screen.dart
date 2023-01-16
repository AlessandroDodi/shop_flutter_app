import 'package:flutter/material.dart';
import 'package:shop_flutter_app/providers/products.dart';
import 'package:shop_flutter_app/widgets/product_grid.dart';
import 'package:provider/provider.dart';

class ProductOverviewScreen extends StatelessWidget {
  const ProductOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: false);
    final products = productsData.items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My shop'),
      ),
      body: PrductGrid(products),
    );
  }
}
