import 'package:flutter/material.dart';

class SettingsMenu extends StatelessWidget {
  final VoidCallback toggleTheme;
  bool isDarkTheme;
  final VoidCallback showClearMemoryDialog;

  SettingsMenu({
    Key? key,
    required this.toggleTheme,
    required this.isDarkTheme,
    required this.showClearMemoryDialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'clear') {
          showClearMemoryDialog();
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: 'theme',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dark Theme', style: TextStyle(fontSize: 18.0),),
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Switch(
                      value: isDarkTheme,
                      onChanged: (bool value) {
                        isDarkTheme = ! isDarkTheme;
                        toggleTheme();
                        setState(() {});
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'clear',
            child: Text('Clear Memory', style: TextStyle(fontSize: 18.0),),
          ),
        ];
      },
    );
  }
}
