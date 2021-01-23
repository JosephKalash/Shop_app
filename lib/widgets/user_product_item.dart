import 'package:flutter/material.dart';
import 'package:flutter_app/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';

class UserProductItem extends StatelessWidget {
  final String productId;
  final String title;
  final String imageUrl;

  UserProductItem(this.productId, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(title),
          trailing: SizedBox(
            width: 100,
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    try {
                      Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: productId);
                    } catch (_) {
                      scaffold.showSnackBar(snackBarError('editing error!'));
                    }
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.purple,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    try {
                      await Provider.of<Products>(context, listen: false).removeProduct(productId);
                    } catch (_) {
                      scaffold.showSnackBar(snackBarError('deleting field!'));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }

  SnackBar snackBarError(String message) {
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }
}
