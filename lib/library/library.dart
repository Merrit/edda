import 'dart:io';

import 'package:edda/library/cover_tile.dart';
import 'package:edda/helpers/check_file_type.dart';
import 'package:edda/settings/settings.dart';

/// The main library view of the application.
class Library {
  /// Find supported files in the library path.
  /// Supported files are returned as a Map<String, String> in the form
  /// of {path: fileType}. File type is included so it doesn't have to be
  /// checked again later when we decide how to read the file.
  static Future<Map<String, String>> _findBooks() async {
    String libraryPath;
    Map<String, String> bookFiles = {};

    Settings prefs = Settings();
    libraryPath = await prefs.checkLibraryPath();
    if (libraryPath == null) {
      print('No library path is set');
    } else {
      Directory library = Directory(libraryPath);
      List files = library.listSync();
      files.forEach((file) {
        String fileType = checkFileType(file);
        String path = file.path;
        if (fileType == '.epub') {
          bookFiles[path] = fileType;
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

    Map<String, String> books = await _findBooks();
    books.forEach((filePath, fileType) {
      CoverTile coverTile = CoverTile(filePath: filePath, fileType: fileType);
      coverTilesList.add(coverTile);
    });
    return coverTilesList;
  }
}
