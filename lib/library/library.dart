import 'dart:io';
import 'package:edda/read_book/book.dart';
import 'package:path/path.dart' as path;
import 'package:edda/library/cover_tile.dart';
import 'package:edda/helpers/check_file_type.dart';
import 'package:edda/settings/settings.dart';

/// The main library view of the application.
class Library {
  String libraryPath;
  List<CoverTile> coverTilesList = [];
  Map<String, dynamic> bookFiles = {}; // Map<bookName, filePath>

  Future<void> findBooks() async {
    Settings prefs = Settings();
    libraryPath = await prefs.checkLibraryPath();
    if (libraryPath == null) {
      print('No library path is set');
    } else {
      Directory library = Directory(libraryPath);
      List files = library.listSync();
      files.forEach((file) {
        String fileType = checkFileType(file);
        if (fileType == '.epub') {
          String bookName = path.basenameWithoutExtension(file.path);
          bookFiles[bookName] = file.path;
        }
      });
    }
  }

  Future<void> buildBookTiles() async {
    await findBooks(); // Populate the bookFiles Map
    bookFiles.forEach((bookName, filePath) async {
      // Call a CoverTile for $filePath
      // The covertile should handle everything else
      CoverTile coverTile = CoverTile(bookName: bookName, filePath: filePath);
      coverTilesList.add(coverTile);
      //
    });
  }
}
