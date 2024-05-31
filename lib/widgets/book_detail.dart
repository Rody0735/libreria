import 'package:flutter/material.dart';
import 'package:libreria/models/book.dart';

Widget bookDetail(Book book) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    alignment: Alignment.centerLeft,
    child: Column(
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
          'Author: ${book.authors?.join(', ')}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: book.imageLinks != null
              ? Image.network(
                  book.imageLinks!.values.first.toString(),
                  fit: BoxFit.cover,
                )
              : Container(
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.image, size: 50)),
                ),
        ),
        const SizedBox(height: 16),
        if (book.description.isNotEmpty)
          Text(
            book.description,
            style: const TextStyle(fontSize: 16),
          )
        else
          const Text(
            'No description available',
            style: TextStyle(fontSize: 16),
          ),
        const SizedBox(height: 8),
        Text(
          'Number of Pages: ${book.pageCount}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
      ],
    ),
  );
}
