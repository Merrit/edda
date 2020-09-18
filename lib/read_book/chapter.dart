import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class Chapter {
  // Depends on screen size & font size.
  // TODO: Find a way to determine this programmatically, including how it
  // changes when the user changes font size.
  static const int charactersPerPage = 1500;

  final String rawText;
  List<Widget> pages = [];

  Chapter({this.rawText}) : pages = _createPages(rawText: rawText);

  /// Parse the chapter text into pages to feed the PageView.
  static List<Widget> _createPages({@required String rawText}) {
    List<Widget> seperatePages = [];
/*     int index = 0;
    bool shouldContinue = true; */

    // If the entire chapter fits a single page, just return that.
    if (rawText.length <= charactersPerPage) {
      seperatePages.add(Page(pageText: rawText));
      return seperatePages;
    } else {
      // Split the text into page-sized chunks.
      for (var i = 0; i < rawText.length; i += charactersPerPage) {
        if (i + charactersPerPage < rawText.length) {
          seperatePages
              .add(Page(pageText: rawText.substring(i, i + charactersPerPage)));
        } else {
          seperatePages
              .add(Page(pageText: rawText.substring(i, rawText.length)));
          break;
        }
      }

      return seperatePages;
    }
  }
}

class Page extends StatelessWidget {
  final String pageText;

  const Page({
    @required this.pageText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 25.0, color: Colors.grey[300]),
          text: pageText,
        ),
        textAlign: TextAlign.start,
        textScaleFactor: 1.0,
        textDirection: TextDirection.ltr,
      ),
    );
  }
}

/*   static List<String> _createPages({@required String rawText}) {
    List<String> seperatePages = [];
/*     int index = 0;
    bool shouldContinue = true; */

    // If the entire chapter fits a single page, just return that.
    if (rawText.length <= charactersPerPage) {
      seperatePages.add(rawText);
      return seperatePages;
    } else {
      // Split the text into page-sized chunks.
      for (var i = 0; i < rawText.length; i += charactersPerPage) {
        if (i + charactersPerPage < rawText.length) {
          seperatePages.add(rawText.substring(i, i + charactersPerPage));
        } else {
          seperatePages.add(rawText.substring(i, rawText.length));
          break;
        }
      }

      return seperatePages;
    }
  } */

/*     // index >= rawText.length
    while (shouldContinue) {
      // If the entire chapter fits a single page, just return that.
      if (index == 0 && rawText.length <= charactersPerPage) {
        seperatePages.add(rawText);
        // index = rawText.length + 1;
        shouldContinue = false;
      } else if (index == 0) {
        // Add the first page of text.
        seperatePages.add(rawText.substring(index, charactersPerPage));
        index = charactersPerPage;
      } else if (index + charactersPerPage <= rawText.length) {
        // Add substrings of the chapter in page sized increments to the list.
        seperatePages.add(rawText.substring(index, index + charactersPerPage));
        index = index + charactersPerPage;
      } else {
        // At this point the remaining text should fit a single page.
        seperatePages.add(rawText.substring(index, rawText.length));
        // index = rawText.length + 1;
        shouldContinue = false;
        // print('seperatePages.length: ${seperatePages.length}');
      }
    }
    return seperatePages; */

/* /// Parse the given chapter into pages for the PageView.
String getCurrentPageText({int index, String chapterText}) {
  // How many characters fit on the screen.
  // TODO: Find a way to determine this programmatically, including how it
  // changes when the user changes font size.
  int charactersPerPage = 1500;

  if ((index == 0) && (chapterText.length < charactersPerPage))
    return chapterText;

  // If our position hasn't gone past the length of the chapter..
  if (index * charactersPerPage < chapterText.length) {
    // On page one, return a full page of text.
    if (index == 0) {
      return chapterText.substring(0, charactersPerPage);
    }
    // On subsequent pages, return the next full page of text.
    return chapterText.substring(index * charactersPerPage, chapterText.length);
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
}
 */
