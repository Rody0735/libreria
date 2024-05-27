import 'package:flutter/material.dart';
import 'package:libreria/models/book.dart';
import 'package:libreria/services/database_helper.dart';
import 'package:libreria/widget/book_detail.dart';

class BookDetailsPage extends StatefulWidget {
  final Book book;

  const BookDetailsPage({Key? key, required this.book}) : super(key: key);

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  late bool isFavorite;
  late bool isInLibrary;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    isFavorite = widget.book.isFavorite;
    _checkIfInLibrary();
  }

  Future<void> _checkIfInLibrary() async {
    final books = await _databaseHelper.books();
    setState(() {
      isInLibrary = books.any((book) => book.id == widget.book.id);
    });
  }

  Future<void> _addToLibrary() async {
    await _databaseHelper.insertBook(widget.book);
    setState(() {
      isInLibrary = true;
    });
  }

  Future<void> _removeFromLibrary() async {
    await _databaseHelper.deleteBook(widget.book.id);
    setState(() {
      isInLibrary = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: bookDetail(widget.book),
            ),
          ),
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: isInLibrary
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite;
                            widget.book.isFavorite = isFavorite;
                            _databaseHelper.updateBook(widget.book);
                          });
                        },
                      ),
                      ElevatedButton(
                        onPressed: _removeFromLibrary,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Rimuovi dalla libreria'),
                      ),
                    ],
                  )
                : Center(
                    child: ElevatedButton(
                      onPressed: _addToLibrary,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Aggiungi alla libreria'),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
