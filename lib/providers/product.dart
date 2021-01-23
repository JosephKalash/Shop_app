import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/excptions.dart';
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

  Future<void> toggleFavorite() async{
    final url = 'https://flutter-app-fe68c-default-rtdb.firebaseio.com/products/$id.json';

    isFavorite = !isFavorite;
    notifyListeners();

    final response = await http.patch(url,body: json.encode({
      'isFavorite' : isFavorite,
    }));

    if(response.statusCode >= 400){
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException('error occur while save an editing product in server!');
    }
  }
}

class Products with ChangeNotifier {
   List<Product> _items = [];
  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl: 'https://ae01.alicdn.com/kf/HTB10SkpSFXXXXcraXXXq6xXFXXXt/Dress-Pants-Men-New-British-Style-Gentleman-Trousers-Casual-Favourite-Suit-Fashion-Business-Formal-Occasions-Pants.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'diamonds',
  //     description: 'buy matching diamonds for six of my bitches',
  //     price: 290.99,
  //     imageUrl: 'https://cdn.clipart.email/3e71a70ad3215962ec96855e8274e496_crystal-diamond-clipart_920-789.jpeg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'shoes',
  //     description: 'A nice pair of shoes.',
  //     price: 50.99,
  //     imageUrl: 'https://cdn.pixabay.com/photo/2015/08/05/09/55/mens-shoes-875948_960_720.jpg',
  //   ),

  final url = 'https://flutter-app-fe68c-default-rtdb.firebaseio.com/products.json';


  List<Product> get items {
    return [..._items];
  }

  List<Product> getFavoriteOnly() {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product getById(String id) => _items.firstWhere((product) => product.id == id);

  Future<void> fetchAndSetProducts() async {
    try {
      final response = await http.get(url);
      if(response.statusCode >= 400)        throw 'error while fetching data';

        final extractedData = json.decode(response.body) as Map<String, dynamic>;
         if(extractedData == null) return;

        final List<Product> loadedProducts = [];
        extractedData.forEach((prodId, prodData) {
          loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite: prodData['isFavorite'],
            imageUrl: prodData['imageUrl'],
          ));
        });
        _items = loadedProducts;
        notifyListeners();
    } catch (error) {
      throw error;
    }
  }


  Future<void> addItem(Product product) async {
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

  Future<void> removeProduct(productId) async{
    final url = 'https://flutter-app-fe68c-default-rtdb.firebaseio.com/products/$productId.json';

    final index = _items.indexWhere((element) => element.id == productId);
    var productPointer = _items[index];
    _items.removeAt(index);
    notifyListeners();

    final response = await http.delete(url);
    if(response.statusCode >= 400) {
      _items.insert(index, productPointer);
      notifyListeners();
      throw HttpException('error while deleting product');
    }else{
      productPointer = null;
    }
  }

  Future<void> updateProduct(Product newProduct) async {
    final url = 'https://flutter-app-fe68c-default-rtdb.firebaseio.com/prodcts/${newProduct.id}.json';

    final index = _items.indexWhere((element) => element.id == newProduct.id);

    if (index >= 0) {
      var productPointer = _items[index];

      _items[index] = newProduct;
      notifyListeners();

      final response = await http.patch(url,body: json.encode({
        'title': newProduct.title,
        'description' : newProduct.description,
        'price' : newProduct.price,
        'imageUrl' : newProduct.imageUrl,
      }));
      if(response.statusCode >= 400){
        _items.removeAt(index);
        _items.insert(index, productPointer);
        notifyListeners();
        throw HttpException('error occur while save an editing product in server!');
      }
      else{
        productPointer = null;
      }
    }
  }
}
