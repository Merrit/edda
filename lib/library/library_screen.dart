// Standard Library
import 'dart:io' show Platform;
import 'package:flutter/material.dart';

// Edda Packages
import 'package:edda/library/cover_tile.dart';
import 'package:edda/library/library.dart';
import 'package:edda/library/cover_tile_build.dart';
import 'package:edda/settings/settings_screen.dart';

class LibraryScreen extends StatefulWidget {
  static final String id = 'library_screen';

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String libraryPath;
  List<CoverTile> bookTiles = [];
  // TODO: This spacing variable should probably replaced with
  // a media query or similar.
  double bookMainAxisSpacing =
      (Platform.isAndroid || Platform.isIOS) ? 0.0 : 10.0;

  @override
  void initState() {
    super.initState();
    getBookTiles().then((value) => setState(() {
          bookTiles = value;
        }));
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
        actions: [
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, SettingsScreen.id).then(
                    (value) => getBookTiles().then((tilesValue) => setState(() {
                          bookTiles = tilesValue;
                        })));
                // This setState is here so it will rebuild the Library with
                // the new library path after the settings screen is popped.
              }),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: GridView.extent(
          maxCrossAxisExtent: 200,
          crossAxisSpacing: 30,
          mainAxisSpacing: bookMainAxisSpacing,
          childAspectRatio: 2 / 5,
          children: bookTiles,
        ),
      ),
    );
  }
}

class LibraryChildCoverTile extends StatefulWidget {
  final Function function;
  final List<CoverTile> bookTiles;

  LibraryChildCoverTile({@required this.function, @required this.bookTiles});

  @override
  _LibraryChildCoverTileState createState() => _LibraryChildCoverTileState();
}

class _LibraryChildCoverTileState extends State<LibraryChildCoverTile> {
  @override
  Widget build(BuildContext context) {
    return widget.bookTiles;
  }
}
