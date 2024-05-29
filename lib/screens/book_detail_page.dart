import 'package:flutter/material.dart';
import 'package:libreria/models/book.dart';
import 'package:libreria/services/database_helper.dart';
import 'package:libreria/widgets/book_detail.dart';

class BookDetailsPage extends StatefulWidget {
  final Future<Book> bookFuture;

  const BookDetailsPage({Key? key, required this.bookFuture}) : super(key: key);

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  late Future<Book> _bookFuture;
  late bool isFavorite;
  late bool isInLibrary;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _bookFuture = widget.bookFuture;
    _checkIfInLibrary();
    _checkIfFavorite();
  }

  Future<void> _checkIfInLibrary() async {
    final books = await _databaseHelper.books();
    final book = await _bookFuture;
    setState(() {
      isInLibrary = books.any((b) => b.id == book.id);
    });
  }

  Future<void> _checkIfFavorite() async {
    final book = await _bookFuture;
    setState(() {
      isFavorite = book.isFavorite;
    });
  }

  Future<void> _addToLibrary(Book book) async {
    book.isFavorite = false;
    await _databaseHelper.insertBook(book);
    setState(() {
      isInLibrary = true;
    });
  }

  Future<void> _removeFromLibrary(Book book) async {
    await _databaseHelper.deleteBook(book.id);
    setState(() {
      isInLibrary = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Book>(
          future: _bookFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else if (!snapshot.hasData) {
              return const Text('No Data');
            } else {
              return Text(snapshot.data!.title);
            }
          },
        ),
      ),
      body: FutureBuilder<Book>(
        future: _bookFuture,
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
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No Data',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            final book = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: bookDetail(book),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: isInLibrary
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  isFavorite = !isFavorite;
                                  book.isFavorite = isFavorite;
                                  _databaseHelper.updateBook(book);
                                });
                              },
                            ),
                            ElevatedButton(
                              onPressed: () => _removeFromLibrary(book),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                              child: const Text('Remove from Library'),
                            ),
                          ],
                        )
                      : Center(
                          child: ElevatedButton(
                            onPressed: () => _addToLibrary(book),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: const Text('Add to Library'),
                          ),
                        ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
