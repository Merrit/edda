import 'package:edda/helpers/check_file_type.dart';
import 'package:meta/meta.dart';

class Book {
  final filePath;
  final fileType;
  final book;

  Book({@required this.filePath})
      : fileType = checkFileType(filePath),
        book = 'epub';
}
