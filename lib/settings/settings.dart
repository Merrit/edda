// Experimental Packages
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  String libraryPath;

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

  Future<void> setPreference({String key, dynamic value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String> getPreference(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }
}

Future<String> checkLibraryPath() {
  var prefs = Settings();
  var path = prefs.checkLibraryPath();
  return path;
}

void saveLibraryPath(String path) async {
  var prefs = Settings();
  prefs.setPreference(key: 'libraryPath', value: path);
}
