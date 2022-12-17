import 'package:flutter/material.dart';

import '../settings/settings_view.dart';

import 'sample_item_add.dart';
import 'sample_item_mod.dart';
import 'sample_item.dart';
import 'category.dart';

/// Displays a list of SampleItems.
class SampleItemListView extends StatefulWidget {
  @override
  _SampleItemListView createState() => _SampleItemListView();
  static const routeName = '/';
}

class _SampleItemListView extends State<SampleItemListView> {
  List<SampleItem> items = [];
  /*
  List<SampleItem> items = [
    SampleItem(
        1,
        "manzanas",
        6,
        15.0,
        Category(1, "Comida", Color.fromARGB(255, 248, 132, 0),
            const Icon(Icons.tag_faces))),
    SampleItem(
        2,
        "bananas",
        2,
        22.0,
        Category(1, "Comida", Color.fromARGB(255, 248, 132, 0),
            const Icon(Icons.tag_faces))),
    SampleItem(
        3,
        "naranjas",
        4,
        30.0,
        Category(1, "Comida", Color.fromARGB(255, 248, 132, 0),
            const Icon(Icons.tag_faces))),
    SampleItem(
        4,
        "pomelos",
        7,
        25.0,
        Category(1, "Comida", Color.fromARGB(255, 248, 132, 0),
            const Icon(Icons.tag_faces)))
  ];
*/

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
              subtitle: Text("${item.cantidad}u. \$${item.precio}"),
              leading: CircleAvatar(
                // Display the Flutter Logo image asset.
                child: item.categoria.icon,
                backgroundColor: item.categoria.color,

                //foregroundImage: AssetImage('assets/images/flutter_logo.png'),
              ),
              onTap: () {
                // Navigate to the details page. If the user leaves and returns to
                // the app after it has been killed while running in the
                // background, the navigation stack is restored.
                /*
                Navigator.restorablePushNamed(
                  context,
                  SampleItemDetailsView.routeName,
                );
*/
                Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SampleItemMod(item)))
                    .then((newItem) {
                  if (newItem != null) {
                    setState(() {
                      int id = items.indexOf(item);
                      items[id] = newItem;
                    });
                  }
                });
              },
              trailing: Text(
                "\$$unit_total",
                style: TextStyle(
                    color: Color.fromARGB(255, 2, 207, 156), fontSize: 24),
              ),
              onLongPress: () {
                setState(() {
                  items.removeWhere((it) => it.id == item.id);
                });
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //enviar a otra ruta->> agregar item
          /*
          Navigator.restorablePushNamed(
            context,
            SampleItemAdd.routeName,
          );
          */
          Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SampleItemAdd()))
              .then((newItem) {
            if (newItem != null) {
              setState(() {
                items.add(newItem);
              });
            }
          });
        },
        tooltip: 'Agregar item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
