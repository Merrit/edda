import 'package:edda/library/cover_tile.dart';
import 'package:edda/library/library.dart';
import 'package:edda/read_book/book.dart';

Future<List<CoverTile>> getBookTiles() async {
  Library library = Library();
  await library.buildBookTiles();
  List<CoverTile> bookTiles = library.coverTilesList;
  return bookTiles;
}

// Book book = Book(filePath: filePath);
// await book.getBookData();

// Future<Book> loadBookData({String filePath}) async {
//   var book = Book(filePath: filePath);
//   await book.loadBook();
//   return book;
// }
