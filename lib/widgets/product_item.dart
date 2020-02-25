import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:managestate/providers/cart.dart';
import 'package:managestate/providers/product.dart';
import 'package:managestate/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final product = Provider.of<Product>(context, listen: false);
    // print("----------product rebuilds-");
    // When you use provider of, then the whole build method will rerun whenever that data changes.

    // "Consumer" instead of "Provider.of"
    // you could always have a case where you only want to run a subpart of your widgets tree when some
    // data changes and then you could only wrap the subpart of the widget tree
    // that depends on your product data with that listener.

    // OR you can use both "Provider.of" with listen: false and consumer at specific widget where data changes

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon:
                  Icon(product.isFav ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavStatus(product.id);
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(
                product.id,
                product.price,
                product.title,
              );
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added item to card.'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
