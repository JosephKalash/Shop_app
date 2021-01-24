import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/appDrawer.dart';
import 'package:provider/provider.dart';
import '../providers/order.dart' show Order;
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/order-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      ///this widget provide for us the state of the data we request or listen to.
      body: FutureBuilder(
        future: Provider.of<Order>(context,listen: false).fetchAndSetOrder(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting)///like if we make stateful widget with isLoading boolean
            return Center(child: CircularProgressIndicator());
          else if (dataSnapshot.error != null)///like catchError() in future object.
            return Center(
                child: Text(
              'An error occurred while fetching data from server!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ));
          else///like then().
            return Consumer<Order>(
              builder: (ctx, orders, _) {
                return ListView.builder(
                  itemBuilder: (ctx, i) => OrderItem(orders.items[i]),
                  itemCount: orders.items.length,
                );
              },
            );
        },
      ),
    );
  }
}
