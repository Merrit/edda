// Standard Library
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

// Edda Packages
import 'package:edda/read_book/epub.dart';

class Book {
  final String filePath;
  final String fileType;
  dynamic handle; // Handle of the epub, cbz, etc.
  String title = '';
  String author = '';
  String series = '';
  int publicationDate;
  var coverImage;

  Book({@required this.filePath, @required this.fileType});

  Future<void> loadBook() async {
    switch (fileType) {
      case '.epub':
        await _loadEpub();
    }
  }

  Future getCoverImage() async {
    switch (fileType) {
      case '.epub':
        await _getEpubCoverImage();
    }
    return coverImage;
  }

  _loadEpub() async {
    handle = Epub(filePath: filePath);
    await handle.loadEpub();
    title = handle.title;
    author = handle.author;
  }

  _getEpubCoverImage() async {
    coverImage = await handle.getCoverImage();
  }
}
