// Standard Library
import 'dart:io';
import 'package:flutter/material.dart';

class CoverTile extends StatelessWidget {
  final String name;
  final String filePath;
  final String image = 'assets/cover.webp';

  CoverTile({@required this.name, @required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: InkWell(
            onTap: () {
              // var epub = File(file);
              print(filePath);
            },
            child: Card(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  image,
                ),
              ),
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          name,
          style: TextStyle(fontSize: 20),
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
      ],
    );
  }
}
