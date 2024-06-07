import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libreria/main.dart';
import 'package:libreria/screens/library_page.dart';
import 'package:libreria/screens/search_page.dart';

void main() {
  testWidgets('MainPage has a title and a bottom navigation bar', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Trova il primo widget di tipo AppBar e verifica il titolo
    final AppBar appBar = tester.widget(find.byType(AppBar).first);
    expect(appBar.title, isInstanceOf<Text>());
    expect((appBar.title as Text).data, 'Library');

    // Trova la BottomNavigationBar
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Trova l'icona di ricerca specifica all'interno della BottomNavigationBar
    final searchIcon = find.descendant(
      of: find.byType(BottomNavigationBar),
      matching: find.byIcon(Icons.search),
    ).first;

    // Clicca sulla seconda icona della BottomNavigationBar
    await tester.tap(searchIcon);
    await tester.pumpAndSettle();

    // Verifica che il titolo sia cambiato in "Search"
    final AppBar searchAppBar = tester.widget(find.byType(AppBar).first);
    expect(searchAppBar.title, isInstanceOf<Text>());
    expect((searchAppBar.title as Text).data, 'Search');
  });
}
