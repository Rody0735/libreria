import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:libreria/models/book.dart';
import 'package:libreria/screens/book_detail_page.dart';
import 'package:libreria/services/exceptions.dart';

class BooksList extends StatelessWidget {
  final Future<List<Book>> booksFuture;
  final bool? hasSearched;
  final String? sortOrder;
  final VoidCallback onBookChange;

  const BooksList({
    Key? key,
    required this.booksFuture,
    required this.onBookChange,
    this.hasSearched,
    this.sortOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: booksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          String errorMessage;
          if (snapshot.error is OfflineException) {
            errorMessage =
                'No internet connection. Please check your connection and try again.';
          } else {
            errorMessage = 'Error: ${snapshot.error}';
          }
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(fontSize: 18),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No books found',
              style: TextStyle(fontSize: 18),
            ),
          );
        } else {
          final books = snapshot.data!;
          if (sortOrder == 'author') {
            final noAuthorBooks = books.where((book) {
              return book.authors == null ||
                  book.authors!.isEmpty ||
                  book.authors![0].trim().isEmpty;
            }).toList();
            final authorBooks = books.where((book) {
              return book.authors != null &&
                  book.authors!.isNotEmpty &&
                  book.authors![0].trim().isNotEmpty;
            }).toList();

            final groupedBooks = groupBy(
              authorBooks,
              (Book book) => book.authors![0][0].toUpperCase(),
            );

            final sortedKeys = groupedBooks.keys.toList()..sort();

            return ListView.builder(
              itemCount: sortedKeys.length + (noAuthorBooks.isNotEmpty ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == 0 && noAuthorBooks.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'No Author',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ...noAuthorBooks.map((book) {
                        return BookListItem(
                          book: book,
                          onBookChange: onBookChange,
                        );
                      }).toList(),
                    ],
                  );
                } else {
                  final keyIndex = noAuthorBooks.isNotEmpty ? index - 1 : index;
                  final key = sortedKeys[keyIndex];
                  final groupedBooksByKey = groupedBooks[key]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          key,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ...groupedBooksByKey.map((book) {
                        return BookListItem(
                          book: book,
                          onBookChange: onBookChange,
                        );
                      }).toList(),
                    ],
                  );
                }
              },
            );
          } else {
            // Display books in the default order
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                return BookListItem(
                  book: books[index],
                  onBookChange: onBookChange,
                );
              },
            );
          }
        }
      },
    );
  }
}

class BookListItem extends StatelessWidget {
  final Book book;
  final VoidCallback onBookChange;

  const BookListItem({
    Key? key,
    required this.book,
    required this.onBookChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            leading: Container(
              width: 60,
              height: 100,
              child: book.imageLinks != null && book.imageLinks!.isNotEmpty
                  ? Image.network(
                      book.imageLinks!.values.first.toString(),
                      fit: BoxFit.contain,
                    )
                  : const Icon(
                      Icons.book,
                      size: 50,
                      color: Colors.grey,
                    ),
            ),
            title: Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              book.authors?.join(', ') ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailsPage(
                    bookFuture: Future.value(book),
                    onBookChange: onBookChange,
                  ),
                ),
              );
              if (result == true) {
                onBookChange();
              }
            },
          ),
          if (book.isFavorite)
            const Positioned(
              right: 8,
              top: 8,
              child: Icon(
                Icons.favorite,
                color: Colors.red,
                size: 16,
              ),
            ),
        ],
      ),
    );
  }
}
