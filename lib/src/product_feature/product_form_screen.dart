import 'package:carrito/src/animations_screens/add_cart_anim.dart';
import 'package:carrito/src/model/category.dart';
import 'package:carrito/src/settings/settings_controller.dart';
import 'package:carrito/src/styles/buttons.dart';
import 'package:carrito/src/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/cart_provider.dart';
import '../data/categorys.dart';
import '../model/product.dart';

class ProductFormScreen extends StatefulWidget {
  final int? lastIndex;
  final Product? item;
  final SettingsController settings;
  const ProductFormScreen(
      {super.key, this.item, this.lastIndex, required this.settings});
  @override
  _ProductFormScreen createState() => _ProductFormScreen();
  static const routeName = '/add_sample_item';
}

class _ProductFormScreen extends State<ProductFormScreen> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController cantidadController = TextEditingController(text: "1");
  TextEditingController precioController = TextEditingController();

  late String namePlaceholder;
  int _selectedCate = 0;

  int id_item = 0;
  int id_categoria = 0;
  bool necesidad = false;

  @override
  void initState() {
    super.initState();
    final cart = context.read<CartProvider>();
    namePlaceholder = "Producto ${cart.products.length + 1}";
    if (widget.item == null) return;
    Product item = widget.item!;
    nombreController = TextEditingController(text: item.nombre);
    cantidadController = TextEditingController(text: item.cantidad.toString());
    precioController = TextEditingController(text: item.precio.toString());
    id_item = item.id;
    id_categoria = item.categoria.id;
    necesidad = item.necesidad;
  }

  save() {
    if (precioController.text.isEmpty) {
      return;
    }

    final cart = context.read<CartProvider>();

    setState(() {
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
        String name = nombreController.text == ""
            ? namePlaceholder
            : nombreController.text;

        newProduct = Product(
            id,
            name,
            int.parse(cantidadController.text),
            double.parse(precioController.text),
            categorias[_selectedCate],
            necesidad);
        cart.addProduct(newProduct);
      }
      if (widget.settings.activeAnimations) {
        add_cart_animation(newProduct);
      } else {
        Navigator.pop(context, newProduct);
      }
    });
  }

  add_cart_animation(newProduct) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => addcart_animscreen(
              item: CircleAvatar(
                backgroundColor: categorias[_selectedCate].color,
                child: Icon(categorias[_selectedCate].iconData),
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
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.9),
            child: Form(
              child: Column(children: [
                const SizedBox(height: 32),
                TextFormField(
                  controller: nombreController,
                  decoration: inputDeco(namePlaceholder, ""),
                ),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(
                      flex: 4,
                      child: TextFormField(
                        controller: cantidadController,
                        keyboardType: TextInputType.number,
                        decoration: inputDeco("Cantidad", "1"),
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
                const SizedBox(height: 16),
                TextFormField(
                  autofocus: true,
                  controller: precioController,
                  onChanged: (a) => setState(() {}),
                  onEditingComplete: save,
                  keyboardType: TextInputType.number,
                  decoration: inputDeco("Precio (\$)", "\$1"),
                ),
                const SizedBox(height: 16),
                Text(
                  "Categoria: ${categorias[_selectedCate].nombre}",
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
                                    child: Icon(cat.iconData),
                                  ))))
                  ],
                ),
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
                        },
                        child: const Text("Necesito!")),
                    ElevatedButton(
                        style: btn(color: wantColor, selected: !necesidad),
                        onPressed: () {
                          setState(() {
                            necesidad = false;
                          });
                        },
                        child: const Text("Quiero!")),
                  ],
                ),
              ]),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: save,
        tooltip: 'Agregar item',
        backgroundColor:
            precioController.text.isEmpty ? Colors.grey : Colors.greenAccent,
        child: const Icon(Icons.check),
      ),
    );
  }
}
