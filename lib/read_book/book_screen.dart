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

  /// Page forwards.
  void _goForward() {
    // TODO: Add end of book check
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

  /// Page backwards.
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
      appBar: showInterface ? AppBar(title: Text(book.title)) : null,
      body: FutureBuilder(
        // Once the chapters are loaded from disk we can display our content.
        future: chapters,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading text'));
          }
          // Book data has loaded, proceed to display content.
          _checkPosition();
          return bookPageView();
        },
      ),
    );
  }

  Container bookPageView() {
    return Container(
      // Stack the GestureDetectors on top of the pages.
      child: Stack(
        children: [
          // GestureDetector works better than the built-in PageView
          // gestures because we know when a swipe was attempted at the
          // beginning and / or end of a chapter, so we can switch out to a
          // new chapter.
          GestureDetector(
            onHorizontalDragEnd: (dragEndDetails) {
              // Use on___DragEnd so we only get one event per swipe.
              if (dragEndDetails.primaryVelocity < 0) {
                _goForward();
              } else if (dragEndDetails.primaryVelocity > 0) {
                _goBack();
              }
            },
            // Padding so the text doesn't hit right against the screen
            // edges. In books this would be considered the "margin".
            // TODO: Make this padding a configurable setting.
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: PageView(
                controller: _pageController,
                children: book.chapters[currentChapter].pages,
                // Disable PageView gestures.
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  if (index + 1 == book.chapters[currentChapter].pages.length) {
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
          // GestureDetectors for Back, Toggle Interface, and Forward taps.
          Row(
            children: [
              // Detect left-side tap
              TapDetector(flexAmount: 1, tapCallback: _goBack),
              // Detect center tap
              TapDetector(flexAmount: 1, tapCallback: _toggleInterface),
              // Detect right-side tap
              TapDetector(flexAmount: 1, tapCallback: _goForward),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

/// A widget that is transparent and contains
/// a gesture detector and flex properties.
class TapDetector extends StatelessWidget {
  /// What gets done after a tap event.
  final Function tapCallback;

  /// If there is no Flex amount it will cause errors if under a Column / Row.
  final int flexAmount;

  /// The container background color (optional). Example:
  /// ```dart
  /// Colors.lightGreen.withOpacity(0.3)
  /// ```
  /// would give a semi-transparent color so you can position the [TapDetector].
  final color;

  const TapDetector({@required this.flexAmount, this.tapCallback, this.color});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flexAmount,
      child: Container(
        color: color,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: tapCallback,
        ),
      ),
    );
  }
}
