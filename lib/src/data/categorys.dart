import 'package:flutter/material.dart';
import 'package:carrito/src/model/category.dart';

final List<Categoryy> categorias = [
  Categoryy(0, "Comida", const Color.fromARGB(255, 248, 132, 0),
      Icons.bakery_dining),
  Categoryy(1, "Electronica", const Color.fromARGB(255, 244, 248, 0),
      Icons.computer),
  Categoryy(2, "Limpieza", const Color.fromARGB(255, 0, 219, 248),
      Icons.cleaning_services),
  Categoryy(3, "Hogar", const Color.fromARGB(255, 58, 248, 0),
      Icons.maps_home_work),
  Categoryy(4, "Personal", const Color.fromARGB(255, 207, 0, 248),
      Icons.tag_faces),
  Categoryy(5, "Otros", const Color.fromARGB(255, 100, 100, 100),
      Icons.category),
];
