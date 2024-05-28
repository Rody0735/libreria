import 'package:flutter/material.dart';
import 'package:libreria/models/book.dart';
import 'package:libreria/services/database_helper.dart';
import 'package:libreria/widgets/books_list.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late Future<List<Book>> _books;
  String _searchQuery = '';
  String _sortOrder = 'title_asc';

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  void _fetchBooks() {
    setState(() {
      _books = DatabaseHelper().books().then((books) {
        if (_searchQuery.isNotEmpty) {
          books = books
              .where((book) =>
                  book.title
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()) ||
                  book.authors
                      .join(', ')
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()))
              .toList();
        }
        _sortBooks(books);
        return books;
      });
    });
  }

  void _sortBooks(List<Book> books) {
    switch (_sortOrder) {
      case 'title_asc':
        books.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'title_desc':
        books.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'author':
        books.sort(
            (a, b) => a.authors.join(', ').compareTo(b.authors.join(', ')));
        break;
      case 'favorites':
        books.sort(
            (a, b) => (b.isFavorite ? 1 : 0).compareTo(a.isFavorite ? 1 : 0));
        break;
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _fetchBooks();
    });
  }

  void _onSortOrderChanged(String value) {
    setState(() {
      _sortOrder = value;
      _fetchBooks();
    });
  }

  void _onBookRemoved() {
    _fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search',
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: _onSortOrderChanged,
                  icon: const Icon(
                    Icons.filter_list,
                  ),
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                        value: 'title_asc',
                        child: Text('A...Z'),
                      ),
                      const PopupMenuItem(
                        value: 'title_desc',
                        child: Text('Z...A'),
                      ),
                      const PopupMenuItem(
                        value: 'author',
                        child: Text('Author'),
                      ),
                      const PopupMenuItem(
                        value: 'favorites',
                        child: Text('Favorite'),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BooksList(
              booksFuture: _books,
              onBookChange: _onBookRemoved,
              sortOrder: _sortOrder,
            ),
          ),
        ],
      ),
    );
  }
}
