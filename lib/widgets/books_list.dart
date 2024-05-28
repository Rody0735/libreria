import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:libreria/models/book.dart';
import 'package:libreria/screens/book_detail_page.dart';
import 'package:libreria/services/database_helper.dart';

class SearchBooksList extends StatefulWidget {
  final Future<List<Book>> books;
  final bool hasSearched;

  const SearchBooksList({
    Key? key,
    required this.books,
    required this.hasSearched,
  }) : super(key: key);

  @override
  _SearchBooksListState createState() => _SearchBooksListState();
}

class _SearchBooksListState extends State<SearchBooksList> {
  late Future<List<Book>> _books;

  @override
  void initState() {
    super.initState();
    _books = widget.books;
  }

  void _refreshBooks() {
    setState(() {
      _books = DatabaseHelper().books();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BooksList(
      booksFuture: _books,
      hasSearched: widget.hasSearched,
      onBookRemoved: _refreshBooks,
    );
  }
}

class BooksList extends StatelessWidget {
  final Future<List<Book>> booksFuture;
  final bool? hasSearched;
  final VoidCallback onBookRemoved;

  const BooksList({
    Key? key,
    required this.booksFuture,
    required this.onBookRemoved,
    this.hasSearched,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: booksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              hasSearched == true ? 'No books found' : '',
              style: const TextStyle(fontSize: 18),
            ),
          );
        } else {
          final books = snapshot.data!;
          final groupedBooks = groupBy(books, (Book book) => book.authors.isNotEmpty ? book.authors[0][0].toUpperCase() : '');

          return ListView.builder(
            itemCount: groupedBooks.length,
            itemBuilder: (context, index) {
              final letter = groupedBooks.keys.elementAt(index);
              final booksByLetter = groupedBooks[letter]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ),
                  ...booksByLetter.map((book) {
                    return BookListItem(
                      book: book,
                      onBookRemoved: onBookRemoved,
                    );
                  }).toList(),
                ],
              );
            },
          );
        }
      },
    );
  }
}

class BookListItem extends StatelessWidget {
  final Book book;
  final VoidCallback onBookRemoved;

  const BookListItem({
    Key? key,
    required this.book,
    required this.onBookRemoved,
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
                  : const Center(
                child: Icon(
                  Icons.book,
                  size: 70,
                  color: Colors.grey,
                ),
              ),
            ),
            title: Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              book.authors.join(', '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailsPage(book: book),
                ),
              );
              if (result == true) {
                onBookRemoved();
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
