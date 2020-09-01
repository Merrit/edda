import 'package:edda/read_book/book.dart';
import 'package:edda/read_book/epub.dart';
import 'package:flutter/material.dart';

class BookScreen extends StatefulWidget {
  static final String id = 'book_screen';

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  @override
  Widget build(BuildContext context) {
    var filePath = ModalRoute.of(context).settings.arguments;
    var book = Book(filePath: filePath);

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  book.book,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
