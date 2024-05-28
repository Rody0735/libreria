import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:libreria/models/book.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'books_library.db');
    return await openDatabase(
      path,
      onCreate: (db, version) {
        print("Creating database table...");
        return db.execute(
          'CREATE TABLE books('
              'id TEXT PRIMARY KEY, '
              'title TEXT, '
              'subtitle TEXT, '
              'authors TEXT, '
              'imageLinks TEXT, '
              'description TEXT, '
              'pageCount INTEGER, '
              'isFavorite INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertBook(Book book) async {
    final db = await database;
    await db.insert(
      'books',
      book.toDbJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Book>> books() async {
    final db = await database;
    final List<Map<String, Object?>> bookMaps = await db.query('books');
    return bookMaps.map((bookMap) => Book.fromDbJson(bookMap)).toList();
  }

  Future<void> updateBook(Book book) async {
    final db = await database;
    await db.update(
      'books',
      book.toDbJson(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<void> deleteBook(String id) async {
    final db = await database;
    await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('books');
  }
}
