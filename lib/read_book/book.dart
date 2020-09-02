import 'package:edda/helpers/check_file_type.dart';
import 'package:epub/epub.dart';
import 'package:meta/meta.dart';

class Book {
  final filePath;
  final fileType;
  var data;
  String title;
  String author;
  String series;
  int publicationDate;
  var coverImage;
  var chapters;
  var pages;
  Map<String, dynamic> metadata;

  Book({@required this.filePath}) : this.fileType = checkFileType(filePath);

  void getBookData() {
    data = Epub(filePath: filePath);
    metadata = data.metadata;
    title = (metadata['title'] != null) ? metadata['title'] : '';
    author = (metadata['author'] != null) ? metadata['author'] : '';
  }
}
