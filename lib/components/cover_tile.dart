// Standard Library
import 'package:flutter/material.dart';

class CoverTile extends StatelessWidget {
  final String image;
  final String name;

  CoverTile({this.image, this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Card(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                image,
              ),
            ),
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
