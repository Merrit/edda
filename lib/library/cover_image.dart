import 'package:flutter/material.dart';

/// Image Widget for the Cover Tile in the Library.
class CoverImage extends StatelessWidget {
  final Image coverImage;
  final bool hasProgressIndicator;
  final dynamic progressIndicator;

  CoverImage({@required this.coverImage, this.hasProgressIndicator = false})
      : progressIndicator =
            hasProgressIndicator ? CircularProgressIndicator() : null;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1.5,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: coverImage.image,
        )),
        child: Center(child: progressIndicator),
      ),
    );
  }
}
