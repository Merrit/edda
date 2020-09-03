import 'package:edda/helpers/check_file_type.dart';
import 'package:epub/epub.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:flutter/material.dart' as flutter;
// import 'package:image/image.dart' hide Image;

class Book {
  final filePath;
  final fileType;
  var bookFile;
  var data;
  String title;
  String author;
  String series = '';
  int publicationDate;
  // List<int> defaultCoverImage;
  Future<flutter.Image> coverImage;
  var chapters;
  var pages;
  Map<String, dynamic> metadata;

  Book({@required this.filePath}) : this.fileType = checkFileType(filePath);

  Future<void> loadBook() async {
    // data = Epub(filePath: filePath);
    // metadata = data.metadata;
    // title = (metadata['title'] != null) ? metadata['title'] : '';
    // author = (metadata['author'] != null) ? metadata['author'] : '';

    //Get the epub into memory somehow
    File epubFile = File(filePath);
    List<int> bytes = epubFile.readAsBytesSync();

    // Opens a book and reads all of its content into memory
    // bookFile = await EpubReader.readBook(bytes);

    // bookFile = await
    EpubBook bookContent = await EpubReader.readBook(bytes);
    bookFile = bookContent;

    // Book's title
    // title = getTitle();
    // title = bookFile.Title;

    // Book's authors (comma separated list)
    // author = getAuthor();

    // Book's authors (list of authors names)
    // List<String> authors = epubBook.AuthorList;

    // Book's cover image (null if there is no cover)
    // List<int> defaultCover = File('assets/cover.webp').readAsBytesSync();
    // coverImage = getCoverImage();

    // COMMON PROPERTIES

    /* if (bookFile.CoverImage != null) {
      coverImage = bookFile.CoverImage;
    } */
    // : getDefaultCoverImage();
    /* coverImage = (epubBook.CoverImage != null)
        ? image.encodePng(epubBook.CoverImage)
        : getDefaultCoverImage(); */
    // print('coverImage: $coverImage');
    // print('defaultCover: $defaultCover');
  }

  String getTitle() {
    // Future<String> title = Future.value(bookFile.Title);
    title = bookFile.Title;
    return title;
  }

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
