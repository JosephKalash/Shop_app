import 'package:flutter/material.dart';
import 'package:flutter_app/screens/edit_product_screen.dart';
import 'package:flutter_app/widgets/appDrawer.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = '/products-screen';

  Future<void> _refreshContent(BuildContext context) async{
    await Provider.of<Products>(context,listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final Products products = Provider.of<Products>(context);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 40,
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh:() => _refreshContent(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(itemCount: products.items.length,itemBuilder: (_,i)=> UserProductItem(
            products.items[i].id,
            products.items[i].title,
            products.items[i].imageUrl,
          ),),
        ),
      ),
    );
  }
}
