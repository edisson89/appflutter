// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

//import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:network_x/main.dart';

// grupo de pruebas de la aplicacion principal
void main() {
  testWidgets('Verificamos la aplicacion principal',
      (WidgetTester tester) async {
    // renderiza la app,
    await tester.pumpWidget(const MyApp());
//verifica que el texto de la app exista
    expect(find.text('Network X - Items'), findsOneWidget);
  });
}
