import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/cart_provider.dart';
import '../model/market.dart';
import '../model/shop.dart';
import '../styles/styles.dart';

class HistoryShopAddScreen extends StatefulWidget {
  const HistoryShopAddScreen({super.key});

  @override
  _HistoryShopAddScreen createState() => _HistoryShopAddScreen();
}

class _HistoryShopAddScreen extends State<HistoryShopAddScreen> {
  static const routeName = '/history_add';

  final TextEditingController nombremarketController = TextEditingController();

  save() {
    final cart = context.read<CartProvider>();
    double total = cart.totalProducts;

    cart.addToHistory(Shop(1, Market(1, nombremarketController.text),
        DateTime.now(), cart.products, total));

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
