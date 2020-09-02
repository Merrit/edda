import 'package:edda/read_book/book.dart';
import 'package:edda/read_book/epub.dart';
import 'package:flutter/material.dart';

class BookScreen extends StatefulWidget {
  static final String id = 'book_screen';
  final String filePath;

  BookScreen({@required this.filePath});

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  String filePath;
  Book book;

  void getBook() {
    book = Book(filePath: filePath);
    book.getBookData();
  }

  @override
  void initState() {
    super.initState();
    filePath = widget.filePath;
    getBook();
  }

  @override
  Widget build(BuildContext context) {
    // filePath = ModalRoute.of(context).settings.arguments;

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
