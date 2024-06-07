import 'package:flutter_test/flutter_test.dart';
import 'package:libreria/models/book.dart';

void main() {
  group('Book Model Tests', () {
    test('fromJson creates a Book object from JSON', () {
      final json = {
        'id': '123',
        'volumeInfo': {
          'title': 'Test Book',
          'subtitle': 'Test Subtitle',
          'authors': ['Author One', 'Author Two'],
          'imageLinks': {
            'thumbnail': 'https://test.com/thumbnail.jpg'
          },
          'description': 'Test Description',
          'pageCount': 200
        },
        'isFavorite': true,
      };

      final book = Book.fromJson(json);

      expect(book.id, '123');
      expect(book.title, 'Test Book');
      expect(book.subtitle, 'Test Subtitle');
      expect(book.authors, ['Author One', 'Author Two']);
      expect(book.imageLinks?['thumbnail'].toString(), 'https://test.com/thumbnail.jpg');
      expect(book.description, 'Test Description');
      expect(book.pageCount, 200);
      expect(book.isFavorite, true);
    });

    test('fromDbJson creates a Book object from database JSON', () {
      final dbJson = {
        'id': '123',
        'title': 'Test Book',
        'subtitle': 'Test Subtitle',
        'authors': 'Author One,Author Two',
        'imageLinks': 'https://test.com/thumbnail.jpg',
        'description': 'Test Description',
        'pageCount': 200,
        'isFavorite': 1,
      };

      final book = Book.fromDbJson(dbJson);

      expect(book.id, '123');
      expect(book.title, 'Test Book');
      expect(book.subtitle, 'Test Subtitle');
      expect(book.authors, ['Author One', 'Author Two']);
      expect(book.imageLinks?['0'].toString(), 'https://test.com/thumbnail.jpg');
      expect(book.description, 'Test Description');
      expect(book.pageCount, 200);
      expect(book.isFavorite, true);
    });

    test('toDbJson converts a Book object to database JSON', () {
      final book = Book(
        id: '123',
        title: 'Test Book',
        subtitle: 'Test Subtitle',
        authors: ['Author One', 'Author Two'],
        imageLinks: {'thumbnail': Uri.parse('https://test.com/thumbnail.jpg')},
        description: 'Test Description',
        pageCount: 200,
        isFavorite: true,
      );

      final dbJson = book.toDbJson();

      expect(dbJson['id'], '123');
      expect(dbJson['title'], 'Test Book');
      expect(dbJson['subtitle'], 'Test Subtitle');
      expect(dbJson['authors'], 'Author One,Author Two');
      expect(dbJson['imageLinks'], 'https://test.com/thumbnail.jpg');
      expect(dbJson['description'], 'Test Description');
      expect(dbJson['pageCount'], 200);
      expect(dbJson['isFavorite'], 1);
    });

    test('Book object defaults are set correctly', () {
      final book = Book(
        id: '123',
        title: 'Default Test Book',
      );

      expect(book.subtitle, '');
      expect(book.authors, isNull);
      expect(book.imageLinks, isNull);
      expect(book.description, '');
      expect(book.pageCount, 0);
      expect(book.isFavorite, false);
    });
  });
}
