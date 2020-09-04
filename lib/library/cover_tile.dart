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
  String title = '';
  String author = '';
  Image coverImage = Image.asset('assets/cover.webp');

  @override
  void initState() {
    super.initState();
    _loadBookData(filePath: widget.filePath);
  }

  _loadBookData({@required String filePath}) async {
    book = Book(filePath: widget.filePath);
    await book.loadBook();
    setState(() {
      title = book.title;
      author = book.author;
      if (book.coverImage != null) {
        coverImage = book.coverImage;
      }
    });
  }

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
                  builder: (context) => BookScreen(book: book),
                ),
              );
            },
            child: Card(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: coverImage,
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
          style: TextStyle(fontSize: 18),
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
        SizedBox(height: 10),
        Text(
          author,
          style: TextStyle(fontSize: 14),
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
      ],
    );
  }
}

// FutureBuilder(
//                   future: coverImage,
//                   // initialData: ,
//                   builder: (BuildContext context, AsyncSnapshot snapshot) {
//                     if (snapshot.hasData == false) {
//                       return Image.asset(coverImageDefault);
//                     }
//                     return snapshot.data;
//                   },
//                 ),
