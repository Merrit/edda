// Experimental Packages
import 'package:shared_preferences/shared_preferences.dart';

/// A class that represents the settings / preferences that have been set.
class Settings {
  /// The location of the user's books.
  // TODO: This will likely need to have multiple
  // entries, for ebooks, audiobooks, comics maybe.
  String libraryPath;

  /// Load a saved library path if one exists.
  Future<String> checkLibraryPath() async {
    var savedPath = await getPreference('libraryPath');
    if (savedPath != null) {
      libraryPath = savedPath;
      return libraryPath;
    } else {
      print('No saved path found.');
      return null;
    }
  }

  /// Set a user preference.
  ///
  /// [key] should be a descriptor like 'library_path' or 'theme'.
  Future<void> setPreference({String key, dynamic value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  /// Load a saved user preference.
  Future<dynamic> getPreference(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }
}

// TODO: Why are these 2 duplicated outside the class??
Future<String> checkLibraryPath() {
  var prefs = Settings();
  var path = prefs.checkLibraryPath();
  return path;
}

void saveLibraryPath(String path) async {
  var prefs = Settings();
  prefs.setPreference(key: 'libraryPath', value: path);
}
