import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });

}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  double get priceTotal {
    double total = 0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  int get itemCount {
    return _items.length;
  }

  void addCard(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existedCard) => CartItem(
                id: existedCard.id,
                title: existedCard.title,
                price: existedCard.price,
                quantity: existedCard.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  void removeOneItemQuantity(String id) {
    if (!_items.containsKey(id)) return;

    if (_items[id].quantity > 1)
      _items.update(
          id,
          (existedCard) => CartItem(
                id: existedCard.id,
                title: existedCard.title,
                price: existedCard.price,
                quantity: existedCard.quantity - 1,
              ));
    else
      _items.remove(id);

    notifyListeners();
  }

  void addOneItemQuantity(String id) {
    if (!_items.containsKey(id)) return;

    _items.update(
        id,
        (existedCard) => CartItem(
              id: existedCard.id,
              title: existedCard.title,
              price: existedCard.price,
              quantity: existedCard.quantity + 1,
            ));

    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
