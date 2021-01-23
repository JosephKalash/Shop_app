import 'package:flutter/material.dart';
import 'package:flutter_app/screens/cart_screen.dart';
import '../widgets/productsGrid.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/appDrawer.dart';
import '../providers/product.dart';

enum FilterFavorite {
  favoriteOnly,
  showAll,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool favoriteOnly = false; //will be send to ProductsGrid widget
  var _isLoading = true;
  var _hasError = false;
  var _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Products>(context).fetchAndSetProducts().catchError((error) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          /*in cart class we have toggleFavorite method
          to chang favorite attribute and call notifyChange
          */
          PopupMenuButton(
            onSelected: (FilterFavorite filter) {
              setState(() {
                if (filter == FilterFavorite.favoriteOnly)
                  favoriteOnly = true;
                else
                  favoriteOnly = false;
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text('Favorite only'),
                value: FilterFavorite.favoriteOnly,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: FilterFavorite.showAll,
              ),
            ],
          ),
          Consumer<Cart>(
            //to keep counting for badge widget
            builder: (_, cart, chNotRebuild) => Badge(
              value: cart.itemCount.toString(),
              child: chNotRebuild,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: _hasError
          ? Center(
            child: Text(
                'an error occur while fetching data from server!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
          )
          : _isLoading
              ? Center(child: CircularProgressIndicator())
              : ProductsGrid(favoriteOnly),
    );
  }
}
