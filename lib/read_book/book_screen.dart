import 'package:edda/read_book/book.dart';
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
  Future chapters;
  int currentChapter = 0;
  bool showInterface = true;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    book = widget.book;
    _pageController = PageController();
    _getChapters();
  }

  void _getChapters() {
    chapters = book.getChapters();
  }

  /// Parse the given chapter into pages for the PageView.
  String getCurrentPageText(int index, String chapterText) {
    // How many characters fit on the screen.
    // TODO: Find a way to determine this programmatically, including how it
    // changes when the user changes font size.
    int charactersPerPage = 1500;
    print(index);

    if ((index == 0) && (chapterText.length < charactersPerPage))
      return chapterText;

    // If our position hasn't gone past the length of the chapter..
    if (index * charactersPerPage < chapterText.length) {
      // On page one, return a full page of text.
      if (index == 0) {
        return chapterText.substring(0, charactersPerPage);
      }
      // On subsequent pages, return the next full page of text.
      return chapterText.substring(
          index * charactersPerPage, chapterText.length);
    } else {
      // We have reached the end of the chapter, load the next chapter.
      if ((currentChapter + 1) <= book.chapters.length) {
        // setState(() {
        ///Futurebuilder check multiple futures, one for the chapters being
        ///loaded and another for here, we can do
        ///Future.value(currentChapter+=1) then futurebuilder can say if
        ///snapshot.data == 0 or snapshot.data==1 etc.
        currentChapter += 1;
        // });
      }
      return "Finished";
/*       return chapterText.substring(
          (index - 1) * charactersPerPage, chapterText.length); */
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showInterface
          ? AppBar(
              title: GestureDetector(
                onTap: () {
                  book.getChapters();
                },
                child: Text(book.title),
              ),
            )
          : null,
      body: FutureBuilder(
        future: chapters,
        // initialData: InitialData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading text'));
          }

          return PageView.builder(
            physics: ScrollPhysics(),
            controller: _pageController,
            itemBuilder: (context, index) {
              return Center(
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(fontSize: 25.0, color: Colors.grey[300]),
                      text: getCurrentPageText(
                          index, book.chapters[currentChapter])),
                  textAlign: TextAlign.start,
                  textScaleFactor: 1.0,
                  textDirection: TextDirection.ltr,
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
