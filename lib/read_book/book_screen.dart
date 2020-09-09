import 'package:edda/read_book/book.dart';
import 'package:edda/read_book/epub.dart';
import 'package:flutter/material.dart';

class BookScreen extends StatefulWidget {
  static final String id = 'book_screen';
  final Book book;

  BookScreen({@required this.book});

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  Book book;
  String title;

  // void getBook() {
  //   book = Book(filePath: filePath);
  //   book.getBookData().then((value) => setState(() {
  //         // setState is called to make sure state has the book info.
  //       }));
  // }

  @override
  void initState() {
    super.initState();
    book = widget.book;
    // getBook();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  book.author,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
