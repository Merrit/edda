import 'dart:io';
import 'package:meta/meta.dart';
import 'package:epub/epub.dart';

class Epub {
  final String filePath;
  EpubBookRef epub;
  String title;
  String author;

  Epub({@required this.filePath});

  Future<void> loadEpub() async {
    File epubFile = File(filePath);
    List<int> bytes = epubFile.readAsBytesSync();
    // Open epub without immediately reading any content.
    epub = await EpubReader.openBook(bytes);
    title = epub.Title;
    author = epub.Author;
  }

  Image getCoverImage() {
    /* if (bookFile.CoverImage != null) {
      coverImage = bookFile.CoverImage;
    } */
    // : getDefaultCoverImage();
    /* coverImage = (epubBook.CoverImage != null)
        ? image.encodePng(epubBook.CoverImage)
        : getDefaultCoverImage(); */
  }
}

/* -------------------------------------------------------------------------- */
/*                       Self attempt to read epub below                      */
/* -------------------------------------------------------------------------- */

/* // Standard Library
import 'dart:convert';
import 'dart:io';
import 'package:meta/meta.dart';

// Third Party Packages
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';

class Epub {
  final Map<String, dynamic> metadata;
  final String filePath;

  Epub({@required this.filePath}) : this.metadata = loadEpubFile(filePath);
}

// XML
//
// Tag A tag is a markup construct that begins with < and ends with >.
//
// Element An element is a logical document component that either begins with a
// start-tag and ends with a matching end-tag or consists only of an
// empty-element tag. The characters between the start-tag and end-tag, if any,
// are the element's content, and may contain markup, including other elements,
// which are called child elements. An example is <greeting>Hello,
// world!</greeting>.
//
// Attribute An attribute is a markup construct consisting of a name–value pair
// that exists within a start-tag. An example is <img src="madonna.jpg"
// alt="Madonna" />, where the names of the attributes are "src" and "alt", and
// their values are "madonna.jpg" and "Madonna" respectively.

Map<String, dynamic> loadEpubFile(String filePath) {
  // Map<String, dynamic> metadata;
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
  // Find & parse container.xml
  ArchiveFile container = archive.findFile('META-INF/container.xml');
  XmlDocument containerXml = XmlDocument.parse(utf8.decode(container.content));
  // Find & parse .opf file.
  String opfFilePath = findOpf(containerXml);
  ArchiveFile opfFile = archive.findFile(opfFilePath);
  XmlDocument opfFileXml = XmlDocument.parse(utf8.decode(opfFile.content));
  // Populate metadata map from the .opf file.
  Map<String, dynamic> metadata = parseOpf(opfFileXml);
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

Map<String, dynamic> parseOpf(XmlDocument opfFileXml) {
  Map<String, dynamic> fields = Map();
  // Get Title
  Iterable<XmlElement> titleXml = opfFileXml.findAllElements('dc:title');
  if (titleXml.length == 1) {
    fields['title'] = titleXml.first.innerText;
  }
  // Get Author
  Iterable<XmlElement> authorXml = opfFileXml.findAllElements('dc:creator');
  if (titleXml.length == 1) {
    fields['author'] = authorXml.first.getAttribute('opf:file-as');
  }
  // Get Cover
  var coverXml = opfFileXml.findAllElements('meta');
  var meta = coverXml.first.getAttribute('content');
  var cover = opfFileXml.findAllElements('cover');
  // var test = opfFileXml.findAllElements('item');
  // var test2 = test.firstWhere((element) => element.attributes.contains(meta));
  print(cover);
  // cover.forEach((element) {
  //   if (element.name.toString() == 'item' && element.)
  // });

  return fields;
}
 */
