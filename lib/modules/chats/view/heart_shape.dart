import 'dart:math' as math;
import 'package:flutter/material.dart';

class HeartShapeBorder extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(16.0);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final height = rect.height;
    final path = Path();

    // Increase scale to make heart larger within given rect
    final scaleX = width / 1.5;
    final scaleY = height / 1.5;

    final centerX = rect.left + width / 2;
    final centerY = rect.top + height / 2;

    path.moveTo(centerX, centerY + scaleY * 0.6); // Bottom tip of heart

    path.cubicTo(
      centerX - scaleX * 1.2,
      centerY + scaleY * 0.2,
      centerX - scaleX * 0.9,
      centerY - scaleY * 0.8,
      centerX,
      centerY - scaleY * 0.3,
    );

    path.cubicTo(
      centerX + scaleX * 0.9,
      centerY - scaleY * 0.8,
      centerX + scaleX * 1.2,
      centerY + scaleY * 0.2,
      centerX,
      centerY + scaleY * 0.6,
    );

    path.close();
    return path;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // No custom painting needed here
  }

  @override
  ShapeBorder scale(double t) => this;
}
