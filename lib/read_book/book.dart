import 'package:edda/helpers/check_file_type.dart';
import 'package:epub/epub.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:flutter/material.dart' as flutter;
import 'package:image/image.dart' as image;
// import 'package:image/image.dart' hide Image;

class Book {
  final filePath;
  final fileType;
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

  Book({@required this.filePath}) : this.fileType = checkFileType(filePath);

  Future<void> loadBook() async {
    //Get the epub into memory somehow
    File epubFile = File(filePath);
    List<int> bytes = epubFile.readAsBytesSync();

    // Opens a book and reads all of its content into memory
    bookContent = await EpubReader.readBook(bytes);

    // Book's title
    title = bookContent.Title;

    // Book's authors (comma separated list)
    author = bookContent.Author;

    // Book's cover image (null if there is no cover)
    // var epubCoverImage = bookContent.CoverImage;
    // var epubCoverBytes = epubCoverImage.getBytes();
    coverImage = flutter.Image.memory(image.encodePng(bookContent.CoverImage));

    // COMMON PROPERTIES

    /* if (bookFile.CoverImage != null) {
      coverImage = bookFile.CoverImage;
    } */
    // : getDefaultCoverImage();
    /* coverImage = (epubBook.CoverImage != null)
        ? image.encodePng(epubBook.CoverImage)
        : getDefaultCoverImage(); */
  }

  // String getTitle() {
  //   // Future<String> title = Future.value(bookFile.Title);
  //   title = bookFile.Title;
  //   return title;
  // }

  // Future<String> getAuthor() {
  //   author = bookFile.author;
  //   return author;
  // }

  // Future<flutter.Image> getCoverImage() {
  //   // var coverImageData = bookFile.CoverImage;
  //   coverImage = bookFile.CoverImage;
  //   return coverImage;
  // }

  /* List<int> getDefaultCoverImage() {
    return File('assets/cover.webp').readAsBytesSync();
  } */
}
