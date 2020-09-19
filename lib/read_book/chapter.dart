import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:edda/read_book/ui/page_text.dart';

class Chapter {
  // Depends on screen size & font size.
  // TODO: Find a way to determine this programmatically, including how it
  // changes when the user changes font size.
  static final int charactersPerPage = Platform.isAndroid ? 500 : 1000;

  final String rawText;
  List<Widget> pages = [];

  Chapter({this.rawText}) : pages = _createPages(rawText: rawText);

  /// Parse the chapter text into pages to feed the PageView.
  static List<Widget> _createPages({@required String rawText}) {
    List<Widget> seperatePages = [];

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
