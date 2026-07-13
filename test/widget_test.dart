import 'package:carrito/src/app.dart';
import 'package:carrito/src/data/cart_provider.dart';
import 'package:carrito/src/settings/settings_controller.dart';
import 'package:carrito/src/settings/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  Widget buildApp() {
    final settingsController = SettingsController(SettingsService());
    final cart = CartProvider();
    return ChangeNotifierProvider<CartProvider>.value(
      value: cart,
      child: MyApp(settingsController: settingsController),
    );
  }

  testWidgets('App renders product list screen', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Lista de la compra.'), findsOneWidget);
  });

  testWidgets('Empty cart shows no list items', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('FAB navigates to product form', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add_shopping_cart_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Agregar Item'), findsOneWidget);
  });

  testWidgets('Settings icon navigates to settings', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Activar/Desactivar animaciones'), findsOneWidget);
  });
}
