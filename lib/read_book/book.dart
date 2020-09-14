// Standard Library
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

// Edda Packages
import 'package:edda/read_book/epub.dart';
import 'package:epub/epub.dart';
import 'package:edda/helpers/capitalize.dart';

class Book {
  final String filePath; // Absolute file path
  final String fileType; // File type, eg: .epub
  String fileTypeNice; // File type with Capital letter and no '.', eg: Epub
  Epub epub; // Handle of an epub file.
  String title;
  String author;
  String series = '';
  String publicationDate;
  String genre;
  String language;
  String description;
  MemoryImage coverImage;
  List chapters = [];

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
    title = epub.title ?? '-';
    author = epub.author ?? '-';
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

  // TODO: Check if this step is neccessary, as it seems the Epub package
  // already loads this info at the start, and having it immediately would make
  // populating library fields for sorting easier / faster. If so, merge these
  // fields with _loadEpub().
  //
  /// Fetch the remaining metadata like the publication date, genres,
  /// description, etc. We do this seperately to make the initial grab as basic
  /// as possible so the library screen loads quickly.
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

  Future getChapters() async {
    switch (fileType) {
      case '.epub':
        await _getEpubChapters();
        return chapters;
    }
  }

  _getEpubChapters() async {
    chapters = await epub.getChapters();
  }
}
