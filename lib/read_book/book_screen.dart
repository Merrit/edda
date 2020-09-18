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
  int currentChapter = 5;
  int currentPage = 0;
  bool showInterface = true;
  bool pagedForward = true;
  PageController _pageController;
  double x = 0;

/*   _listener() {
    print(
        'PageView scroll direction: ${_pageController.position.userScrollDirection}');
/*     setState(() {
      if (_pageController.position.userScrollDirection == ScrollDirection.reverse) {
        print('swiped to right');
      } else {
        print('swiped to left');
      }
    }); */
  } */

  @override
  void initState() {
    super.initState();
    book = widget.book;
    _pageController = PageController();
    // _controller = PageController()..addListener(_listener);
    _getChapters();
  }

  void _getChapters() {
    chapters = book.getChapters();
  }

/*   Future _previousChapter() async {
    currentChapter--;
    currentPage = book.chapters[currentChapter].pages.length;
  } */

  // TODO: These can't be hardcoded!
  bool hasReachedChapterStart = true;
  bool hasReachedChapterEnd = false;

  Duration pageTurnDuration = Duration(milliseconds: 100);
  Curve pageTurnCurve = Curves.ease;

  void _toggleInterface() {
    setState(() {
      showInterface = !showInterface;
    });
  }

  void _goForward() {
    // Add end of book check
    if (hasReachedChapterEnd) {
      hasReachedChapterEnd = false;
      hasReachedChapterStart = true;
      currentPage = 0;
      _pageController.jumpToPage(0);
      setState(() {
        currentChapter++;
      });
    } else {
      _pageController.nextPage(
          duration: pageTurnDuration, curve: pageTurnCurve);
      currentPage++;
    }
  }

  void _goBack() {
    if (hasReachedChapterStart) {
      hasReachedChapterStart = false;
      hasReachedChapterEnd = true;
      var previousChapter = currentChapter - 1;
      currentPage = book.chapters[previousChapter].pages.length;
      _pageController.jumpToPage(currentPage);
      setState(() {
        currentChapter--;
      });
    } else {
      _pageController.previousPage(
          duration: pageTurnDuration, curve: pageTurnCurve);
      currentPage--;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showInterface
          ? AppBar(
              title: Text(book.title),
            )
          : null,
      body: FutureBuilder(
        future: chapters,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading text'));
          }
          // IgnorePointer()
          return Container(
            child: Stack(
              children: [
                GestureDetector(
                  onHorizontalDragEnd: (dragEndDetails) {
                    if (dragEndDetails.primaryVelocity < 0) {
                      _goForward();
                    } else if (dragEndDetails.primaryVelocity > 0) {
                      _goBack();
                    }
                  },
                  child: PageView(
                    controller: _pageController,
                    children: book.chapters[currentChapter].pages,
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      if (index + 1 ==
                          book.chapters[currentChapter].pages.length) {
                        hasReachedChapterEnd = true;
                      } else if (index == 0) {
                        hasReachedChapterStart = true;
                      } else {
                        hasReachedChapterStart = false;
                        hasReachedChapterEnd = false;
                      }
                    },
                  ),
                ),
                Row(
                  children: [
                    // Detect left-side tap
                    Flexible(
                      flex: 4,
                      child: Container(
                        color: Colors.lightGreen.withOpacity(0.3),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => _goBack(),
                        ),
                      ),
                    ),
                    // Detect center tap
                    Flexible(
                      flex: 1,
                      child: Container(
                        color: Colors.cyan.withOpacity(0.3),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            _toggleInterface();
                          },
                        ),
                      ),
                    ),
                    // Detect right-side tap
                    Flexible(
                      flex: 4,
                      child: Container(
                        color: Colors.red.withOpacity(0.3),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => _goForward(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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

/* /// Parse the given chapter into pages for the PageView.
  String getCurrentPageText({int index, String chapterText}) {
    // How many characters fit on the screen.
    // TODO: Find a way to determine this programmatically, including how it
    // changes when the user changes font size.
    int charactersPerPage = 1500;
    print('index: $index');
    print('currentChapter: $currentChapter');

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
        if (pagedForward) {
          currentChapter += 1;
          var newChapter = getCurrentPageText(
              index: 0, chapterText: book.chapters[currentChapter]);
          return newChapter;
        }
        // });
      }
      return "Finished";
/*       return chapterText.substring(
          (index - 1) * charactersPerPage, chapterText.length); */
    }
  } */

/*   List<Widget> _buildPages() {
    List<Widget> pageList = [];
    book.chapters[5].pages.forEach((page) {
      var newPage = GestureDetector(
        child: page,
        onPanUpdate: (details) {
          if (details.delta.dx > 0)
            print("Dragging in +X direction");
          else
            print("Dragging in -X direction");

          if (details.delta.dy > 0)
            print("Dragging in +Y direction");
          else
            print("Dragging in -Y direction");
        },
      );
      pageList.add(newPage);
    });
    return pageList;
  } */

/*   void _nextPage() {
    // print('Next page');
    // currentChapter++;
    // print('currentChapter: $currentChapter');
    if (currentPage < book.chapters[currentChapter].pages.length - 1) {
      _pageController.nextPage(
          duration: Duration(seconds: 1), curve: Curves.ease);
      setState(() {
        currentPage++;
      });
    } else if (currentChapter < book.chapters.length - 1) {
      setState(() {
        currentChapter++;
      });
    }
  } */

// ),
// Detect swipes
/* GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  /* onPanUpdate: (details) {
                    if (details.delta.dx > 0) {
                      // Dragging in +X direction (swipe left).
                      _pageController.previousPage(
                          duration: Duration(seconds: 1), curve: Curves.ease);
                    } else {
                      // Dragging in -X direction (swipe right).
                      _nextPage();
                    }
                    // How to detect verticle swipes
                    /* if (details.delta.dy > 0)
                      print("Dragging in +Y direction");
                    else
                      print("Dragging in -Y direction"); */
                  }, */
                  /* onHorizontalDragUpdate: (details) {
                    // print(details.primaryDelta);
                    if (details.primaryDelta > 0) {
                      // Dragging in +X direction (swipe left).
                      _pageController.previousPage(
                          duration: Duration(seconds: 1), curve: Curves.ease);
                    } else {
                      // Dragging in -X direction (swipe right).
                      _nextPage();
                    }
                  }, */
                  child: 
                ), */

/*           GestureDetector(
            onPanUpdate: (details) {
              if (details.delta.dx > 0)
                print("Dragging in +X direction");
              else
                print("Dragging in -X direction");

              if (details.delta.dy > 0)
                print("Dragging in +Y direction");
              else
                print("Dragging in -Y direction");
            },
            child: 

          ); */

/*           return PageView.builder(
            physics: ScrollPhysics(),
            controller: _pageController,
            onPageChanged: (int page) {
              // Page variable is the new page and will change before the
              // _pageController fully reaches the full, rounded int value.
              // True if the page moved forwards,
              // false if the page moved backwards.
              pagedForward = page > _pageController.page;
              _pageController.addListener(() { })
              print(
                  'book.chapters[currentChapter].pages.length: ${book.chapters[currentChapter].pages.length}');
              print('currentChapter: $currentChapter');
              print('currentPage: $currentPage');
              if (pagedForward) {
                // If we are not finished the chapter, move to next page.
                if (currentPage <
                    (book.chapters[currentChapter].pages.length - 1)) {
                  currentPage++;
                } else if (currentChapter < (book.chapters.length - 1)) {
                  // If we are finished the chapter but not the book,
                  // move to next chapter.
                  currentPage = 0;
                  currentChapter++;
                }
              }

              if (!pagedForward) {
                // If we are past the first page, go back a page.
                if (currentPage > 0) {
                  currentPage--;
                }
                // If we are on the first page of a chapter, go to last
                // page of the previous chapter.
                if (currentChapter > 0 && currentPage == 0) {
                  currentChapter--;
                  currentPage = book.chapters[currentChapter].pages.length;
                }
              }
            },
            itemBuilder: (context, index) {
              return Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 25.0, color: Colors.grey[300]),
                    text: book.chapters[currentChapter].pages[currentPage],
                    /* getCurrentPageText(
                          index: index,
                          chapterText: book.chapters[currentChapter]
                              [currentPage]) */
                  ),
                  textAlign: TextAlign.start,
                  textScaleFactor: 1.0,
                  textDirection: TextDirection.ltr,
                ),
              );
            },
          ); */
