// Standard Library
import 'dart:io' show Platform;
import 'package:flutter/material.dart';

// Experimental Packages
import 'package:file_chooser/file_chooser.dart' as FileChooser;

// Third Party Packages
import 'package:file_picker/file_picker.dart';

// Edda Packages
import 'package:edda/settings/settings.dart';

class SettingsScreen extends StatefulWidget {
  static final String id = 'settings_screen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  /// The path to user's books.
  ///
  /// If no saved path is found this dummy text is used to
  /// provide a hint of what is expected.
  String libraryPath = '/path/to/Books';

  @override
  void initState() {
    checkLibraryPath().then((value) => setState(() {
          libraryPath = (value == null) ? libraryPath : value;
        }));
    super.initState();
  }

  /// Loads the saved library path if one exists.
  Future<String> checkLibraryPath() {
    var prefs = Settings();
    var path = prefs.checkLibraryPath();
    return path;
  }

  /// Save the new path to preferences.
  void saveLibraryPath(String path) async {
    var prefs = Settings();
    prefs.setPreference(key: 'libraryPath', value: path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Container(
        margin: EdgeInsets.all(30),
        child: Column(
          children: [
            Text('Library Location'),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.grey[900],
              child: Text(libraryPath),
            ),
            SizedBox(height: 10),
            FlatButton(
              color: Color(0xFF378174),
              padding: EdgeInsets.all(18),
              onPressed: showFilePicker,
              child: Text(
                'Change Location',
                style: TextStyle(fontSize: 22),
              ),
            ),
            SizedBox(width: double.infinity),
          ],
        ),
      ),
    );
  }

  // TODO: Can we move this out of the UI?
  void showFilePicker() async {
    /// Show file picker so the user can select
    /// the directory containing their books.
    if (Platform.isAndroid || Platform.isIOS) {
      // Web too?
      String path = await FilePicker.getDirectoryPath();
      if (path != null) {
        setState(() {
          libraryPath = path;
          saveLibraryPath(libraryPath);
        });
      }
    } else {
      // Linux, Mac, Windows.
      var chosenPath =
          await FileChooser.showOpenPanel(canSelectDirectories: true);
      if (chosenPath.paths.length == 1) {
        String path = chosenPath.paths[0];
        setState(() {
          libraryPath = path;
          saveLibraryPath(path);
        });
      }
    }
  }
}
