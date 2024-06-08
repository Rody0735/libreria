import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:libreria/main.dart';
import 'package:libreria/widgets/books_list.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('Integration test: Search and Library pages', (WidgetTester tester) async {
    print('Starting test...');
    await tester.pumpWidget(MyApp());

    // Verifica se siamo sulla pagina principale
    final bottomNavBarFinder = find.byType(BottomNavigationBar);
    expect(bottomNavBarFinder, findsOneWidget);

    // Verifica se le icone esistono nel BottomNavigationBar
    final libraryIconFinder = find.descendant(
      of: bottomNavBarFinder,
      matching: find.byIcon(Icons.library_books),
    );

    final searchIconFinder = find.descendant(
      of: bottomNavBarFinder,
      matching: find.byIcon(Icons.search),
    );

    print('Found libraryIconFinder: ${libraryIconFinder.evaluate().isNotEmpty}');
    print('Found searchIconFinder: ${searchIconFinder.evaluate().isNotEmpty}');
    expect(libraryIconFinder, findsOneWidget);
    expect(searchIconFinder, findsOneWidget);

    // Vai alla pagina di ricerca
    await tester.tap(searchIconFinder);
    await tester.pumpAndSettle();
    print('Navigated to search page');

    // Debug aggiuntivo per capire se siamo sulla pagina di ricerca
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);

    // Scrivi qualcosa nella barra di ricerca
    await tester.enterText(find.byType(TextField), 'Test book');
    await tester.pumpAndSettle();
    print('Entered text in search field');

    // Debug per verificare la presenza dell'icona send
    final sendIconFinder = find.byIcon(Icons.send);
    expect(sendIconFinder, findsOneWidget);

    await tester.tap(sendIconFinder);
    await tester.pumpAndSettle();
    print('Tapped send icon');

    // Torna alla pagina della libreria
    await tester.tap(libraryIconFinder);
    await tester.pumpAndSettle();
    print('Navigated back to library page');

    expect(find.byType(BookListItem), findsNothing);

    // Verifica se siamo tornati alla pagina della libreria
    expect(find.text('Library'), findsAny);

    // Aggiungi una pausa forzata per assicurarti che tutto sia renderizzato
    await tester.pump(Duration(seconds: 1));
    print('Waited for rendering');

    // Aggiungi un controllo di visibilità
    final libraryIconVisible = libraryIconFinder.evaluate().isNotEmpty && libraryIconFinder.evaluate().first.renderObject!.attached;
    expect(libraryIconVisible, true);
    print('Library icon is visible: $libraryIconVisible');

    await tester.tap(libraryIconFinder);
    await tester.pumpAndSettle();
    print('Tapped library icon');
  });
}
