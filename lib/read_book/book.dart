// Standard Library
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

// Edda Packages
import 'package:edda/read_book/epub.dart';
import 'package:epub/epub.dart';
import 'package:edda/helpers/capitalize.dart';

class Book {
  final String filePath;
  final String fileType;
  String fileTypeNice; // File type with Capital letter and no '.', eg: Epub
  Epub epub; // Handle of an epub file.
  String title = '';
  String author = '';
  String series = '';
  String publicationDate;
  String genre;
  String language;
  String description = '';
  MemoryImage coverImage;

  Book({@required this.filePath, @required this.fileType})
      : fileTypeNice = fileType.replaceAll('.', '').inCaps;

  Future<void> loadBook() async {
    switch (fileType) {
      case '.epub':
        await _loadEpub();
    }
  }

  _loadEpub() async {
    epub = Epub(filePath: filePath);
    await epub.loadEpub();
    title = epub.title;
    author = epub.author;
  }

  /// Get cover image depending on file type.
  ///
  /// Return is a List<int> because that is what compute() can handle.
  ///
  /// Return is dynamic because setting specific type caused compute() to throw
  /// TypeError.
  Future getCoverImage() async {
    var coverImageBytes;
    switch (fileType) {
      case '.epub':
        coverImageBytes = await epub.getCoverImage();
    }
    return coverImageBytes;
  }

  getMetadata() {
    switch (fileType) {
      case '.epub':
        _getEpubMetadata();
    }
  }

  _getEpubMetadata() {
    epub.getMetadata();
    publicationDate = epub.publicationDate ?? '-';
    genre = epub.genre ?? '-';
    language = epub.language ?? '-';
    description = epub.description ?? '-';
  }

/*   getEpubChapters() async {
    List<EpubChapterRef> chapters = await epub.getChapters();
    var test = await chapters[0].readHtmlContent();
    print(test);
  } */
}
