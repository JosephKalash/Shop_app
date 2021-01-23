import 'package:flutter/material.dart';
import 'dart:math';
import '../providers/order.dart' as ordModel;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ordModel.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: <Widget>[
        ListTile(
          title: Text(
            'Total: \$${widget.order.totalPrice.toStringAsFixed(2)}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            DateFormat('DD/MM/yyyy HH:mm').format(widget.order.orderDate),
          ),
          trailing: IconButton(
            icon: Icon(
              _expanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.deepOrange,
            ),
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
        ),
        if (_expanded)
          Container(
            height: min(widget.order.products.length * 20.0 + 30, 180.0),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: ListView(
                children: widget.order.products
                    .map((product) => Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  product.title,
                                  style: TextStyle(fontSize: 18),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${product.quantity}x',
                                      style: productDetailTextStyle(),
                                    ),
                                    Text(
                                      ' | ',
                                      style: productDetailTextStyle(),
                                    ),
                                    Text(
                                      '\$${product.price}',
                                      style: productDetailTextStyle(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(),
                          ],
                        ))
                    .toList()),
          )
      ]),
    );
  }

  TextStyle productDetailTextStyle() {
    return TextStyle(
      fontSize: 18,
      color: Colors.grey,
    );
  }
}
