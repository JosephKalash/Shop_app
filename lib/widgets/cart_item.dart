import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;

class CardItem extends StatelessWidget {
  final double price;
  final String title;
  final int quantity;
  final String carId;
  final String productId;

  CardItem(this.price, this.productId, this.title, this.quantity, this.carId);

  @override
  Widget build(BuildContext context) {
    /** functionality to add +1 for this product
     * or delete +1 and delete from cart if there is only 1.*/
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
        _controlDismissDirection(direction, context);
      },
      confirmDismiss: (direction) {
        if (direction == DismissDirection.endToStart && quantity == 1) return _buildShowDialog(context);

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
              ),
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          subtitle: Text('\$${(price * quantity).toStringAsFixed(2)}'),
          trailing: Text(
            '$quantity x',
            style: TextStyle(
              fontSize: 20,
              color: Colors.deepOrange,
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to remove the item from the cart?'),
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

  void _controlDismissDirection(DismissDirection direction, BuildContext context) {
    final Cart cart = Provider.of<Cart>(context, listen: false);

    if (direction == DismissDirection.endToStart)
      cart.removeOneItemQuantity(productId);
    else if (direction == DismissDirection.startToEnd) cart.addOneItemQuantity(productId);
  }
}

class DismissedContainer extends StatelessWidget {
  final Color color;
  final IconData icon;
  final double rightPadding;
  final double leftPadding;
  final Alignment alignment;

  DismissedContainer({
    @required this.color,
    @required this.icon,
    @required this.rightPadding,
    @required this.leftPadding,
    @required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: EdgeInsets.only(right: rightPadding, left: leftPadding),
        child: Icon(
          icon,
          size: 30,
          color: Colors.white,
        ),
      ),
      color: color,
    );
  }
}
