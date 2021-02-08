import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context).settings.arguments; //id
    final productLoaded = Provider.of<Products>(context, listen: false).getById(productID);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                productLoaded.title,
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black,),
              ),
              background: Hero(
                tag: productID,
                child: Image.network(
                  productLoaded.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            expandedHeight: 300,
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        const Text(
                          'Price:',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '\$${productLoaded.price}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Description: \n ${productLoaded.description}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 800),
              ],
            ),
          )
        ],
      ),
    );
  }
}
