import 'package:flutter/material.dart';
import '../data/user.dart' as user;
import '../model/market.dart';
import '../model/shop.dart';
import '../styles/styles.dart';

class HistoryShopScreen extends StatefulWidget {
  const HistoryShopScreen({super.key});

  @override
  _HistoryShopScreen createState() => _HistoryShopScreen();
}

class _HistoryShopScreen extends State<HistoryShopScreen> {
  static const routeName = '/history_add';

  final TextEditingController nombremarketController = TextEditingController();

  save() {
    double total = user.products
        .fold(0, (sum, item) => sum + (item.cantidad * item.precio));

    setState(() {
      user.historyShop.add(Shop(1, Market(1, nombremarketController.text),
          DateTime.now(), user.products, total));

      user.products = [];

      print(">>added in history");
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Realizar compra y guardar'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nombremarketController,
                decoration: inputDeco("", ""),
                onEditingComplete: save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
