import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/providers/order.dart';
import '../providers/cart.dart' show Cart;
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Carts'),
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            child: Card(
              margin: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.all(8),
                    label: Text(
                      '\$${cart.priceTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: 1,
                    child: FlatButton(
                      child: Text(
                        'ORDER NOW',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      onPressed: () {
                        Provider.of<Order>(context,listen: false)
                        .addItem(
                          cart.items.values.toList(),
                          cart.priceTotal,
                        );
                        cart.clear();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 11),
              itemCount: cart.itemCount,
              itemBuilder: (ctx, i) => CardItem(
                cart.items.values.toList()[i].price,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].title,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].id,
              ),
            ),
          )
        ],
      ),
    );
  }
}
