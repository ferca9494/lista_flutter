import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/product.dart';
import '../model/shop.dart';

const _kProductsKey = 'cart_products';
const _kHistoryKey = 'cart_history';

class CartProvider extends ChangeNotifier {
  List<Product> products = [];
  List<Shop> historyShop = [];

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = prefs.getString(_kProductsKey);
    final historyJson = prefs.getString(_kHistoryKey);

    if (productsJson != null) {
      products = (jsonDecode(productsJson) as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (historyJson != null) {
      historyShop = (jsonDecode(historyJson) as List)
          .map((e) => Shop.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _kProductsKey, jsonEncode(products.map((p) => p.toJson()).toList()));
    await prefs.setString(
        _kHistoryKey, jsonEncode(historyShop.map((s) => s.toJson()).toList()));
  }

  void addProduct(Product product) {
    products.add(product);
    notifyListeners();
    _persist();
  }

  void updateProduct(int index, Product product) {
    products[index] = product;
    notifyListeners();
    _persist();
  }

  void removeProductAt(int index) {
    products.removeAt(index);
    notifyListeners();
    _persist();
  }

  void clearProducts() {
    products = [];
    notifyListeners();
    _persist();
  }

  int get nextProductId =>
      products.isEmpty ? 1 : products.last.id + 1;

  double get totalProducts =>
      products.fold(0, (sum, item) => sum + (item.cantidad * item.precio));

  void addToHistory(Shop shop) {
    historyShop.add(shop);
    products = [];
    notifyListeners();
    _persist();
  }

  void removeHistoryAt(int index) {
    historyShop.removeAt(index);
    notifyListeners();
    _persist();
  }

  void clearHistory() {
    historyShop = [];
    notifyListeners();
    _persist();
  }
}
