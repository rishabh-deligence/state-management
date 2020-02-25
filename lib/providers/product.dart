import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:managestate/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFav;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFav = false,
  });

  void _setFavValue(bool newValue) {
    isFav = newValue;
    notifyListeners();
  }

  Future<void> toggleFavStatus(String id) async {
    final oldStatus = isFav;
    isFav = !isFav;
    notifyListeners();

    final url = 'https://managestate-7fd82.firebaseio.com/products/$id.json';
    try {
      final response = await http.patch(url,
          body: json.encode({
            'isFav': isFav,
          }));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
        throw HttpException('Could not mark the product as fav.');
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
