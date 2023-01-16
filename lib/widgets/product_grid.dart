import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/product.dart';
import 'package:shop_flutter_app/widgets/product_item.dart';

// ignore: must_be_immutable
class PrductGrid extends StatelessWidget with ChangeNotifier {
  final List<Product> loadedProducts;
  final bool showFavorites;
  PrductGrid(this.loadedProducts, this.showFavorites, {super.key});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: loadedProducts.length,
      itemBuilder: ((context, index) => ChangeNotifierProvider.value(
            value: loadedProducts[index],
            child: const ProductItem(),
          )),
    );
  }
}
