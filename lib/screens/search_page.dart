import 'package:flutter/material.dart';
import 'package:libreria/models/book.dart';
import 'package:libreria/services/api.dart';

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
      appBar: AppBar(
        title: const Center(
          child: Text('Search'),
        ),
      ),
      body: Column(
        children: [

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