import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:managestate/providers/cart.dart';
import 'package:managestate/screens/cart_screen.dart';
import 'package:managestate/widgets/app_drawer.dart';
import 'package:managestate/widgets/badge.dart';
import 'package:managestate/widgets/products_grid.dart';
import 'package:managestate/providers/products.dart';

enum FilterOptions {
  Favs,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavs = false;
  var isInit = true;
  var isLoading = false;
  @override
  void initState() {
    // Method 1
    // Provider.of<Products>(context, listen: false).fetchAndSetProducts(); will work only if "listen: false" is set.

    // Method 2 // HECK
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  // METHOD 3
  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Myshop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(
                () {
                  if (selectedValue == FilterOptions.Favs) {
                    _showOnlyFavs = true;
                  } else {
                    _showOnlyFavs = false;
                  }
                },
              );
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only Favs"),
                value: FilterOptions.Favs,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            // child is moved outside so it doesn't rebuild.
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavs),
    );
  }
}
