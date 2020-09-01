// Standard Library
import 'dart:convert';
import 'dart:io';
import 'package:meta/meta.dart';

// Third Party Packages
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:xml/xml.dart';

class Epub {
  final Map<String, dynamic> metadata;
  final String filePath;
  // final String title;
  // final String author;
  // final String series;
  // final int publicationDate;
  // final coverImage;
  // final chapters;
  // final pages;

  Epub({@required this.filePath}) : this.metadata = loadEpubFile(filePath);
}

Map<String, dynamic> loadEpubFile(String filePath) {
  Map<String, dynamic> metadata;
  var bytes;
  // Read file from disk
  try {
    bytes = File(filePath).readAsBytesSync();
  } catch (e) {
    print('Error reading file: $e');
  }
  // Decode zipped file.
  // .cbz and .epub should be unencrypted zip files.
  Archive archive = ZipDecoder().decodeBytes(bytes);
  ArchiveFile container = archive.findFile('META-INF/container.xml');
  XmlDocument containerXml = XmlDocument.parse(utf8.decode(container.content));
  String opfFilePath = findOpf(containerXml);
  ArchiveFile opfFile = archive.findFile(opfFilePath);
  XmlDocument opfFileXml = XmlDocument.parse(utf8.decode(opfFile.content));
  Map<String, dynamic> _opfFields = parseOpf(opfFileXml);
  // metadata['title'] = _opfFields['title'];
  return metadata;
}

String findOpf(XmlDocument containerXml) {
  // The 'rootfile' node should point to a single .opf file.
  // This .opf file should describe the structure of the epub.
  Iterable<XmlElement> rootFileXml = containerXml.findAllElements('rootfile');
  String rootFile;
  // Epub should have only one .opf file.
  if (rootFileXml.length == 1) {
    rootFile = rootFileXml.first.getAttribute('full-path');
  } else {
    // show error dialog
  }
  return rootFile;
}

Map<String, dynamic> parseOpf(XmlDocument opfFileXml) {}
