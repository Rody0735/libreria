import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:libreria/models/book.dart';
import 'package:libreria/screens/book_detail_page.dart';
import 'package:libreria/services/api.dart';

import '../screens/search_page.dart';

Future<void> scanBarcode(BuildContext context) async {
  var status = await Permission.camera.request();
  if (status.isGranted) {
    try {
      var result = await BarcodeScanner.scan();
      if (result.rawContent.isNotEmpty) {
        final Book? book = await searchBookByISBN(result.rawContent);
        if (book != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailsPage(book: book),
            ),
          );
        } else {

        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Impossibile trovare il libro: $e'),
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Permesso fotocamera non concesso'),
      ),
    );
  }
}
