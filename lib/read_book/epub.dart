// Standard Library
import 'dart:io';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:meta/meta.dart';

// Third Party Packages
import 'package:epub/epub.dart';
import 'package:image/image.dart';

/// A class that represents a single epub book file with
/// all of its related information and actions.
class Epub {
  /// The absolute file path.
  final String filePath;

  /// The handle on the epub after opening it with the epub package.
  EpubBookRef epub;

  String title;
  String author;
  String series;
  String genre;
  String language;
  String publicationDate;
  String description;

  List<EpubChapterRef> chaptersObjects = [];

  Epub({@required this.filePath});

  /// Loads the epub's basic metadata and a handle for future operations.
  Future<void> loadEpub() async {
    File epubFile = File(filePath);
    List<int> bytes = epubFile.readAsBytesSync();
    // Open epub without immediately reading any content.
    epub = await EpubReader.openBook(bytes);
    title = epub.Title;
    author = epub.Author;
  }

  Future getCoverImage() async {
    Image epubCoverImage = await epub.readCover();
    var coverImage = encodePng(epubCoverImage);
    return coverImage;
  }

  // TODO: This doesn't seem to load additional information from disk, only
  // access what was already loaded by loadEpub(). Test if we can just move this
  // into the inital loadEpub() to simplify and streamline.
  void getMetadata() {
    var metadata = epub.Schema.Package.Metadata;

    // TODO: Series info?! Check epub repo.

    // A LIST of dates??
    // For now grab the first and return that.
    if (metadata.Dates.length > 0) {
      publicationDate = metadata.Dates[0].Date;
      // TODO: This is sometimes returning a date AND time, we only want a date.
      // Either add parsing to strip the time or submit pull request to epub.
    }

    // A list of genres
    if (metadata.Subjects.length > 0) {
      genre = metadata.Subjects.join(', ');
      // TODO: Sometimes returns an absurd number of genres.
      // Maybe do something like a for loop that limits to ~5 items, or just
      // the text widget be expandable. Or get them all, and the book info
      // screen can choose to display a certain amount of them.
    }

    // Language is specified in various ways, eg: 'en-CA' and 'en' both mean
    // 'English'.
    // Would a book ever be in multiple languages? For now assume 1.
    if (metadata.Languages.length == 1) {
      String languageCode = metadata.Languages[0];
      switch (languageCode) {
        case 'en-CA':
          language = 'English';
          break;
        case 'en':
          language = 'English';
          break;
        // TODO: Add parsing for other languages and codes.
      }
    }

    if (metadata.Description != null) {
      // Strip away html elements.
      // Should be able to use flutter_html package to properly display this
      // type of content once this pull request is accepted to epub:
      // https://github.com/orthros/dart-epub/pull/75
      Document document = parse(metadata.Description);
      description = parse(document.body.text).documentElement.text;
    }
  }

  /// Loads ALL of the chapters into memory at once.
  ///
  /// For smaller books not a problem, but for larger books this could be slow.
  /// There was an issue in the epub repo asking about the ability
  /// to load chapters on demand.
  Future getChapters() async {
    /// The raw chapter data from the epub.
    List<String> chapters = [];

    /// A custom type from the epub package.
    chaptersObjects = await epub.getChapters();

    /// Extract the data from the custom object type..
    await Future.forEach(chaptersObjects, (element) async {
      // As HTML..
      var chapterHTML =
          await element.epubTextContentFileRef.readContentAsText();
      // As string without HTML elements.
      Document intermediateStage = parse(chapterHTML);
      var chapter = parse(intermediateStage.body.text).documentElement.text;
      chapters.add(chapter);
    });

    return chapters;
  }
}
