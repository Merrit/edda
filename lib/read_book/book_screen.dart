import 'package:edda/read_book/book.dart';
import 'package:flutter/material.dart';

import 'package:edda/read_book/ui/components/tap_detector.dart';

class BookScreen extends StatefulWidget {
  static final String id = 'book_screen';
  final Book book;

  BookScreen({@required this.book});

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  /// The book object with all its information and actions.
  Book book;

  // TODO: Currently this is only used to let us know the chapters are
  // available so the FutureBuilder can proceed. Better way?
  Future chapters;

  int currentChapter = 0;
  int currentPage = 0;

  /// Allow us to hide/show the interface elements beyond the page text.
  ///
  /// Header bar, settings button, progress bar, back button, etc.
  bool showInterface = true;

  /// The controller allows us to instruct PageView to change pages.
  ///
  /// Necessary because we use a GestureDetector to handle taps, as well as to
  /// know when to move chapter forward / backward which loads a new list.
  PageController _pageController;

  // TODO: These can't be hardcoded!
  /// Bools keep track of our position so we know if we need
  /// to switch chapter, book has finished, etc.
  bool hasReachedChapterStart = true;
  bool hasReachedChapterEnd = false;
  bool hasReachedBookStart;
  bool hasReachedBookEnd = false;

  /// Settings for the page turn animation.
  Duration pageTurnDuration = Duration(milliseconds: 500);
  Curve pageTurnCurve = Curves.linearToEaseOut;

  @override
  void initState() {
    super.initState();
    book = widget.book;
    // Instantiate a PageController to manipulate the PageView.
    _pageController = PageController();
    // Start loading the book text.
    _getChapters();
  }

  /// Load the book text with an async process.
  ///
  /// When this completes the FutureBuilder will display the book.
  void _getChapters() {
    chapters = book.getChapters();
  }

  /// Check where we are in the book.
  ///
  /// Did we load the first page of the first chapter, but it is only one page?
  /// We will need to move to next chapter on tap.
  ///
  /// If there was a saved reading position, how does that relate to what
  /// _goForward() or _goBack() will need to do?
  void _checkPosition() {
    // TODO: This will need to be checked for the position if a saved position
    // was loaded from previous instance.
    if (book.chapters[currentChapter].pages.length == 1) {
      hasReachedChapterEnd = true;
    }
    if (book.chapters.length == 1 && hasReachedChapterEnd) {
      hasReachedBookEnd = true;
    }

    if (currentChapter == 0 && currentPage == 0) hasReachedBookStart = true;
  }

  /// Allow us to hide/show the interface elements beyond the page text.
  ///
  /// Toggled by tapping / clicking the center of the book.
  /// Header bar, settings button, progress bar, back button, etc.
  void _toggleInterface() {
    setState(() {
      showInterface = !showInterface;
    });
  }

  /// Page forwards.
  void _goForward() {
    if (hasReachedChapterEnd) {
      // Check for the end of the book.
      if (hasReachedBookEnd) {
        // Do not move forward.
        // TODO: Perhaps add a custom finished book page?
      } else {
        // Switch to first page of next chapter.
        hasReachedChapterEnd = false;
        hasReachedChapterStart = true;
        currentPage = 0; // We want page 0 of the next chapter.
        _pageController.jumpToPage(0);
        setState(() {
          currentChapter++;
        });
      }
    } else {
      // Move forwards one page.
      _pageController.nextPage(
          duration: pageTurnDuration, curve: pageTurnCurve);
      currentPage++;
    }
  }

  /// Page backwards.
  void _goBack() {
    if (hasReachedChapterStart) {
      if (hasReachedBookStart) {
        // Do not try to move beyond the start of the book.
      } else {
        // Move to last page of previous chapter.
        hasReachedChapterStart = false;
        hasReachedChapterEnd = true;
        var previousChapter = currentChapter - 1;
        currentPage = book.chapters[previousChapter].pages.length;
        _pageController.jumpToPage(currentPage);
        setState(() {
          currentChapter--;
        });
      }
    } else {
      // Move one page backwards.
      _pageController.previousPage(
          duration: pageTurnDuration, curve: pageTurnCurve);
      currentPage--;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showInterface ? _buildAppBar() : null,
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

  AppBar _buildAppBar() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          // Debugging
        },
        child: Text(book.title),
      ),
    );
  }

  Widget bookPageView() {
    return SafeArea(
      child: Container(
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
                  // Set bools so we know when to change the chapter.
                  onPageChanged: (index) {
                    // TODO: Check for book start/end
                    if (index + 1 ==
                        book.chapters[currentChapter].pages.length) {
                      hasReachedChapterEnd = true;
                      if (currentChapter + 1 == book.chapters.length) {
                        hasReachedBookEnd = true;
                      }
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
              // GestureDetectors for Back, Toggle Interface, and Forward taps.
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
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
