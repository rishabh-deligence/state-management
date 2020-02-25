import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:managestate/screens/edit_product_screen.dart';
import 'package:managestate/screens/user_products_screen.dart';
import 'package:managestate/screens/orders_screen.dart';
import 'package:managestate/providers/orders.dart';
import 'package:managestate/providers/cart.dart';
import 'package:managestate/screens/cart_screen.dart';
import 'package:managestate/screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          // create: (ctx) => Products(),
          // create: (_) => Products(), // If data does not depend on the context.
          // OR
          value: Products(), // If you don't want the context.
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'State Management',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
