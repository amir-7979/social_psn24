import 'dart:ui';

import 'package:flutter/material.dart';

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter({required this.strokeColor, required this.strokeWidth, required this.paintingStyle});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, 0) // Start at the top left of the canvas
      ..lineTo(0, y) // Go to the bottom left
      ..lineTo(x, 0) // Go to the top right
      ..close(); // Go back to the start to close the path
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}