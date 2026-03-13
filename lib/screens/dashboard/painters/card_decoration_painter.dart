import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CardDecorationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.cardBlueLight.withAlpha(77)
      ..style = PaintingStyle.fill;

    // Large circle at top-right
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.1),
      size.width * 0.35,
      paint,
    );

    // Smaller circle at bottom-left
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.95),
      size.width * 0.2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
