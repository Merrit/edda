// Standard Library
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

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
  String libraryPath = '/path/to/Books';

  @override
  void initState() {
    checkLibraryPath().then((value) => setState(() {
          libraryPath = (value == null) ? libraryPath : value;
        }));
    super.initState();
  }

  Future<String> checkLibraryPath() {
    var prefs = Settings();
    var path = prefs.checkLibraryPath();
    return path;
  }

  void saveLibraryPath(String path) async {
    var prefs = Settings();
    // prefs.checkLibraryPath(); // Is this needed??
    prefs.setPreference(key: 'libraryPath', value: path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        margin: EdgeInsets.all(30),
        // constraints: BoxConstraints.expand(),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Library Location',
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.grey[900],
              child: Text(libraryPath),
            ),
            SizedBox(
              height: 10,
            ),
            FlatButton(
              color: Color(0xFF378174),
              padding: EdgeInsets.all(18),
              onPressed: () async {
                if (Platform.isAndroid || Platform.isIOS) {
                  // Web too?
                  // Picking from 'Downloads' on Android doesn't currently work,
                  // it will just return '/'.
                  String path = await FilePicker.getDirectoryPath();
                  if (path != null) {
                    setState(() {
                      libraryPath = path;
                      saveLibraryPath(libraryPath);
                    });
                  }
                } else {
                  // Linux, Mac, Windows.
                  var chosenPath = await FileChooser.showOpenPanel(
                      canSelectDirectories: true);
                  if (chosenPath.paths.length == 1) {
                    String path = chosenPath.paths[0];
                    setState(() {
                      libraryPath = path;
                      saveLibraryPath(path);
                    });
                  }
                }
              },
              child: Text(
                'Change Location',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
