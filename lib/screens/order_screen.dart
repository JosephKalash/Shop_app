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
      body: FutureBuilder(
        future: Provider.of<Order>(context).fetchAndSetOrder(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else if (dataSnapshot.error != null)
            return Center(
                child: Text(
              'an error occur while fetching data from server!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ));
          else
            return Consumer(
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
