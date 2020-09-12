// Standard Library
import 'package:flutter/material.dart';

// Third Party Packages
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Image Widget for the Cover Tile in the Library.
class CoverImage extends StatelessWidget {
  /// CoverImage should be an AssetImage, MemoryImage, etc.
  final dynamic coverImage;
  final bool hasProgressIndicator;
  final dynamic progressIndicator;

  CoverImage({@required this.coverImage, this.hasProgressIndicator = false})
      : progressIndicator = hasProgressIndicator ? spinkit : null;

  static final spinkit = SpinKitFoldingCube(
    size: 30,
    color: Colors.deepPurple,
  );

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0 / 1.5,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: coverImage,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: kElevationToShadow[8],
        ),
        child: Center(child: progressIndicator),
      ),
    );
  }
}
