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
  bool favoriteOnly = false;

  ///will be send to ProductsGrid widget.
  var _isLoading = true;
  var _hasError = false;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    /** make listener on Products object in ProductsGrid widget not here.*/
    if (_isInit) {
      Provider.of<Products>(context, listen: false).fetchAndSetProducts().catchError(
        (error) {
          setState(() {
            _isLoading = false;
            _hasError = true;
          });
        },
      ).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshProductsData() async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts().catchError((_) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
            content: Text(
          'refresh field',
          style: TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          /**in product class we have toggleFavorite()
           * to change favorite attribute and call notifyListeners().
           **/
          PopupMenuButton(
            onSelected: (FilterFavorite filter) {
              setState(() {
                if (filter == FilterFavorite.favoriteOnly)
                  favoriteOnly = true;
                else
                  favoriteOnly = false;
              });
            },
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('Favorite only'),
                value: FilterFavorite.favoriteOnly,
              ),
              const PopupMenuItem(
                child: Text('Show all'),
                value: FilterFavorite.showAll,
              ),
            ],
          ),
          /**
           * this consumer for badge widget which counts the number of products a user put in his cart*/
          Consumer<Cart>(
            builder: (_, cart, chNotRebuild) => Badge(
              value: cart.itemCount.toString(),
              child: chNotRebuild,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProductsData(),
        child: _hasError
            ? Center(
                child: const Text(
                'an error occur while fetching data from server!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ))
            : _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ProductsGrid(favoriteOnly),
      ),
    );
  }
}
