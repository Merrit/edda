// Standard Library
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'dart:io' show Platform;

// Reader Packages
import 'package:reader/settings/settings.dart';

// Third Party Packages
import 'package:file_picker/file_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';

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
                onPressed: () {
                  // FilePickerCross doesn't currently support picking a
                  // directory, so we will pick a file from the base
                  // directory and then parse the directory manually for now.
                  if (Platform.isAndroid) {
                    FilePicker.getDirectoryPath().then((value) => setState(() {
                          libraryPath = value;
                          saveLibraryPath(libraryPath);
                        }));
                  } else {
                    FilePickerCross.pick(type: FileTypeCross.any)
                        .then((filePicker) => setState(() {
                              // libraryPath =
                              //     filePicker.path; // Path of file chosen
                              // Remove file to get directory path.
                              libraryPath = path.dirname(filePicker.path);
                              saveLibraryPath(libraryPath);
                            }));
                  }
                  // showDialog(
                  //   context: context,
                  //   child: Center(
                  //     child: Card(
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(20.0),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: [
                  //             Text('Choose Library Location'),
                  //             SizedBox(
                  //               width: 300,
                  //               child: TextField(
                  //                 autofocus: true,
                  //                 onChanged: (String value) {
                  //                   libraryPath = value;
                  //                 },
                  //                 decoration: InputDecoration(
                  //                   hintText: '/path/to/Books',
                  //                   suffixIcon: IconButton(
                  //                     icon: Icon(Icons.done),
                  //                     onPressed: () {
                  //                       // setState(() {
                  //                       //   saveLibraryPath(libraryPath);
                  //                       //   checkLibraryPath();
                  //                       // });
                  //                       Navigator.pop(context, true);
                  //                     },
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // );
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
        ));
  }
}
