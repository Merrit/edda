// Standard Library
import 'package:flutter/material.dart';

// Reader Packages
import 'package:reader/components/cover_tile.dart';
import 'package:reader/library/find_books.dart';
import 'package:reader/settings/settings_screen.dart';

class Library extends StatefulWidget {
  static final String id = 'library_screen';

  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  String libraryPath;
  List<CoverTile> bookTiles = [];

  Future<List<CoverTile>> getBookTiles() async {
    var books = Books();
    await books.buildBookTiles();
    bookTiles = books.coverTilesList;
    return bookTiles;
  }

  @override
  void initState() {
    super.initState();
    getBookTiles().then((value) => setState(() {
          bookTiles = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
        actions: [
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () async {
                Navigator.pushNamed(context, SettingsScreen.id);
                setState(() {
                  // This setState is here so it will rebuild the Library with
                  // the new library path after the settings screen is popped.
                });
              }),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: GridView.extent(
          maxCrossAxisExtent: 200,
          crossAxisSpacing: 30,
          mainAxisSpacing: 50.0,
          childAspectRatio: 2 / 5,
          children: bookTiles,
        ),
      ),
    );
  }
}
