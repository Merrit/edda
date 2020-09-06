import 'package:edda/helpers/check_file_type.dart';
import 'package:epub/epub.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:flutter/material.dart' as flutter;
import 'package:image/image.dart' as image;
// import 'package:image/image.dart' hide Image;
import 'package:edda/read_book/epub.dart';

class Book {
  final String filePath;
  final String fileType;
  EpubBook bookContent;
  var data;
  String title = '';
  String author = '';
  String series = '';
  int publicationDate;
  flutter.Image coverImage;
  var chapters;
  var pages;
  Map<String, dynamic> metadata;

  Book({@required this.filePath, @required this.fileType});

  Future<void> loadBook() async {
    switch (fileType) {
      case '.epub':
        Epub epub = Epub(filePath: filePath);
        await epub.loadEpub();
        title = epub.title;
        author = epub.author;
    }
  }
}
