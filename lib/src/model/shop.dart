/// A placeholder class that represents an entity or model.
import 'package:carrito/src/model/market.dart';
import 'package:carrito/src/model/product.dart';

class Shop {
  Shop(this.id, this.market, this.date, this.productList, this.totalPrice);

  final int id;
  final Market market;
  final DateTime date;
  final List<Product> productList;
  final double totalPrice;
}
