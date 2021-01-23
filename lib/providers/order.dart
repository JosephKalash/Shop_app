import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/excptions.dart';
import 'package:flutter_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  final url = 'https://flutter-app-fe68c-default-rtdb.firebaseio.com/orders.json';

  List<OrderItem> get items => [..._items];

  Future<void> fetchAndSetOrder() async {
    final response = await http.get(url);
    if (response.statusCode >= 400) throw HttpException('error while saving the order in server');

    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
    if (extractedData == null) return;

    List<OrderItem> temp = [];
    extractedData.forEach((id, order) {
      temp.add(OrderItem.name(
        id,
        order['totalPrice'],
        (order['products'] as List<dynamic>)
            .map((ci) => CartItem(
                  id: ci['id'],
                  title: ci['title'],
                  price: ci['price'],
                  quantity: ci['quantity'],
                ))
            .toList(),
        DateTime.parse(order['dateTime']),
      ));
    });
    _items = temp.reversed.toList();
    notifyListeners();
  }

  Future<void> addItem(List<CartItem> products, double price) async {
    final dateNow = DateTime.now();

    final response = await http.post(
      url,
      body: json.encode({
        'totalPrice': price,
        'dateTime': dateNow.toIso8601String(),
        'products': products
            .map((e) => {
                  'id': e.id,
                  'price': e.price,
                  'quantity': e.quantity,
                  'title': e.title,
                })
            .toList(),
      }),
    );

    if (response.statusCode >= 400) throw HttpException('error while saving the order in server');

    _items.insert(
        0,
        OrderItem.name(
          json.decode(response.body)['name'],
          price,
          products,
          dateNow,
        ));
    notifyListeners();
  }
}
