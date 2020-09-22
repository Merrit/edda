// Standard Library
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

// Edda Packages
import 'package:edda/read_book/ui/page_text.dart';

/// A class that represents a single book chapter with its text as a list of
/// Widgets in [pages] for PageView to display.
///
/// When instantiated the text will be broken into
/// chunks that can fit onto a single PageView.
class Chapter {
  /// The characters that can fit on a page depends on screen size & font size.
  // TODO: Find a way to determine this programmatically, including how it
  // changes when the user changes font size, line height, rotates, etc.
  static final int charactersPerPage = Platform.isAndroid ? 500 : 1000;

  /// The entire chapter text given to Chapter as a string.
  // TODO: This should be quite different when we support proper
  // HTML display rather than raw text.
  final String rawText;

  /// The list of pages as Widgets to feed the PageView for this chapter.
  ///
  /// Each widget in the list will be a PageText widget with
  /// a property [pageText] holding the page's text as a String.
  List<PageText> pages = [];

  Chapter({this.rawText}) : pages = _createPages(rawText: rawText);

  /// Parse the chapter text into pages to feed the PageView.
  static List<PageText> _createPages({@required String rawText}) {
    List<PageText> seperatePages = [];

    // If the entire chapter fits a single page, just return that.
    if (rawText.length <= charactersPerPage) {
      seperatePages.add(PageText(pageText: rawText));
      return seperatePages;
    } else {
      // Split the text into page-sized chunks.
      for (var i = 0; i < rawText.length; i += charactersPerPage) {
        if (i + charactersPerPage < rawText.length) {
          seperatePages.add(
              PageText(pageText: rawText.substring(i, i + charactersPerPage)));
        } else {
          seperatePages
              .add(PageText(pageText: rawText.substring(i, rawText.length)));
          break;
        }
      }

      return seperatePages;
    }
  }
}
