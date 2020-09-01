import 'dart:io';

import 'package:path/path.dart' as path;

/// Return the file extension as a String, for example: '.epub'
/// Note that the returned string WILL include the . if one exists.
/// Input is either a File() object or a String, for example:
/// 'main.dart' -> '.dart',
/// '/home/user/Dev/main.dart' -> '.dart'
String checkFileType(dynamic file) {
  if (file.runtimeType != String && file.runtimeType != File) {
    return 'Input was neither a File() nor a String';
  }
  String fileType = (file.runtimeType == String)
      ? path.extension(file)
      : path.extension(file.path);
  return fileType;
}
