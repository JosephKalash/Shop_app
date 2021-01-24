import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/cartItem.dart';
import 'package:flutter_app/models/exceptions.dart';
import 'package:flutter_app/models/orderItem.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Order with ChangeNotifier {
  List<OrderItem> _items = [];
  //in database url of firebase by add new directory|tree name after / it will create it automatically
  final url = 'https://flutter-app-fe68c-default-rtdb.firebaseio.com/orders.json';

  List<OrderItem> get items => [..._items];

  Future<void> fetchAndSetOrder() async {
    final response = await http.get(url);

    if (response.statusCode >= 400) throw HttpException('an error occurred while saving the order in server!');

    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;//after decode it we cast the dynamic value as map
    if (extractedData == null) return;//there is no data

    List<OrderItem> temp = [];
    try {
      extractedData.forEach((id, order) {
        temp.add(OrderItem.name(
          id,
          order['totalPrice'],
          (order['products'] as List<dynamic>) //ordered products are stored as a map inside a list
              .map((ci) =>
              CartItem(
                id: ci['id'],
                title: ci['title'],
                price: ci['price'],
                quantity: ci['quantity'],
              ))
              .toList(),
          DateTime.parse(order['dateTime']),
        ));
      });

      _items = temp.reversed.toList(); //to show the newest first
      notifyListeners();
    }catch(error){
      throw error;
    }
  }

  Future<void> addItem(List<CartItem> products, double price) async {
    final dateNow = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'totalPrice': price,
          'dateTime': dateNow.toIso8601String(),
          'products': products
              .map((e) =>
          {
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
            json.decode(response.body)['name'], //get the id from backend
            price,
            products,
            dateNow,
          ));
      notifyListeners();
    }catch(error){
      throw error;
    }
  }
}
