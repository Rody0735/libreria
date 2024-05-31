import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:libreria/models/book.dart';
import 'package:libreria/services/exceptions.dart';

const String standardApi = 'https://www.googleapis.com/books/v1/volumes?q=';

Future<List<Book>> searchBooks(String title, bool? intitle) async {
  var queryUrl = '$standardApi${intitle == true ? 'intitle:' : ''}$title';

  final List<Book> books = [];

  try {
    final result = await http.get(Uri.parse(queryUrl));
    if (result.statusCode == 200) {
      final data = jsonDecode(result.body);
      (data['items'] as List<dynamic>?)?.forEach((item) {
        books.add(Book.fromJson(item));
      });
    } else {
      throw SearchFailedException();
    }
  } on SocketException {
    throw OfflineException();
  }

  return books;
}

Future<Book> searchBooksFromId(String id) async {
  var queryUrl = '$standardApi$id';

  late Book book;

  try {
    final result = await http.get(Uri.parse(queryUrl));
    if (result.statusCode == 200) {
      book = Book.fromJson(jsonDecode(result.body));
    } else {
      throw BookNotFoundException();
    }
  } on SocketException {
    throw OfflineException();
  }

  return book;
}

Future<Book?> searchBookByISBN(String isbn) async {
  var queryUrl = '$standardApi' 'isbn:$isbn';

  Book? book;

  try {
    final response = await http.get(Uri.parse(queryUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['totalItems'] > 0) {
        book = Book.fromJson(data['items'][0]);
      }
    } else {
      throw BookNotFoundException();
    }
  } on SocketException {
    throw OfflineException();
  }

  return book;
}
