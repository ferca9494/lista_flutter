// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:ffi';

import 'package:carrito/src/animations_screens/add_cart_anim.dart';
import 'package:carrito/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:carrito/src/model/category.dart';
import 'package:carrito/src/styles/buttons.dart';
import 'package:carrito/src/styles/styles.dart';
//import 'package:flutter/cupertino.dart';

import '../data/categorys.dart';
import '../model/product.dart';
import '../data/user.dart' as user;

class ProductFormScreen extends StatefulWidget {
  final int? lastIndex;
  final Product? item;
  final SettingsController settings;
  const ProductFormScreen({this.item, this.lastIndex, required this.settings});
  @override
  _ProductFormScreen createState() => _ProductFormScreen();
  static const routeName = '/add_sample_item';
}

/// Displays detailed information about a SampleItem.
class _ProductFormScreen extends State<ProductFormScreen> {
  //static const routeName = '/add_sample_item';

  TextEditingController nombreController = TextEditingController(
      text: "Producto " + (user.products.length + 1).toString());
  TextEditingController cantidadController = TextEditingController(text: "1");
  TextEditingController precioController = TextEditingController();

  int _selectedCate = 0;

  int id_item = 0;
  int id_categoria = 0;
  bool necesidad = false;

  @override
  void initState() {
    super.initState();
    if (widget.item == null) return;
    Product item = widget.item!;
    nombreController = TextEditingController(text: item.nombre);
    cantidadController = TextEditingController(text: item.cantidad.toString());
    precioController = TextEditingController(text: item.precio.toString());
    id_item = item.id;
    id_categoria = item.categoria.id;
    necesidad = item.necesidad;
  }
/*
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
*/

  save() {
    if (precioController.text.isEmpty) {
      return;
    }

    setState(() {
      print("nombre: " + nombreController.text);
      print("precio: " + precioController.text);
      print("cantidad: " + cantidadController.text);
      print("pressed");
      //TODO: adaptar a modificacion de producto

      Product newProduct;

      if (widget.item != null) {
        newProduct = Product(
            id_item,
            nombreController.text,
            int.parse(cantidadController.text),
            double.parse(precioController.text),
            categorias[_selectedCate],
            necesidad);
      } else {
        var id = widget.lastIndex != null ? widget.lastIndex! + 1 : 1;

        newProduct = Product(
            id,
            nombreController.text,
            int.parse(cantidadController.text),
            double.parse(precioController.text),
            categorias[_selectedCate],
            necesidad);
        user.products.add(newProduct);
      }
      if (widget.settings.activeAnimations)
        add_cart_animation(newProduct);
      else
        Navigator.pop(context, newProduct);
    });
  }

  add_cart_animation(newProduct) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => addcart_animscreen(
              item: CircleAvatar(
                backgroundColor: categorias[_selectedCate].color,
                child: categorias[_selectedCate].icon,
              ),
              onFinish: () {
                Navigator.pop(context, newProduct);
              })),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Item'),
        /*
            //?TESTING animations
        actions: [

          IconButton(
            icon: const Icon(Icons.abc),
         
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => addcart_animscreen(
                        item: CircleAvatar(
                          backgroundColor: categorias[_selectedCate].color,
                          child: categorias[_selectedCate].icon,
                        ),
                        onFinish: () {
                          return 1;
                        })),
              );
            },
          
          ),
        ],
          */
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.9),
            child: Form(
              child: Column(children: [
                const SizedBox(height: 32),
                TextFormField(
                  controller: nombreController,
                  //onSaved: (newValue) => {this.valor_nombre = newValue},
                  decoration: const InputDecoration(
                    labelText: "Nombre",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(children: [
                  Expanded(
                      flex: 4,
                      child: TextFormField(
                        controller: cantidadController,
                        //onSaved: (newValue) => {this.valor_cantidad = newValue},
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Cantidad",
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Column(children: [
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_up),
                          onPressed: () {
                            setState(() {
                              cantidadController.text =
                                  (int.parse(cantidadController.text) + 1)
                                      .toString();
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_down),
                          onPressed: int.parse(cantidadController.text) > 1
                              ? () {
                                  setState(() {
                                    cantidadController.text =
                                        (int.parse(cantidadController.text) - 1)
                                            .toString();
                                  });
                                }
                              : null,
                        ),
                      ]))
                ]),
                const SizedBox(height: 32),
                TextFormField(
                  autofocus: true,
                  controller: precioController,
                  /*onSaved: (newValue) => {
                  setState(() {
                    this.valor_precio = newValue;
                    print(valor_precio.toString());
                  })
                },*/
                  onChanged: (a) => setState(() {}),
                  onEditingComplete: save,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Precio (\$)",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white, width: 2.0)),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "Categoria: " + categorias[_selectedCate].nombre,
                ),
                Wrap(
                  children: [
                    for (Categoryy cat in categorias)
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCate = cat.id;
                            });
                          },
                          child: Container(
                              margin: const EdgeInsets.all(15),
                              child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.black,
                                  child: CircleAvatar(
                                    radius: _selectedCate == cat.id ? 28 : 30,
                                    backgroundColor: cat.color,
                                    child: cat.icon,
                                  ))))
                  ],
                ),
                /*
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
                  child:
                      Text("Categoria: ${categorias[_selectedCate].nombre}")),
                      */
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: btn(color: needColor, selected: necesidad),
                        onPressed: () {
                          setState(() {
                            necesidad = true;
                          });
                          print(necesidad);
                        },
                        child: const Text("Necesito!")),
                    ElevatedButton(
                        style: btn(color: wantColor, selected: !necesidad),
                        onPressed: () {
                          setState(() {
                            necesidad = false;
                          });
                          print(necesidad);
                        },
                        child: const Text("Quiero!")),
                  ],
                ),
                /*
                  const SizedBox(height: 32),
                  ElevatedButton(
                      onPressed: save,
                      style: btn(Colors.blue),
                      child: const Text("Agregar")),
                */
              ]),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: save,
        //precioController.text.isEmpty ? save : null,
        tooltip: 'Agregar item',
        child: const Icon(Icons.check),
        backgroundColor:
            precioController.text.isEmpty ? Colors.grey : Colors.greenAccent,
      ),
    );
  }
}
