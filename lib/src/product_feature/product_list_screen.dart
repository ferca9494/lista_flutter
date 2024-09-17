import 'package:carrito/src/settings/settings_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:carrito/src/data/categorys.dart';
import 'package:carrito/src/model/category.dart';
import 'package:carrito/src/styles/buttons.dart';

import '../model/product.dart';
import '../settings/settings_view.dart';
import '../styles/styles.dart';
import 'product_form_screen.dart';
import '../data/user.dart' as user;

// ignore: use_key_in_widget_constructors
class ProductListScreen extends StatefulWidget {
  final SettingsController settings;
  const ProductListScreen({required this.settings});

  static const routeName = '/';
  @override
  // ignore: library_private_types_in_public_api
  _ProductListScreen createState() => _ProductListScreen();
}

class _ProductListScreen extends State<ProductListScreen> {
  bool showGraph = false;
  int GraphSelected = 0;

  double totalCat(String categoria) {
    double total = 0;
    for (Product item in user.products) {
      if (item.categoria.nombre == categoria) {
        total += item.cantidad * item.precio;
      }
    }
    return total;
  }

  double totalNed(bool necesidad) {
    double total = 0;
    for (Product item in user.products) {
      if (item.necesidad == necesidad) {
        total += item.cantidad * item.precio;
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
            "\$${total.toString()}",
            style: TextStyle(fontSize: 28, color: priceColor),
          ),
        ],
      ),
    );
  }

  Widget buildGraphSection() {
    return Container(
      width: 300,
      height: 150,
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: PieChart(
              PieChartData(
                sections: [
                  if (GraphSelected == 0)
                    for (Categoryy cat in categorias) ...[
                      PieChartSectionData(
                        value: totalCat(cat.nombre),
                        color: cat.color,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(color: Colors.black, offset: Offset(1, 1)),
                          ],
                        ),
                        title:
                            "${cat.nombre}\n(\$${totalCat(cat.nombre).toString()})",
                      ),
                    ],
                  if (GraphSelected == 1) ...[
                    PieChartSectionData(
                      value: totalNed(true),
                      color: needColor,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(color: Colors.black, offset: Offset(1, 1)),
                        ],
                      ),
                      title: "Necesito\n(\$${totalNed(true).toString()})",
                    ),
                    PieChartSectionData(
                      value: totalNed(false),
                      color: wantColor,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(color: Colors.black, offset: Offset(1, 1)),
                        ],
                      ),
                      title: "Quiero\n(\$${totalNed(false).toString()})",
                    ),
                  ]
                ],
              ),
              swapAnimationDuration: const Duration(milliseconds: 150),
              swapAnimationCurve: Curves.linear,
            ),
          ),
          SizedBox(
            width: 50,
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                IconButton(
                  icon: Icon(Icons.category),
                  onPressed: () {
                    setState(() {
                      GraphSelected = 0;
                    });
                    print("category graph selected");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.back_hand),
                  onPressed: () {
                    setState(() {
                      GraphSelected = 1;
                    });
                    print("needed graph selected");
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildListItem(BuildContext context, int index) {
    Product item = user.products[index];
    double unitTotal = item.precio * item.cantidad;

    return ListTile(
      title: Text(item.nombre),
      subtitle: Text("${item.cantidad}u. \$${item.precio}"),
      leading: CircleAvatar(
        backgroundColor: item.categoria.color,
        child: item.categoria.icon,
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProductFormScreen(
                    item: item, settings: widget.settings))).then((newItem) {
          if (newItem != null) {
            setState(() {
              int id = user.products.indexOf(item);
              user.products[id] = newItem;
            });
          }
        });
      },
      trailing: Text(
        "\$$unitTotal",
        style: TextStyle(color: priceColor, fontSize: 24),
      ),
      onLongPress: () {
        setState(() {
          //user.products.removeWhere((it) => it.id == item.id);
          user.products.removeAt(index);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double total = user.products
        .fold(0, (sum, item) => sum + (item.cantidad * item.precio));
    // String totalStr = total.toString(); // formatPrice(total);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de la compra.'),
        actions: [
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
            children: [
              buildTotalSection(total),
              if (showGraph) buildGraphSection(),
              SizedBox(
                height: showGraph
                    ? MediaQuery.of(context).size.height - 200
                    : MediaQuery.of(context).size.height,
                child: ListView.separated(
                  shrinkWrap: true,
                  restorationId: 'sampleItemListView',
                  itemCount: user.products.length,
                  itemBuilder: buildListItem,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ),
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
                      lastIndex: user.products.last.id))).then((newItem) {
            if (newItem != null) {
              setState(() {});
            }
          });
        },
        tooltip: 'Agregar item',
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
