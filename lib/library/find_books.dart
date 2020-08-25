import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:reader/components/cover_tile.dart';

import 'package:reader/settings/settings.dart';

class Books {
  String libraryPath;
  List<CoverTile> coverTilesList = [];
  Map<String, dynamic> bookFiles = {};

  Future<void> findBooks() async {
    var prefs = Settings();
    libraryPath = await prefs.checkLibraryPath();
    if (libraryPath == null) {
      print('No library path is set');
    } else {
      Directory library = Directory(libraryPath);
      List files = library.listSync();
      files.forEach((element) {
        String bookName = path.basenameWithoutExtension(element.toString());
        bookFiles[bookName] = element;
      });
    }
  }

  Future<void> buildBookTiles() async {
    await findBooks(); // Populate the bookFiles Map
    bookFiles.forEach((key, value) {
      var coverTile = CoverTile(name: key, image: 'assets/cover.webp');
      coverTilesList.add(coverTile);
    });
  }
}
