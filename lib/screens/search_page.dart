import 'package:flutter/material.dart';
import 'package:libreria/models/book.dart';
import 'package:libreria/services/api.dart';
import 'package:libreria/widgets/books_list.dart';
import 'package:libreria/widgets/search_bar.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MySearchBar(
            controller: _controller,
            onSearch: () {
              search(_controller.text);
              setState(() {
                _hasSearched = true;
              });
            },
            onScan: () => scanBarcode(context),
            searchByTitle: _searchByTitle,
            onSearchModeChanged: (value) {
              setState(() {
                _searchByTitle = value;
              });
            },
          ),
          Expanded(
            child: _books == null
                ? Container()
                : SearchBooksList(
                    books: _books!,
                    hasSearched: _hasSearched,
                  ),
          ),
        ],
      ),
    );
  }

  void search(String title) {
    setState(() {
      _books = searchBooks(title, _searchByTitle);
    });
  }
}
