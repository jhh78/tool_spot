import 'package:flutter/material.dart';

class RectangleClipper extends CustomClipper<Path> {
  final double top;
  final double left;
  final double width;
  final double height;

  RectangleClipper({
    required this.top,
    required this.left,
    required this.width,
    required this.height,
  });

  @override
  Path getClip(Size size) {
    return Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()..addRect(Rect.fromLTWH(top, left, width, height)),
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
