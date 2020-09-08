// Standard Library
import 'package:edda/read_book/book_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Edda Packages
import 'package:edda/read_book/book.dart';
import 'package:edda/library/cover_image.dart';

/// Represents one tile in the Library view with title, author and cover art.
class CoverTile extends StatefulWidget {
  final String filePath;
  final String fileType;

  CoverTile({@required this.filePath, @required this.fileType});

  @override
  _CoverTileState createState() => _CoverTileState();
}

class _CoverTileState extends State<CoverTile> {
  Book book;
  String title = '';
  String author = '';
  Image coverImageDefault = Image(image: AssetImage('assets/cover.webp'));
  var coverImage; // Using specific types was causing TypeError.

  @override
  void initState() {
    super.initState();
    _loadBookData(filePath: widget.filePath, fileType: widget.fileType);
  }

  _loadBookData({@required String filePath, @required String fileType}) async {
    book = Book(filePath: filePath, fileType: fileType);
    await book.loadBook();
    setState(() {
      title = book.title;
      author = book.author;
    });

    coverImage = compute(coverTileGetCoverImage, book);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookScreen(book: book),
                ),
              );
            },
            child: Card(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: FutureBuilder(
                  future: coverImage,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData == false) {
                      return CoverImage(
                        coverImage: coverImageDefault,
                        hasProgressIndicator: true,
                      );
                    }
                    return CoverImage(
                        coverImage: Image(image: MemoryImage(snapshot.data)));
                  },
                ),
              ),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(fontSize: 18),
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
        SizedBox(height: 10),
        Text(
          author,
          style: TextStyle(fontSize: 14),
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
      ],
    );
  }
}

/// Compute requires this to be a top-level function outside any class.
/// Compute is required to prevent jank / hang of the UI.
/// Returns the cover image as a Future<List<int>> because compute can only
/// accept a few basic types.
Future coverTileGetCoverImage(Book book) async {
  var cover = book.getCoverImage();
  return cover;
}
