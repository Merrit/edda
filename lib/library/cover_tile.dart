// Standard Library
import 'dart:io';

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
  Future<String> title;
  Future<Image> coverImage;

  @override
  void initState() {
    super.initState();
    book = Book(filePath: widget.filePath);
    book.getBookData().then((value) => () {
          title = book.title;
          coverImage = book.coverImage;
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
                    // builder: (context) => BookScreen(book: book.book),
                    ),
              );
            },
            child: Card(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: FutureBuilder(
                  future: coverImage,
                  initialData: Image.asset(coverImageDefault),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      book.coverImage
                      return coverImage;
                    }
                    return;
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
          'widget.book.title',
          style: TextStyle(fontSize: 20),
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
      ],
    );
  }
}
