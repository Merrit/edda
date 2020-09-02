import 'package:edda/helpers/check_file_type.dart';
import 'package:epub/epub.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:image/image.dart' as image;

class Book {
  final filePath;
  final fileType;
  var data;
  String title = '';
  String author = '';
  String series = '';
  int publicationDate;
  // List<int> defaultCoverImage;
  List<int> coverImage;
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
    var epubFile = File(filePath);
    List<int> bytes = await epubFile.readAsBytes();

    // Opens a book and reads all of its content into memory
    EpubBook epubBook = await EpubReader.readBook(bytes);

    // COMMON PROPERTIES

    // Book's title
    title = epubBook.Title;

    // Book's authors (comma separated list)
    author = epubBook.Author;

    // Book's authors (list of authors names)
    // List<String> authors = epubBook.AuthorList;

    // Book's cover image (null if there is no cover)
    // List<int> defaultCover = File('assets/cover.webp').readAsBytesSync();
    coverImage = (epubBook.CoverImage != null)
        ? image.encodePng(epubBook.CoverImage)
        : getDefaultCoverImage();
    // print('coverImage: $coverImage');
    // print('defaultCover: $defaultCover');
  }

  List<int> getDefaultCoverImage() {
    return File('assets/cover.webp').readAsBytesSync();
  }
}
