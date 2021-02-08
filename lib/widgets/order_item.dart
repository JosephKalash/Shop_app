import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter_app/models/orderItem.dart' as ordModel;

class OrderItem extends StatefulWidget {
  final ordModel.OrderItem orderItem;

  OrderItem(this.orderItem);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> with SingleTickerProviderStateMixin {
  ///to expand the card and show ordered products.
  bool _expanded = false;
  Animation<Offset> _productAnimation;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _productAnimation = Tween(
      begin: Offset(0, -0.5),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      ///column to show ordered products in same card when expand it.
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              'Total: \$${widget.orderItem.totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              DateFormat('DD/MM/yyyy HH:mm').format(widget.orderItem.orderDate),
            ),
            trailing: IconButton(
              icon: Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.deepOrange,
              ),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                  _expanded ? _controller.forward(): _controller.reverse();

                });
              },
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
            height:_expanded? min(widget.orderItem.products.length * 20.0 + 40, 180.0):0,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: ListView(
              children: widget.orderItem.products
                  /** this function return iterable of elements
                   * each element is returned from call the fun we pass to map. */
                  .map(
                    (product) => SlideTransition(
                      position: _productAnimation,
                      child: Column(
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
                                    style: _productDetailTextStyle(),
                                  ),
                                  Text(
                                    ' | ',
                                    style: _productDetailTextStyle(),
                                  ),
                                  Text(
                                    '\$${product.price}',
                                    style: _productDetailTextStyle(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _productDetailTextStyle() {
    return TextStyle(
      fontSize: 18,
      color: Colors.grey,
    );
  }
}
