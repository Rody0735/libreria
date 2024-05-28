import 'package:flutter/material.dart';
import 'package:libreria/models/book.dart';

Widget bookDetail(Book book) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        book.title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      if (book.subtitle.isNotEmpty)
        Text(
          book.subtitle,
          style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
        ),
      const SizedBox(height: 8),
      Text(
        'Autore: ${book.authors.join(', ')}',
        style: const TextStyle(fontSize: 16),
      ),
      if (book.imageLinks != null)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Image.network(
            book.imageLinks!.values.first.toString(),
            height: 200,
          ),
        ),
      Text(
        book.description,
        style: const TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 8),
      Text(
        'Pagine: ${book.pageCount}',
        style: const TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 16),
    ],
  );
}
