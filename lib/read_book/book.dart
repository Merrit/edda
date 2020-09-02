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
  Future<String> title;
  Future<String> author;
  String series = '';
  int publicationDate;
  // List<int> defaultCoverImage;
  Future<flutter.Image> coverImage;
  var chapters;
  var pages;
  Map<String, dynamic> metadata;

  Book({@required this.filePath}) : this.fileType = checkFileType(filePath);

  Future<void> getBookData() async {
    // data = Epub(filePath: filePath);
    // metadata = data.metadata;
    // title = (metadata['title'] != null) ? metadata['title'] : '';
    // author = (metadata['author'] != null) ? metadata['author'] : '';

    //Get the epub into memory somehow
    File epubFile = File(filePath);
    List<int> bytes = await epubFile.readAsBytes();

    // Opens a book and reads all of its content into memory
    var bookFile = await EpubReader.readBook(bytes).then((value) => () {
          // Book's title
          title = getTitle();

          // Book's authors (comma separated list)
          author = getAuthor();

          // Book's authors (list of authors names)
          // List<String> authors = epubBook.AuthorList;

          // Book's cover image (null if there is no cover)
          // List<int> defaultCover = File('assets/cover.webp').readAsBytesSync();
          coverImage = getCoverImage();
        });

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

  Future<String> getTitle() {
    var title = bookFile.title;
    return title;
  }

  Future<String> getAuthor() {
    var author = bookFile.author;
    return author;
  }

  Future<flutter.Image> getCoverImage() {
    var cover = bookFile.CoverImage;
    return cover;
  }

  /* List<int> getDefaultCoverImage() {
    return File('assets/cover.webp').readAsBytesSync();
  } */
}
