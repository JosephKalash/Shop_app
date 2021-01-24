import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/cartItem.dart';

class Cart with ChangeNotifier {
  //key is product id
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items}; //copy of the map to prevent modify on it

  double get priceTotal {
    double total = 0;

    _items.forEach((_, value) {
      total += value.price * value.quantity;
    });

    return total;
  }

  int get itemCount => _items.length;

  void addCard(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      addOneItemQuantity(productId); //it call notifyListeners() too.
      return;
    } else {
      _items.putIfAbsent(//for a new key
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ),);
      notifyListeners();
    }
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
