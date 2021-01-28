import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///listen is false because the only change is on favorite icon so we make it child of consumer.
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: product.id);

            ///could send multiple arguments as map.
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                size: 24,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavorite();
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              size: 22,
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addCard(product.id, product.title, product.price);

              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Added one cart'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      ///this will also removes a cartItem if his quantity was one.
                      cart.removeOneItemQuantity(product.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

