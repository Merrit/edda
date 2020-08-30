import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:meta/meta.dart';

// Third Party Packages
import 'package:xml/xml.dart';

class Book {
  final filePath;
  // final book;

  Book({@required this.filePath});
  // book =

}

dynamic readBookFile(String filePath) {
  var bytes;
  // Read file from disk
  try {
    bytes = File(filePath).readAsBytesSync();
  } catch (e) {
    print('Error reading file: $e');
  }
  // Decode zipped file.
  // .cbz and .epub should be unencrypted zip files.
  var archive = ZipDecoder().decodeBytes(bytes);
  var result;
  archive.forEach((archiveFile) {
    var content;
    if (archiveFile.name == 'OPS/main0.xml') {
      content = archiveFile.content;
      var contentAsXml = XmlDocument.parse(utf8.decode(content));
      print(contentAsXml.findElements('title'));
      var textual = contentAsXml.descendants
          .where((node) => node is XmlText && !node.text.trim().isEmpty)
          .join('\n');
      print(textual);
      result = textual;
    }
  });
  return result;
}
