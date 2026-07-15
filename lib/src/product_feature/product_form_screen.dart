import 'dart:convert';

import 'package:carrito/src/animations_screens/add_cart_anim.dart';
import 'package:carrito/src/model/category.dart';
import 'package:carrito/src/settings/settings_controller.dart';
import 'package:carrito/src/styles/buttons.dart';
import 'package:carrito/src/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool showCategorias = false;

  List<Map<String, dynamic>> _productsCatalog = [];

  @override
  void initState() {
    super.initState();
    final cart = context.read<CartProvider>();
    namePlaceholder = "Producto ${cart.products.length + 1}";
    _loadProducts();
    if (widget.item == null) return;
    Product item = widget.item!;
    nombreController = TextEditingController(text: item.nombre);
    cantidadController = TextEditingController(text: item.cantidad.toString());
    precioController = TextEditingController(text: item.precio.toString());
    id_item = item.id;
    id_categoria = item.categoria.id;
    _selectedCate = item.categoria.id;
    necesidad = item.necesidad;
  }

  Future<void> _loadProducts() async {
    final data = await rootBundle.loadString('lib/src/data/products.json');
    final json = jsonDecode(data) as Map<String, dynamic>;
    setState(() {
      _productsCatalog = List<Map<String, dynamic>>.from(json['products']);
    });
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
                /** INPUT DE NOMBRE Y CATEGORIA */
                const SizedBox(height: 32),
                SizedBox(
                  height: 56,
                  child: Row(children: [
                    Expanded(
                      flex: 4,
                      child: Autocomplete<Map<String, dynamic>>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable.empty();
                          }
                          return _productsCatalog.where((p) => (p['name']
                                  as String)
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()));
                        },
                        onSelected: (Map<String, dynamic> product) {
                          nombreController.text = product['name'];
                          setState(() {
                            _selectedCate = product['categoriaId'] as int;
                          });
                        },
                        displayStringForOption: (p) => p['name'] as String,
                        fieldViewBuilder:
                            (context, controller, focusNode, onSubmitted) {
                          controller.text = nombreController.text;
                          controller.selection = nombreController.selection;
                          controller.addListener(() {
                            nombreController.text = controller.text;
                            nombreController.selection = controller.selection;
                          });
                          return TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            onEditingComplete: onSubmitted,
                            decoration: inputDeco(namePlaceholder, ""),
                          );
                        },
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                showCategorias = !showCategorias;
                              });
                            },
                            child: Container(
                                margin: const EdgeInsets.all(6),
                                child: CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Colors.black,
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor:
                                          categorias[_selectedCate].color,
                                      child: Icon(
                                          categorias[_selectedCate].iconData,
                                          size: 20),
                                    ))))),
                  ]),
                ),
                showCategorias
                    ? Column(
                        children: [
                          Text(
                            "Categoria: ${categorias[_selectedCate].nombre}",
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            children: [
                              for (Categoryy cat in categorias)
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedCate = cat.id;
                                        showCategorias = false;
                                      });
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.all(6),
                                        child: Tooltip(
                                          message: cat.nombre,
                                          child: CircleAvatar(
                                              radius: 22,
                                              backgroundColor:
                                                  _selectedCate == cat.id
                                                      ? Colors.black
                                                      : Colors.transparent,
                                              child: CircleAvatar(
                                                radius: _selectedCate == cat.id
                                                    ? 20
                                                    : 22,
                                                backgroundColor: cat.color,
                                                child: Icon(cat.iconData,
                                                    size: 20),
                                              )),
                                        )))
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      )
                    : const SizedBox(height: 0),
                const SizedBox(height: 16),
                /** INPUT DE CANTIDAD */
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
                /** INPUT DE PRECIO */
                TextFormField(
                  autofocus: true,
                  controller: precioController,
                  onChanged: (a) => setState(() {}),
                  onEditingComplete: save,
                  keyboardType: TextInputType.number,
                  decoration: inputDeco("Precio (\$)", "\$1"),
                ),
                const SizedBox(height: 16),
                /** INPUT DE NECESIDAD */
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
