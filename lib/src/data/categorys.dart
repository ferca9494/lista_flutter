import 'package:flutter/material.dart';
import 'package:carrito/src/model/category.dart';

List<Categoryy> categorias = [
  Categoryy(0, "Comida", Color.fromARGB(255, 248, 132, 0),
      const Icon(Icons.bakery_dining)),
  Categoryy(1, "Electronica", Color.fromARGB(255, 244, 248, 0),
      const Icon(Icons.computer)),
  Categoryy(2, "Limpieza", Color.fromARGB(255, 0, 219, 248),
      const Icon(Icons.cleaning_services)),
  Categoryy(3, "Hogar", Color.fromARGB(255, 58, 248, 0),
      const Icon(Icons.maps_home_work)),
  Categoryy(4, "Personal", Color.fromARGB(255, 207, 0, 248),
      const Icon(Icons.tag_faces)),
  Categoryy(5, "Otros", Color.fromARGB(255, 100, 100, 100),
      const Icon(Icons.category)),
];
