import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:edda/components/cover_tile.dart';
import 'package:edda/helpers/check_file_type.dart';
import 'package:edda/settings/settings.dart';

/// The main library view of the application.
class Library {
  String libraryPath;
  List<CoverTile> coverTilesList = [];
  Map<String, dynamic> bookFiles = {}; // Map<name, filePath>

  Future<void> findBooks() async {
    var prefs = Settings();
    libraryPath = await prefs.checkLibraryPath();
    if (libraryPath == null) {
      print('No library path is set');
    } else {
      Directory library = Directory(libraryPath);
      List files = library.listSync();
      files.forEach((element) {
        String fileType = checkFileType(element);
        if (fileType == '.epub' || fileType == '.cbz') {
          String bookName = path.basenameWithoutExtension(element.path);
          bookFiles[bookName] = element.path;
        }
      });
    }
  }

  Future<void> buildBookTiles() async {
    await findBooks(); // Populate the bookFiles Map
    bookFiles.forEach((key, value) {
      var coverTile = CoverTile(name: key, filePath: value);
      coverTilesList.add(coverTile);
    });
  }
}
