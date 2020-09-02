import 'package:edda/library/cover_tile.dart';
import 'package:edda/library/library.dart';

Future<List<CoverTile>> getBookTiles() async {
  Library library = Library();
  await library.buildBookTiles();
  List<CoverTile> bookTiles = library.coverTilesList;
  return bookTiles;
}
