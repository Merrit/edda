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
  int currentPage = 0;
  bool showInterface = true;
  PageController _pageController;
  // TODO: These can't be hardcoded!
  bool hasReachedChapterStart = true;
  bool hasReachedChapterEnd = false;
  Duration pageTurnDuration = Duration(milliseconds: 100);
  Curve pageTurnCurve = Curves.ease;

  @override
  void initState() {
    super.initState();
    book = widget.book;
    _pageController = PageController();
    // _loadBook();
    _getChapters();
  }

  void _getChapters() {
    chapters = book.getChapters();
  }

  void _checkPosition() {
    // TODO: This will need to be checked for the position if a saved position
    // was loaded from previous instance.
    if (book.chapters[currentChapter].pages.length == 1) {
      hasReachedChapterEnd = true;
    }
  }

  void _toggleInterface() {
    setState(() {
      showInterface = !showInterface;
    });
  }

  void _goForward() {
    // if (currentPage != )

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
          _checkPosition();
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
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
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
                ),
                Row(
                  children: [
                    // Detect left-side tap
                    Flexible(
                      flex: 4,
                      child: Container(
                        // color: Colors.lightGreen.withOpacity(0.3),
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
                        // color: Colors.cyan.withOpacity(0.3),
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
                        // color: Colors.red.withOpacity(0.3),
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
