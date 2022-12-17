import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'sample_item.dart';
import 'category.dart';

const double _kItemExtent = 32.0;

class SampleItemAdd extends StatefulWidget {
  @override
  _SampleItemAdd createState() => _SampleItemAdd();
  static const routeName = '/add_sample_item';
}

/// Displays detailed information about a SampleItem.
class _SampleItemAdd extends State<SampleItemAdd> {
  //static const routeName = '/add_sample_item';

  TextEditingController valor_nombre = TextEditingController();
  TextEditingController valor_cantidad = TextEditingController();
  TextEditingController valor_precio = TextEditingController();

  int _selectedCate = 0;
  List<Category> categorias = [
    Category(0, "Comida", Color.fromARGB(255, 248, 132, 0),
        const Icon(Icons.bakery_dining)),
    Category(1, "Electronica", Color.fromARGB(255, 244, 248, 0),
        const Icon(Icons.computer)),
    Category(2, "Limpieza", Color.fromARGB(255, 0, 219, 248),
        const Icon(Icons.cleaning_services)),
    Category(3, "Hogar", Color.fromARGB(255, 58, 248, 0),
        const Icon(Icons.maps_home_work)),
    Category(4, "Personal", Color.fromARGB(255, 207, 0, 248),
        const Icon(Icons.tag_faces)),
    Category(5, "Otros", Color.fromARGB(255, 100, 100, 100),
        const Icon(Icons.category)),
  ];

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
                  child:
                      Text("Categoria: ${categorias[_selectedCate].nombre}")),
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
