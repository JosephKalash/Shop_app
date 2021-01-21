// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/dismissed_container.dart';

class CardItem extends StatelessWidget {
  final double price;
  final String title;
  final int quantity;
  final String id;
  final String productId;

  CardItem(this.price, this.productId, this.title, this.quantity, this.id);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: DismissedContainer(
        color: Colors.green,
        icon: Icons.add_shopping_cart,
        rightPadding: 0,
        leftPadding: 8,
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: DismissedContainer(
        color: Theme.of(context).errorColor,
        icon: Icons.delete_sweep,
        rightPadding: 8,
        leftPadding: 0,
        alignment: Alignment.centerRight,
      ),
      onDismissed: (direction) {
        controlDirection(direction, context);
      },
      confirmDismiss: (direction) {
        if (direction == DismissDirection.endToStart && quantity == 1) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to remove the item from the cart?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'NO',
                    textAlign: TextAlign.end,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'Yes',
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),
          );
        }
        return Future.value(true);
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: FittedBox(
                child: Text(
              '\$$price',
              style: TextStyle(
                color: Theme.of(context).primaryTextTheme.headline6.color,
              ),
            )),
          ),
          title: Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          subtitle: Text('\$${(price * quantity)}'),
          trailing: Text(
            '$quantity x',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  void controlDirection(DismissDirection direction, BuildContext context) {
    final Cart cart = Provider.of<Cart>(context, listen: false);

    if (direction == DismissDirection.endToStart)
      cart.removeOneItemQuantity(productId);
    else if (direction == DismissDirection.startToEnd) cart.addOneItemQuantity(productId);
  }
}
