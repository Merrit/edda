// Standard Library
import 'dart:io';

import 'package:edda/library/cover_tile_build.dart';
import 'package:edda/read_book/book_screen.dart';
import 'package:flutter/material.dart';

// Edda Packages
import 'package:edda/read_book/book.dart';
import 'package:edda/library/library.dart';

class CoverTile extends StatefulWidget {
  final String bookName;
  final String filePath;

  CoverTile({@required this.bookName, @required this.filePath});

  @override
  _CoverTileState createState() => _CoverTileState();
}

class _CoverTileState extends State<CoverTile> {
  final String coverImageDefault = 'assets/cover.webp';
  Book book;
  // Future<String> title;
  String title = 'Title';
  Future<String> author;
  Future coverImage;

  @override
  void initState() {
    super.initState();
    // book = loadBookData(filePath: widget.filePath);
    // book.loadBook()
    _loadBookData(filePath: widget.filePath).then((book) => () {
          title = book.getTitle();
        });

    // .then((value) => () {
    //       title = book.title;
    //       coverImage = book.coverImage;
    //     })
  }

  Future _loadBookData({@required String filePath}) async {
    // var book = Book(filePath: filePath);
    book = Book(filePath: widget.filePath);
    await book.loadBook();
    // title = book.getTitle();
    // print(title);
    // author = book.author;
    // coverImage = book.coverImage;

    return book;
  }

/*   @override
void initState() {
  super.initState();
  checkList = []; //It is important
  this.loadBookData();
}

Future<void> getCheckList() async{
  checkList = await CheckList.browse();
  setState({});
} */

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    // builder: (context) => BookScreen(book: book.book),
                    ),
              );
            },
            child: Card(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: FutureBuilder(
                  future: coverImage,
                  // initialData: ,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData == false) {
                      return Image.asset(coverImageDefault);
                    }
                    return snapshot.data;
                  },
                ),
              ),
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(fontSize: 20),
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
      ],
    );
  }
}

/*         FutureBuilder(
          future: title,
          // initialData: InitialData,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData == false) {
              return Text(
                'Title',
                style: TextStyle(fontSize: 20),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              );
            }
            return Text(
              snapshot.data,
              style: TextStyle(fontSize: 20),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            );
          },
        ), */
