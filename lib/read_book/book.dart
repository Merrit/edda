// Standard Library
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

// Edda Packages
import 'package:edda/helpers/capitalize.dart';
import 'package:edda/read_book/chapter.dart';
import 'package:edda/read_book/epub.dart';

// Third Party Packages
// ignore: unused_import
import 'package:epub/epub.dart';

/// A class that represents all of the information and actions for a single book.
class Book {
  /// The absolute file path.
  final String filePath;

  /// The file type, eg: .epub, .cbz, .pdf, etc.
  final String fileType;

  /// The file type in human-readable format, eg: Epub, CBZ, PDF, etc.
  String fileTypeNice;

  /// The handle of an epub file. Allows us to invoke further actions.
  Epub epub;

  /// The title of the book.
  String title;

  /// The author(s) of the book.
  String author;

  /// The book series and its number in the series. TODO: Add this.
  String series;

  /// The date the book was published.
  /// Format is year-month-day, for example: 1979-10-12.
  String publicationDate;

  /// The genre(s) the book belongs to.
  String genre;

  // TODO: Should this be English? Native better? Eg, German vs Deutsch?
  /// The language this book is in.
  String language;

  /// The short description of the book.
  String description;

  // TODO: The cover currently gets pulled every time. See if it
  // can be cached so that subsequent loads are faster.
  /// The cover image from the book.
  MemoryImage coverImage;

  /// The chapters of the book as widgets that get passed to the PageView.
  List<Chapter> chapters = [];

  Book({@required this.filePath, @required this.fileType})
      : fileTypeNice = fileType.replaceAll('.', '').inCaps;

  /// Load basic book metadata and handle.
  Future<void> loadBook() async {
    switch (fileType) {
      case '.epub':
        await _loadEpub();
    }
  }

  /// Load basic epub metadata and handle.
  _loadEpub() async {
    epub = Epub(filePath: filePath);
    await epub.loadEpub();
    title = epub.title ?? '-';
    author = epub.author ?? '-';
  }

  // TODO: Can we use isolate instead of compute? Would it be better?
  //
  /// Gets the cover image depending on book type.
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

  /// Load chapter text into memory.
  ///
  /// This would be better if it could load chapters on demand rather
  /// than all at once.
  Future getChapters() async {
    switch (fileType) {
      case '.epub':
        await _getEpubChapters();
        return Future.value('Complete');
    }
  }

  /// Load epub chapter text into memory.
  ///
  /// Currently loads all chapters at once.
  /// Issue on repo to add ability to load on demand instead.
  Future _getEpubChapters() async {
    List<String> chaptersRaw = await epub.getChapters();
    if (chaptersRaw.length > 0) {
      chaptersRaw.forEach((element) {
        var newChapter = Chapter(rawText: element);
        chapters.add(newChapter);
      });
    } else {
      chapters.add(Chapter(rawText: 'Error getting chapter'));
    }
  }
}
