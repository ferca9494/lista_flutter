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

  String _formatDate(DateTime date) {
    const months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
    ];
    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day $month $year · $hour:$minute';
  }

  Widget buildListItem(BuildContext context, CartProvider cart, int index) {
    Shop item = cart.historyShop[index];
    return ListTile(
      title: Text(item.market.name),
      subtitle: Text(_formatDate(item.date)),
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
