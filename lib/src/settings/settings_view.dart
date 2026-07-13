import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'settings_controller.dart';
import '../data/cart_provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButton<ThemeMode>(
              value: controller.themeMode,
              onChanged: controller.updateThemeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Theme'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Checkbox(
                  value: controller.activeAnimations,
                  onChanged: (value) {
                    controller
                        .updateAnimations(value ?? controller.activeAnimations);
                  }),
              const Text("Activar/Desactivar animaciones")
            ]),
          ),
          const SizedBox(height: 32),
          TextButton(
              onPressed: () {
                context.read<CartProvider>().clearProducts();
              },
              child: const Text("Borrar lista de compra actual")),
          TextButton(
              onPressed: () {
                context.read<CartProvider>().clearHistory();
              },
              child: const Text("Borrar datos del historial de compras")),
          const SizedBox(height: 32),
          const Text("Creador: Fernando Cañete (ferca949@gmail.com)")
        ]));
  }
}
