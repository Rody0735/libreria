import 'package:flutter/material.dart';

class SettingsMenu extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkTheme;
  final VoidCallback showClearMemoryDialog;

  const SettingsMenu({
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
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Dark Theme', style: TextStyle(fontSize: 18.0, color: Theme.of(context).textTheme.bodyLarge?.color)),
                    Switch(
                      value: isDarkTheme,
                      onChanged: (bool value) {
                        toggleTheme();
                        setState(() {});
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          PopupMenuItem(
            value: 'clear',
            child: Text('Clear Memory', style: TextStyle(fontSize: 18.0, color: Theme.of(context).textTheme.bodyLarge?.color)),
          ),
        ];
      },
    );
  }
}
