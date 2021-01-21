// TODO Implement this library.
import 'package:flutter/material.dart';

class DismissedContainer extends StatelessWidget {
  final Color color;
  final IconData icon;
  final double rightPadding;
  final double leftPadding;
  final Alignment alignment;

  DismissedContainer({
    @required this.color,
    @required this.icon,
    @required this.rightPadding,
    @required this.leftPadding,
    @required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: EdgeInsets.only(right: rightPadding,left: leftPadding),
        child: Icon(
          icon,
          size: 30,
          color: Colors.white,
        ),
      ),
      color: color,
    );
  }
}
