import 'package:flutter/cupertino.dart';

/// A placeholder class that represents an entity or model.
class Category {
  Category(this.id, this.nombre, this.color, this.icon);

  final int id;
  final String nombre;
  final Color color;
  final Widget icon;
}
