import 'package:flutter/material.dart';
import '../data/user.dart' as user;
import '../model/shop.dart';
import '../styles/styles.dart';

class HistoryShopScreen extends StatefulWidget {
  const HistoryShopScreen({super.key});

  @override
  _HistoryShopScreen createState() => _HistoryShopScreen();
}

class _HistoryShopScreen extends State<HistoryShopScreen> {
  static const routeName = '/history';

  Widget buildListItem(BuildContext context, int index) {
    Shop item = user.historyShop[index];
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
                  itemCount: user.historyShop.length,
                  itemBuilder: buildListItem,
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
