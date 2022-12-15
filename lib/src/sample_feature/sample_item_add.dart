import 'dart:html';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:holamundo/src/sample_feature/sample_item_list_view.dart';
import 'sample_item.dart';

/// Displays detailed information about a SampleItem.
class SampleItemAdd extends StatelessWidget {
  SampleItemAdd({super.key});

  static const routeName = '/add_sample_item';
  String? valor_nombre = "";
  String? valor_cantidad = "";
  String? valor_precio = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Item'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.9),
          child: Form(
            child: Column(children: [
              const SizedBox(height: 32),
              TextFormField(
                onSaved: (newValue) => {this.valor_nombre = newValue},
                decoration: InputDecoration(
                  labelText: "Nombre",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                onSaved: (newValue) => {this.valor_cantidad = newValue},
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Cantidad",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                onSaved: (newValue) => {this.valor_precio = newValue},
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Precio",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2.0)),
                ),
              ),
              CupertinoButton(
                  onPressed: () {
                    print(this.valor_nombre);
                    print(this.valor_precio);
                    print(this.valor_cantidad);
                    print("pressed");
                    Navigator.restorablePushNamed(
                      context,
                      SampleItemListView.routeName,
                    );
                  },
                  child: const Text("Agregar"))
            ]),
          )),
    );
  }
}
