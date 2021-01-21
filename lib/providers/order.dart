import 'package:flutter/foundation.dart';
import 'package:flutter_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double totalPrice;
  final List<CartItem> products;
  final DateTime orderDate;

  OrderItem.name(
    this.id,
    this.totalPrice,
    this.products,
    this.orderDate,
  );
}

class Order with ChangeNotifier {
  List<OrderItem> _items = [];

  List<OrderItem> get items => [..._items];

  void addItem(List<CartItem> products, double price) {
    _items.insert(
      0,
      OrderItem.name(
        DateTime.now().toString(),
        price,
        products,
        DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
