// Standard Library
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

// Edda Packages
import 'package:edda/read_book/epub.dart';

import 'package:epub/epub.dart';

class Book {
  final String filePath;
  final String fileType;
  Epub epub; // Handle of the epub, cbz, etc.
  String title = '';
  String author = '';
  String series = '';
  int publicationDate;
  String description = '';
  MemoryImage coverImage;

  Book({@required this.filePath, @required this.fileType});

  Future<void> loadBook() async {
    switch (fileType) {
      case '.epub':
        await _loadEpub();
    }
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
        coverImageBytes = await _getEpubCoverImage();
    }
    return coverImageBytes;
  }

  _loadEpub() async {
    epub = Epub(filePath: filePath);
    await epub.loadEpub();
    title = epub.title;
    author = epub.author;
  }

  _getEpubCoverImage() async {
    var coverImageBytes = await epub.getCoverImage();
    // Return bytes for compute()
    return coverImageBytes;
  }

  getMetadata() {
    var metadata = epub.epub.Schema.Package.Metadata;
    description = metadata.Description ?? '';
    // print(this.description);
  }

  getEpubChapters() async {
    List<EpubChapterRef> chapters = await epub.getChapters();
    var test = await chapters[0].readHtmlContent();
    print(test);
  }
}
