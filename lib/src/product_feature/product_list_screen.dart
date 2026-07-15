import 'package:carrito/src/data/categorys.dart';
import 'package:carrito/src/history_shop/historyshop_list_screen.dart';
import 'package:carrito/src/model/category.dart';
import 'package:carrito/src/model/market.dart';
import 'package:carrito/src/model/shop.dart';
import 'package:carrito/src/settings/settings_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/cart_provider.dart';
import '../model/product.dart';
import '../settings/settings_view.dart';
import '../styles/styles.dart';
import 'product_form_screen.dart';

class ProductListScreen extends StatefulWidget {
  final SettingsController settings;
  const ProductListScreen({super.key, required this.settings});

  static const routeName = '/';
  @override
  State<ProductListScreen> createState() => _ProductListScreen();
}

class _ProductListScreen extends State<ProductListScreen> {
  bool showGraph = false;
  bool CantSelected = false;
  int GraphSelected = 0;

  double totalPriceCategory(List<Product> products, String categoria) {
    double total = 0, totalCant = 0;

    for (Product item in products) {
      if (item.categoria.nombre == categoria) {
        if (CantSelected) {
          totalCant += item.cantidad;
        } else {
          total += item.cantidad * item.precio;
        }
      }
    }
    return CantSelected ? totalCant : total;
  }

  double totalPriceNeed(List<Product> products, bool necesidad) {
    double total = 0;
    for (Product item in products) {
      if (item.necesidad == necesidad) {
        if (CantSelected) {
          total += item.cantidad;
        } else {
          total += item.cantidad * item.precio;
        }
      }
    }
    return total;
  }

  String formatPrice(double price) {
    return price.formatNumber();
  }

  Widget buildTotalSection(double total) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                    showGraph ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                onPressed: () {
                  setState(() {
                    showGraph = !showGraph;
                  });
                },
              ),
              const Text("Total", style: TextStyle(fontSize: 24)),
            ],
          ),
          Text(
            "\$${total.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 28, color: priceColor),
          ),
        ],
      ),
    );
  }

  Widget buildGraphSection(List<Product> products, int cantU, int cantP) {
    return Column(children: [
      Container(
        width: 300,
        height: 280,
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            Expanded(
                flex: 15,
                child: Stack(children: [
                  Center(
                    child: Text("$cantU u. \n $cantP p.",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  PieChart(
                    PieChartData(
                      sections: [
                        if (GraphSelected == 0)
                          for (Categoryy cat in categorias) ...[
                            PieChartSectionData(
                              value: totalPriceCategory(products, cat.nombre),
                              color: cat.color,
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                      color: Colors.black,
                                      offset: Offset(1, 1)),
                                ],
                              ),
                              title:
                                  "${cat.nombre}\n(${CantSelected ? totalPriceCategory(products, cat.nombre).toString() : "\$${totalPriceCategory(products, cat.nombre).toStringAsFixed(2)}"})",
                            ),
                          ],
                        if (GraphSelected == 1) ...[
                          PieChartSectionData(
                            value: totalPriceNeed(products, true),
                            color: needColor,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                    color: Colors.black, offset: Offset(1, 1)),
                              ],
                            ),
                            title:
                                "Necesito\n(${CantSelected ? totalPriceNeed(products, true).toString() : "\$${totalPriceNeed(products, true).toStringAsFixed(2)}"})",
                          ),
                          PieChartSectionData(
                            value: totalPriceNeed(products, false),
                            color: wantColor,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                    color: Colors.black, offset: Offset(1, 1)),
                              ],
                            ),
                            title:
                                "Quiero\n(${CantSelected ? totalPriceNeed(products, false).toString() : "\$${totalPriceNeed(products, false).toStringAsFixed(2)}"})",
                          ),
                        ]
                      ],
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 150),
                    swapAnimationCurve: Curves.linear,
                  ),
                ])),
            Expanded(
                flex: 1,
                child: Container(
                  child: products.isEmpty
                      ? const SizedBox.shrink()
                      : Column(
                          children: [
                            IconButton(
                              padding: const EdgeInsets.only(bottom: 20),
                              icon: Icon(CantSelected
                                  ? Icons.change_circle_sharp
                                  : Icons.currency_exchange_sharp),
                              onPressed: () {
                                setState(() {
                                  CantSelected = !CantSelected;
                                });
                              },
                            ),
                            IconButton(
                              padding: const EdgeInsets.only(bottom: 20),
                              icon: const Icon(Icons.category),
                              onPressed: () {
                                setState(() {
                                  GraphSelected = 0;
                                });
                              },
                            ),
                            IconButton(
                              padding: const EdgeInsets.only(bottom: 20),
                              icon: const Icon(Icons.back_hand),
                              onPressed: () {
                                setState(() {
                                  GraphSelected = 1;
                                });
                              },
                            ),
                          ],
                        ),
                ))
          ],
        ),
      )
    ]);
  }

  Widget buildListItem(BuildContext context, CartProvider cart, int index) {
    Product item = cart.products[index];
    double unitTotal = item.precio * item.cantidad;

    return ListTile(
      title: Text(item.nombre),
      subtitle: Text("${item.cantidad}u. \$${item.precio.toStringAsFixed(2)}"),
      leading: CircleAvatar(
        backgroundColor: item.categoria.color,
        child: Icon(item.categoria.iconData),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProductFormScreen(
                    item: item, settings: widget.settings))).then((newItem) {
          if (newItem != null) {
            cart.updateProduct(index, newItem);
          }
        });
      },
      trailing: Text(
        "\$${unitTotal.toStringAsFixed(2)}",
        style: TextStyle(color: priceColor, fontSize: 24),
      ),
      onLongPress: () {
        cart.removeProductAt(index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final products = cart.products;
    double total = cart.totalProducts;
    int cant = products.fold(0, (sum, item) => sum + (item.cantidad));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de la compra.'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_outlined),
            onPressed: products.isNotEmpty
                ? () {
                    cart.addToHistory(Shop(
                        1, Market(1, "Dia"), DateTime.now(), products, total));
                  }
                : null,
          ),
          if (cart.historyShop.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const HistoryShopScreen()));
              },
            ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: products.isEmpty
                ? [
                    const SizedBox(height: 100),
                    const Center(
                      child: Text(
                        "No hay productos en la lista.",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ]
                : [
                    buildTotalSection(total),
                    if (showGraph)
                      buildGraphSection(products, cant, products.length),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      restorationId: 'sampleItemListView',
                      itemCount: products.length,
                      itemBuilder: (ctx, i) => buildListItem(ctx, cart, i),
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    ),
                  ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProductFormScreen(
                      settings: widget.settings,
                      lastIndex: cart.nextProductId - 1)));
        },
        tooltip: 'Agregar Producto',
        child: const Icon(Icons.add_shopping_cart_outlined),
      ),
    );
  }
}

extension NumberFormatter on num {
  String formatNumber() {
    final num = toString().split(".")[0];
    if (this < 1000) return num;

    final formatter = RegExp(r'^(\d{1,3}(\.\d{3})*|(\d+))*(\.\d{3})$');
    final formattedNumber = formatter.stringMatch(num);
    return formattedNumber!;
  }
}
