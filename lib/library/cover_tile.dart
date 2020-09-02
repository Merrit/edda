// Standard Library
import 'dart:io';
import 'package:edda/read_book/book_screen.dart';
import 'package:flutter/material.dart';

// Edda Packages
import 'package:edda/read_book/book.dart';

class CoverTile extends StatelessWidget {
  // final String name;
  // final String filePath;
  final String image = 'assets/cover.webp';
  final Book book;

  CoverTile({@required this.book});

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
                child: Image.memory(
                  book.coverImage,
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
          book.title,
          style: TextStyle(fontSize: 20),
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
      ],
    );
  }
}
