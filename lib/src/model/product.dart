import 'category.dart';
import '../data/categorys.dart';

class Product {
  Product(this.id, this.nombre, this.cantidad, this.precio, this.categoria,
      this.necesidad);

  final int id;
  final String nombre;
  final int cantidad;
  final double precio;
  final Categoryy categoria;
  final bool necesidad;

  Product copyWith({
    int? id,
    String? nombre,
    int? cantidad,
    double? precio,
    Categoryy? categoria,
    bool? necesidad,
  }) =>
      Product(
        id ?? this.id,
        nombre ?? this.nombre,
        cantidad ?? this.cantidad,
        precio ?? this.precio,
        categoria ?? this.categoria,
        necesidad ?? this.necesidad,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nombre == other.nombre &&
          cantidad == other.cantidad &&
          precio == other.precio &&
          categoria == other.categoria &&
          necesidad == other.necesidad;

  @override
  int get hashCode =>
      Object.hash(id, nombre, cantidad, precio, categoria, necesidad);

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'cantidad': cantidad,
        'precio': precio,
        'categoriaId': categoria.id,
        'necesidad': necesidad,
      };

  factory Product.fromJson(Map<String, dynamic> json) {
    final catId = json['categoriaId'] as int;
    final cat = categorias.firstWhere(
      (c) => c.id == catId,
      orElse: () => categorias.last,
    );
    return Product(
      json['id'] as int,
      json['nombre'] as String,
      json['cantidad'] as int,
      (json['precio'] as num).toDouble(),
      cat,
      json['necesidad'] as bool,
    );
  }
}
