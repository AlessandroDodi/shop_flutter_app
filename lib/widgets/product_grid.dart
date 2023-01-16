import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/product.dart';
import 'package:shop_flutter_app/widgets/product_item.dart';

class PrductGrid extends StatelessWidget with ChangeNotifier {
  PrductGrid(this.loadedProducts, {super.key});

  final List<Product> loadedProducts;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: loadedProducts.length,
      itemBuilder: ((context, index) => ChangeNotifierProvider(
            create: (context) => loadedProducts[index],
            child: const ProductItem(),
          )),
    );
  }
}
