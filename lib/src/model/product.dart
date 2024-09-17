/// A placeholder class that represents an entity or model.
import 'category.dart';

class Product {
  Product(this.id, this.nombre, this.cantidad, this.precio, this.categoria,
      this.necesidad);

  final int id;
  final String nombre;
  final int cantidad;
  final double precio;
  final Categoryy categoria;
  final bool necesidad;
}
