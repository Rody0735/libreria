import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final VoidCallback onScan;
  final bool searchByTitle;
  final ValueChanged<bool> onSearchModeChanged;

  const MySearchBar({
    required this.controller,
    required this.onSearch,
    required this.onScan,
    required this.searchByTitle,
    required this.onSearchModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              suffixIcon: controller.text.isEmpty
                  ? IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: onScan,
                    )
                  : IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: onSearch,
                    ),
              hintText: 'Search',
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (text) {
              (context as Element).markNeedsBuild();
            },
            onSubmitted: (String title) {
              onSearch();
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          color: Theme.of(context).focusColor,
          child: Row(
            children: [
              const Text(
                'Search by title',
                style: TextStyle(fontSize: 16.0),
              ),
              Switch(
                value: searchByTitle,
                onChanged: onSearchModeChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
