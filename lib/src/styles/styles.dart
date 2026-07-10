import 'package:flutter/material.dart';

Color priceColor = const Color.fromARGB(255, 2, 207, 156);

Color needColor = const Color.fromARGB(255, 185, 44, 44);
Color wantColor = const Color.fromARGB(255, 76, 175, 150);


inputDeco(name, hint) => InputDecoration(
      hintText: hint,
      labelText: name,
      fillColor: Colors.white,
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 162, 162, 162),
        ),
      ),
    );
