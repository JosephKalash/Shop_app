import 'package:flutter/material.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../widgets/productGridItem.dart';

class ProductsGrid extends StatelessWidget {
  final bool favoriteOnly;

  ProductsGrid(this.favoriteOnly);

  @override
  Widget build(BuildContext context) {
    ///build channel to object products and listen to changes.
    final productsData = Provider.of<Products>(context);
    final products = favoriteOnly ? productsData.getFavoriteOnly() :  productsData.items;
    //TODO (1): RUN Provider.of<Product>(context); to see the exception.
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,  ///column items / or row items if horizontal
        mainAxisSpacing: 15,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      /** use .value in this case because the value are initialized and better performance*/
      itemBuilder: (_, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductGridItem(),
      ),
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
    );
  }
}
