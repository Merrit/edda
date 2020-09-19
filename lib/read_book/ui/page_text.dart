import 'package:flutter/material.dart';

class PageText extends StatelessWidget {
  final String pageText;

  const PageText({
    @required this.pageText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 25.0, color: Colors.grey[300]),
          text: pageText,
        ),
        textAlign: TextAlign.start,
        textScaleFactor: 1.0,
        textDirection: TextDirection.ltr,
      ),
    );
  }
}
