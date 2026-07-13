import 'package:carrito/src/model/market.dart';
import 'package:carrito/src/model/product.dart';

class Shop {
  Shop(this.id, this.market, this.date, this.productList, this.totalPrice);

  final int id;
  final Market market;
  final DateTime date;
  final List<Product> productList;
  final double totalPrice;

  Shop copyWith({
    int? id,
    Market? market,
    DateTime? date,
    List<Product>? productList,
    double? totalPrice,
  }) =>
      Shop(
        id ?? this.id,
        market ?? this.market,
        date ?? this.date,
        productList ?? this.productList,
        totalPrice ?? this.totalPrice,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Shop &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          market == other.market &&
          date == other.date &&
          totalPrice == other.totalPrice;

  @override
  int get hashCode => Object.hash(id, market, date, totalPrice);

  Map<String, dynamic> toJson() => {
        'id': id,
        'market': market.toJson(),
        'date': date.toIso8601String(),
        'productList': productList.map((p) => p.toJson()).toList(),
        'totalPrice': totalPrice,
      };

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        json['id'] as int,
        Market.fromJson(json['market'] as Map<String, dynamic>),
        DateTime.parse(json['date'] as String),
        (json['productList'] as List)
            .map((p) => Product.fromJson(p as Map<String, dynamic>))
            .toList(),
        (json['totalPrice'] as num).toDouble(),
      );
}
