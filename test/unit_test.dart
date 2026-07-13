import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carrito/src/model/category.dart';
import 'package:carrito/src/model/market.dart';
import 'package:carrito/src/model/product.dart';
import 'package:carrito/src/model/shop.dart';

void main() {
  group('Market', () {
    test('equality and hashCode', () {
      final a = Market(1, 'Dia');
      final b = Market(1, 'Dia');
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('inequality', () {
      final a = Market(1, 'Dia');
      final b = Market(2, 'Carrefour');
      expect(a, isNot(equals(b)));
    });

    test('copyWith', () {
      final m = Market(1, 'Dia');
      final m2 = m.copyWith(name: 'Carrefour');
      expect(m2.id, 1);
      expect(m2.name, 'Carrefour');
      expect(m.name, 'Dia');
    });

    test('toJson/fromJson roundtrip', () {
      final m = Market(1, 'Dia');
      final json = m.toJson();
      final m2 = Market.fromJson(json);
      expect(m2, equals(m));
    });
  });

  group('Categoryy', () {
    test('equality', () {
      final a = Categoryy(0, 'Comida', Colors.red, Icons.bakery_dining);
      final b = Categoryy(0, 'Comida', Colors.red, Icons.bakery_dining);
      expect(a, equals(b));
    });

    test('copyWith', () {
      final c = Categoryy(0, 'Comida', Colors.red, Icons.bakery_dining);
      final c2 = c.copyWith(nombre: 'Alimentos');
      expect(c2.nombre, 'Alimentos');
      expect(c2.id, 0);
    });
  });

  group('Product', () {
    Product make([int id = 1]) {
      final cat = Categoryy(0, 'Comida', Colors.orange, Icons.bakery_dining);
      return Product(id, 'Leche', 2, 1.5, cat, true);
    }

    test('equality', () {
      expect(make(), equals(make()));
    });

    test('inequality on id', () {
      expect(make(1), isNot(equals(make(2))));
    });

    test('copyWith', () {
      final p = make();
      final p2 = p.copyWith(nombre: 'Pan', cantidad: 3);
      expect(p2.nombre, 'Pan');
      expect(p2.cantidad, 3);
      expect(p2.id, p.id);
      expect(p2.precio, p.precio);
    });

    test('toJson/fromJson roundtrip', () {
      final p = make();
      final json = p.toJson();
      final p2 = Product.fromJson(json);
      expect(p2.id, p.id);
      expect(p2.nombre, p.nombre);
      expect(p2.cantidad, p.cantidad);
      expect(p2.precio, p.precio);
      expect(p2.necesidad, p.necesidad);
      expect(p2.categoria.id, p.categoria.id);
    });
  });

  group('Shop', () {
    Shop make() {
      final cat = Categoryy(0, 'Comida', Colors.orange, Icons.bakery_dining);
      final product = Product(1, 'Leche', 2, 1.5, cat, true);
      final market = Market(1, 'Dia');
      return Shop(1, market, DateTime(2025, 1, 15), [product], 3.0);
    }

    test('equality', () {
      expect(make(), equals(make()));
    });

    test('copyWith', () {
      final s = make();
      final s2 = s.copyWith(totalPrice: 10.0);
      expect(s2.totalPrice, 10.0);
      expect(s2.id, s.id);
    });

    test('toJson/fromJson roundtrip', () {
      final s = make();
      final json = s.toJson();
      final s2 = Shop.fromJson(json);
      expect(s2.id, s.id);
      expect(s2.market, equals(s.market));
      expect(s2.date, s.date);
      expect(s2.totalPrice, s.totalPrice);
      expect(s2.productList.length, s.productList.length);
      expect(s2.productList.first.nombre, s.productList.first.nombre);
    });
  });
}
