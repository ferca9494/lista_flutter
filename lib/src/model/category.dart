import 'dart:ui';
import 'package:flutter/widgets.dart';

class Categoryy {
  Categoryy(this.id, this.nombre, this.color, this.iconData);

  final int id;
  final String nombre;
  final Color color;
  final IconData iconData;

  Categoryy copyWith({
    int? id,
    String? nombre,
    Color? color,
    IconData? iconData,
  }) =>
      Categoryy(
        id ?? this.id,
        nombre ?? this.nombre,
        color ?? this.color,
        iconData ?? this.iconData,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Categoryy &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nombre == other.nombre &&
          color == other.color &&
          iconData == other.iconData;

  @override
  int get hashCode => Object.hash(id, nombre, color, iconData);
}
