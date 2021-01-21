import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl: 'https://ae01.alicdn.com/kf/HTB10SkpSFXXXXcraXXXq6xXFXXXt/Dress-Pants-Men-New-British-Style-Gentleman-Trousers-Casual-Favourite-Suit-Fashion-Business-Formal-Occasions-Pants.jpg',
    ),
    Product(
      id: 'p3',
      title: 'diamonds',
      description: 'buy matching diamonds for six of my bitches',
      price: 290.99,
      imageUrl: 'https://cdn.clipart.email/3e71a70ad3215962ec96855e8274e496_crystal-diamond-clipart_920-789.jpeg',
    ),
    Product(
      id: 'p4',
      title: 'shoes',
      description: 'A nice pair of shoes.',
      price: 50.99,
      imageUrl: 'https://cdn.pixabay.com/photo/2015/08/05/09/55/mens-shoes-875948_960_720.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> getFavoriteOnly() {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product getById(String id) => _items.firstWhere((product) => product.id == id);

  Future<void> addItem(Product product) async {
    const url = 'https://flutter-app-fe68c-default-rtdb.firebaseio.com/products.json';

    try {
      final response = await http.post(url,
          body: json.encode(
            {
              'title': product.title,
              'price': product.price,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'isFavorite': product.isFavorite,
            },
          ));

      _items.add(Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite,
      ));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void removeProduct(productId) {
    _items.removeWhere((element) => element.id == productId);
    notifyListeners();
  }

  void updateProduct(Product newProduct) {
    final index = _items.indexWhere((element) => element.id == newProduct.id);
    if (index >= 0) {
      _items[index] = newProduct;
      notifyListeners();
    }
  }
}
