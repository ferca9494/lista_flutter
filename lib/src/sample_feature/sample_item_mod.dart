import 'dart:html';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:holamundo/src/sample_feature/sample_item_list_view.dart';
import 'sample_item.dart';
import 'category.dart';

const double _kItemExtent = 32.0;

class SampleItemMod extends StatefulWidget {
  final SampleItem item;
  SampleItemMod(this.item);

  @override
  _SampleItemMod createState() => _SampleItemMod();
  static const routeName = '/add_sample_item';
}

/// Displays detailed information about a SampleItem.
class _SampleItemMod extends State<SampleItemMod> {
  //static const routeName = '/add_sample_item';

  TextEditingController valor_nombre = TextEditingController();
  TextEditingController valor_cantidad = TextEditingController();
  TextEditingController valor_precio = TextEditingController();

  int _selectedCate = 0;
  List<Category> categorias = [
    Category(1, "Comida", Color.fromARGB(255, 248, 132, 0)),
    Category(2, "Limpieza", Color.fromARGB(255, 0, 219, 248)),
    Category(3, "Hogar", Color.fromARGB(255, 58, 248, 0)),
    Category(4, "Higiene", Color.fromARGB(255, 207, 0, 248)),
    Category(5, "Otros", Color.fromARGB(255, 100, 100, 100)),
  ];
  //String? valor_nombre = "";
  //String? valor_cantidad = "";
  //String? valor_precio = "";

  void initState() {
    SampleItem item = widget.item;
    valor_nombre = TextEditingController(text: item.nombre);
    valor_cantidad = TextEditingController(text: item.cantidad.toString());
    valor_precio = TextEditingController(text: item.precio.toString());
    super.initState();
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

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
                controller: valor_nombre,
                //onSaved: (newValue) => {this.valor_nombre = newValue},
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
                controller: valor_cantidad,
                //onSaved: (newValue) => {this.valor_cantidad = newValue},
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
                controller: valor_precio,
                /*onSaved: (newValue) => {
                  setState(() {
                    this.valor_precio = newValue;
                    print(valor_precio.toString());
                  })
                },*/
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Precio",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2.0)),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                  onPressed: () => _showDialog(
                        CupertinoPicker(
                          magnification: 1.22,
                          squeeze: 1.2,
                          useMagnifier: true,
                          itemExtent: _kItemExtent,
                          // This is called when selected item is changed.
                          onSelectedItemChanged: (int selectedItem) {
                            setState(() {
                              _selectedCate = selectedItem;
                            });
                          },
                          children: List<Widget>.generate(categorias.length,
                              (int index) {
                            return Center(
                              child: Text(
                                categorias[index].nombre,
                              ),
                            );
                          }),
                        ),
                      ),
                  child: const Text("Selecciona categoria")),
              const SizedBox(height: 32),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      print("nombre: " + valor_nombre.text);
                      print("precio: " + valor_precio.text);
                      print("cantidad: " + valor_cantidad.text);
                      print("pressed");
                      /*
                      Navigator.restorablePushNamed(
                        context,
                        SampleItemListView.routeName,
                      );
                      */
                      Navigator.pop(
                          context,
                          new SampleItem(
                              10,
                              valor_nombre.text,
                              int.parse(valor_cantidad.text),
                              double.parse(valor_precio.text),
                              categorias[_selectedCate]));
                    });
                  },
                  child: const Text("Agregar"))
            ]),
          )),
    );
  }
}
