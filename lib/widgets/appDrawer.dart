import 'package:flutter/material.dart';
import 'package:flutter_app/helper/custom_route.dart';
import 'package:flutter_app/providers/auth.dart';
import 'package:flutter_app/screens/order_screen.dart';
import 'package:flutter_app/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Hello Friend'),
            automaticallyImplyLeading: false,
          ),
          _buildListTile(Icons.shop, 'Shop', () {
            Navigator.of(context).pushReplacementNamed('/');
          }),
          const Divider(),
          _buildListTile(Icons.payment, 'My Orders', () {
            /**Navigator.of(context).pushReplacement(
              CustomRoute(builder: (ctx) => OrderScreen()),
            );*/
            Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
          }),
          const Divider(),
          _buildListTile(Icons.apps, 'Manage Products', () {
            Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
          }),
          const Divider(),
          _buildListTile(Icons.logout, 'logout', () {
            Navigator.of(context).pop();

            ///to always go to home dir and show splash or auth screen,
            ///and avoid unexpected behavior.
            Navigator.of(context).pushReplacementNamed('/');

            Provider.of<Auth>(context, listen: false).logout();
          }),
        ],
      ),
    );
  }

  ListTile _buildListTile(IconData icon, String label, Function navigatorFun) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.deepOrange,
      ),
      title: Text(label),
      onTap: navigatorFun,
    );
  }
}
