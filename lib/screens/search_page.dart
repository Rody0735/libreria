import 'package:flutter/material.dart';
import 'package:libreria/models/book.dart';
import 'package:libreria/services/api.dart';
import 'package:libreria/widgets/books_list.dart';
import 'package:libreria/services/camera.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<List<Book>>? _books;
  final TextEditingController _controller = TextEditingController();
  bool _searchByTitle = true;
  bool _hasSearched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isEmpty
                    ? IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () => scanBarcode(context),
                      )
                    : IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _search,
                      ),
                hintText: 'Search',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (text) {
                setState(() {});
              },
              onSubmitted: (String title) {
                _search();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            color: Theme.of(context).focusColor,
            child: Row(
              children: [
                const Text(
                  'Search by title',
                  style: TextStyle(fontSize: 16.0),
                ),
                Switch(
                  value: _searchByTitle,
                  onChanged: (value) {
                    setState(() {
                      _searchByTitle = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _books == null
                ? Container()
                : BooksList(
                    booksFuture: _books!,
                    onBookChange: _refreshBooks,
                  ),
          ),
        ],
      ),
    );
  }

  void _search() {
    setState(() {
      _hasSearched = true;
      _books = searchBooks(_controller.text, _searchByTitle);
    });
  }

  void _refreshBooks() {
    setState(() {
      _books = searchBooks(_controller.text, _searchByTitle);
    });
  }
}
