import 'dart:io';
import 'package:edda/read_book/book.dart';
import 'package:path/path.dart' as path;
import 'package:edda/library/cover_tile.dart';
import 'package:edda/helpers/check_file_type.dart';
import 'package:edda/settings/settings.dart';

/// The main library view of the application.
class Library {
  /// Find supported files in library path.
  static Future<List<String>> _findBooks() async {
    String libraryPath;
    List<String> bookFiles = [];

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
          bookFiles.add(file.path);
        }
      });
    }
    return bookFiles;
  }

  /// Create a CoverTile for each supported type of file found in path.
  /// Initially no metadata will be present so the library view loads
  /// quickly - the cover, title, etc can be loaded after that.
  static Future<List<CoverTile>> buildBookTiles() async {
    List<CoverTile> coverTilesList = [];

    List<String> books = await _findBooks();
    books.forEach((filePath) {
      CoverTile coverTile = CoverTile(filePath: filePath);
      coverTilesList.add(coverTile);
    });
    return coverTilesList;
  }
}
