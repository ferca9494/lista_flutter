import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/cart_provider.dart';
import '../model/shop.dart';
import '../styles/styles.dart';

class HistoryShopScreen extends StatefulWidget {
  const HistoryShopScreen({super.key});

  @override
  _HistoryShopScreen createState() => _HistoryShopScreen();
}

class _HistoryShopScreen extends State<HistoryShopScreen> {
  static const routeName = '/history';

  Widget buildListItem(BuildContext context, CartProvider cart, int index) {
    Shop item = cart.historyShop[index];
    return ListTile(
      title: Text(item.market.name),
      subtitle: Text("${item.date}"),
      leading: const CircleAvatar(
        child: Icon(Icons.shopping_bag_outlined),
      ),
      onTap: () {},
      trailing: Text(
        "\$${item.totalPrice.toStringAsFixed(2)}",
        style: TextStyle(color: priceColor, fontSize: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Compras.'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.separated(
                  shrinkWrap: true,
                  restorationId: 'sampleItemListView',
                  itemCount: cart.historyShop.length,
                  itemBuilder: (ctx, i) => buildListItem(ctx, cart, i),
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
