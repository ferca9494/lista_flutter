import 'package:flutter/material.dart';
import 'package:holamundo/src/sample_feature/sample_item_add.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';
import 'sample_item_add.dart';

/// Displays a list of SampleItems.
class SampleItemListView extends StatelessWidget {
  SampleItemListView({
    super.key,
    this.items = const [
      SampleItem(1, "manzanas", 6, 15.0),
      SampleItem(2, "bananas", 2, 22.0),
      SampleItem(3, "naranjas", 4, 30.0),
      SampleItem(4, "pomelos", 7, 25.0)
    ],
  });

  static const routeName = '/';

  List<SampleItem> items;

  @override
  Widget build(BuildContext context) {
    double total = 0;
    String total_str = "";
    for (int i = 0; i < items.length; i++) {
      total += items[i].cantidad * items[i].precio;
    }
    total_str = total.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de la compra. Total: \$$total_str'),
        actions: [
          IconButton(
            icon: const Icon(Icons.nature),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'sampleItemListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          SampleItem item = items[index];
          double unit_total = item.precio * item.cantidad;

          return ListTile(
              title: Text(item.nombre),
              subtitle:
                  Text("${item.cantidad}u. \$${item.precio} : \$$unit_total"),
              leading: const CircleAvatar(
                // Display the Flutter Logo image asset.
                foregroundImage: AssetImage('assets/images/flutter_logo.png'),
              ),
              onTap: () {
                // Navigate to the details page. If the user leaves and returns to
                // the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(
                  context,
                  SampleItemDetailsView.routeName,
                );
              },
              onLongPress: () {
                print(items);
                print(item);
                //items.removeWhere((it) {
                //  return it.id == item.id;
                //});
                //items.removeAt(0);
                items.add(SampleItem(10, "tornillos", 1, 2.0));
                print(items);
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //enviar a otra ruta->> agregar item
          Navigator.restorablePushNamed(
            context,
            SampleItemAdd.routeName,
          );
        },
        tooltip: 'Agregar item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
