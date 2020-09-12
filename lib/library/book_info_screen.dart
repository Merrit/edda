import 'package:edda/library/cover_image.dart';
import 'package:flutter/material.dart';

import 'package:edda/read_book/book.dart';

// Scaffold
// AppBar
// Body
//  Cover - Title
//  'Read' - Author
//  Description

class BookInfoScreen extends StatelessWidget {
  String lorem =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Morbi tincidunt augue interdum velit euismod. Pellentesque adipiscing commodo elit at imperdiet. Luctus venenatis lectus magna fringilla urna. Malesuada pellentesque elit eget gravida cum. Scelerisque fermentum dui faucibus in ornare quam viverra orci sagittis. Id eu nisl nunc mi. Neque aliquam vestibulum morbi blandit cursus risus at. Consectetur adipiscing elit ut aliquam purus sit amet luctus venenatis. Nunc lobortis mattis aliquam faucibus purus in. Nulla aliquet porttitor lacus luctus. Massa id neque aliquam vestibulum. Aliquam purus sit amet luctus venenatis. Eros in cursus turpis massa tincidunt dui. Consequat ac felis donec et odio pellentesque diam. Ornare arcu dui vivamus arcu felis bibendum. Urna et pharetra pharetra massa. Id venenatis a condimentum vitae sapien pellentesque habitant morbi. Diam in arcu cursus euismod quis. Sit amet risus nullam eget.';

  final Book book;

  BookInfoScreen({@required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Container(
                        height: 400,
                        child: Hero(
                          tag: book.title,
                          child: CoverImage(
                            coverImage: book.coverImage,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  FlatButton(
                    padding: EdgeInsets.all(20),
                    color: Colors.blue,
                    onPressed: () {
                      /* var metadata =
                          book.epub.epub.Schema.Package.Metadata.Description;
                      print(metadata); */
                      // book.getMetadata();
                      print(book.description);
                    },
                    child: Text('Read'),
                  )
                ],
              ),
              SizedBox(width: 50),
              Column(
                children: [
                  Text('Author: ${book.author}'),
                  Text('~Series'),
                  Text('~Publication Date'),
                  Text('~Genre'),
                  Text('~Type: ePub, Audiobook (mp3), cbz, etc'),
                ],
              ),
            ],
          ),
          SizedBox(height: 50),
          Text('Description'),
          SizedBox(height: 20),
          Text(book.description),
        ],
      ),
    );
  }
}
