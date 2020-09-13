// Standard Library
import 'package:edda/library/book_info_screen.dart';
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
  AssetImage coverImageDefault = AssetImage('assets/cover.webp');
  var coverImageFuture; // Using specific types was causing TypeError.
  // MemoryImage coverImage;

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

    coverImageFuture = compute(coverTileGetCoverImage, book);
    // Find a way to gather metadata that won't delay the UI. compute()??
    // DOES it delay the UI as is?
    book.getMetadata();
  }

/*   void _showBottomSheet({@required Book book}) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.8,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Card(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CoverImage(coverImage: book.coverImage)),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(book.title),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  } */

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: InkWell(
            onTap: () {
              if (book.coverImage != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookInfoScreen(book: book),
                  ),
                );
              }
            },
            child: FutureBuilder(
              future: coverImageFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData == false) {
                  return CoverImage(
                    coverImage: coverImageDefault,
                    hasProgressIndicator: true,
                  );
                }
                book.coverImage = MemoryImage(snapshot.data);
                return Hero(
                    tag: book.hashCode,
                    child: CoverImage(coverImage: book.coverImage));
              },
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(fontSize: 18),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5),
        Text(
          author,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// Compute requires this to be a top-level function outside any class.
// Compute is required to prevent jank / hang of the UI.
// Returns the cover image as a Future<List<int>> because compute can only
// accept a few basic types.
Future coverTileGetCoverImage(Book book) async {
  var cover = book.getCoverImage();
  return cover;
}
