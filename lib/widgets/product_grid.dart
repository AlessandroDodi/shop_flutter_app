import 'package:flutter/material.dart';
import 'package:shop_flutter_app/models/product.dart';
import 'package:shop_flutter_app/widgets/product_item.dart';

class PrductGrid extends StatelessWidget {
  const PrductGrid({
    Key? key,
    required this.loadedProducts,
  }) : super(key: key);

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
      itemBuilder: ((context, index) => ProductItem(
            id: loadedProducts[index].id,
            imageUrl: loadedProducts[index].imageUrl,
            title: loadedProducts[index].title,
          )),
    );
  }
}