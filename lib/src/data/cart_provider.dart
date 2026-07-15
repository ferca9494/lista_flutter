import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/product.dart';
import '../model/shop.dart';

const _kProductsKey = 'cart_products';
const _kHistoryKey = 'cart_history';
const _kBudgetKey = 'cart_budget';
const _kProductBudgetKey = 'cart_product_budget';

class CartProvider extends ChangeNotifier {
  List<Product> products = [];
  List<Shop> historyShop = [];
  double? _budget;
  double? _productBudget;

  double? get budget => _budget;
  double? get productBudget => _productBudget;

  double get budgetPercentage =>
      _budget != null && _budget! > 0 ? totalProducts / _budget! : 0;

  bool get isNearBudget =>
      _budget != null && budgetPercentage >= 0.8 && !isOverBudget;

  bool get isOverBudget => _budget != null && totalProducts > _budget!;

  int get productsOverBudgetCount {
    if (_productBudget == null || products.isEmpty) return 0;
    return products
        .where((p) => (p.cantidad * p.precio) > _productBudget!)
        .length;
  }

  double get productsOverBudgetPercentage =>
      products.isEmpty ? 0 : productsOverBudgetCount / products.length;

  double productBudgetPercentage(Product product) =>
      _productBudget != null && _productBudget! > 0
          ? (product.cantidad * product.precio) / _productBudget!
          : 0;

  bool isProductNearBudget(Product product) {
    final pct = productBudgetPercentage(product);
    return _productBudget != null && pct >= 0.8 && !isProductOverBudget(product);
  }

  bool isProductOverBudget(Product product) =>
      _productBudget != null && (product.cantidad * product.precio) > _productBudget!;

  void setBudget(double amount) {
    _budget = amount;
    notifyListeners();
    _persist();
  }

  void clearBudget() {
    _budget = null;
    notifyListeners();
    _persist();
  }

  void setProductBudget(double amount) {
    _productBudget = amount;
    notifyListeners();
    _persist();
  }

  void clearProductBudget() {
    _productBudget = null;
    notifyListeners();
    _persist();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = prefs.getString(_kProductsKey);
    final historyJson = prefs.getString(_kHistoryKey);
    final budgetValue = prefs.getDouble(_kBudgetKey);
    final productBudgetValue = prefs.getDouble(_kProductBudgetKey);

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
    _budget = budgetValue;
    _productBudget = productBudgetValue;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _kProductsKey, jsonEncode(products.map((p) => p.toJson()).toList()));
    await prefs.setString(
        _kHistoryKey, jsonEncode(historyShop.map((s) => s.toJson()).toList()));
    if (_budget != null) {
      await prefs.setDouble(_kBudgetKey, _budget!);
    } else {
      await prefs.remove(_kBudgetKey);
    }
    if (_productBudget != null) {
      await prefs.setDouble(_kProductBudgetKey, _productBudget!);
    } else {
      await prefs.remove(_kProductBudgetKey);
    }
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
    _budget = null;
    _productBudget = null;
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
