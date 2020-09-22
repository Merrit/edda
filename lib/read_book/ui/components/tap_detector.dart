import 'package:flutter/material.dart';

/// A transparent widget that contains a gesture detector and flex properties.
class TapDetector extends StatelessWidget {
  /// What gets done after a tap event.
  final Function tapCallback;

  /// If there is no Flex amount it will cause errors if under a Column / Row.
  /// If flex is not needed use a value of 1.
  final int flexAmount;

  /// The container background color (optional). Example:
  /// ```dart
  /// Colors.lightGreen.withOpacity(0.3)
  /// ```
  /// would give a semi-transparent color so you can position the [TapDetector].
  final color;

  const TapDetector({@required this.flexAmount, this.tapCallback, this.color});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flexAmount,
      child: Container(
        color: color,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: tapCallback,
        ),
      ),
    );
  }
}
