import 'package:path/path.dart' as path;

/// Return the file extension as a String, for example: '.epub'
/// Note that the returned string WILL include the . if one exists.
String checkFileType(dynamic file) {
  String extension = path.extension(file.path);
  return extension;
}