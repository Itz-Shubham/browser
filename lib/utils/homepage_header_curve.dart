import 'package:flutter/material.dart';

class HomepageHeaderCurve extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width, h = size.height;

    Path path = Path();
    path.lineTo(0, h);
    path.quadraticBezierTo(w * 0.5, h * 0.9, w, h);
    path.lineTo(w, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
