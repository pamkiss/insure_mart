import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class PromoIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint bluePaint = Paint()
      ..color = AppColors.primaryBlue
      ..style = PaintingStyle.fill;

    final Paint cyanPaint = Paint()
      ..color = AppColors.accentCyan
      ..style = PaintingStyle.fill;

    // House shape
    final housePath = Path();
    // Roof (triangle)
    housePath.moveTo(size.width * 0.5, size.height * 0.15);
    housePath.lineTo(size.width * 0.25, size.height * 0.4);
    housePath.lineTo(size.width * 0.75, size.height * 0.4);
    housePath.close();
    canvas.drawPath(housePath, bluePaint);

    // House body (rectangle)
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.3,
        size.height * 0.4,
        size.width * 0.4,
        size.height * 0.35,
      ),
      bluePaint,
    );

    // Door
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.42,
        size.height * 0.52,
        size.width * 0.16,
        size.height * 0.23,
      ),
      cyanPaint,
    );

    // Umbrella arc over the house
    final umbrellaPaint = Paint()
      ..color = AppColors.accentCyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final umbrellaPath = Path();
    umbrellaPath.moveTo(size.width * 0.1, size.height * 0.35);
    umbrellaPath.quadraticBezierTo(
      size.width * 0.5,
      -size.height * 0.1,
      size.width * 0.9,
      size.height * 0.35,
    );
    canvas.drawPath(umbrellaPath, umbrellaPaint);

    // Umbrella handle (vertical line)
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.05),
      Offset(size.width * 0.5, size.height * 0.15),
      umbrellaPaint,
    );

    // Person 1 (left)
    // Head
    canvas.drawCircle(
      Offset(size.width * 0.18, size.height * 0.7),
      size.width * 0.06,
      bluePaint,
    );
    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.14,
          size.height * 0.77,
          size.width * 0.08,
          size.height * 0.18,
        ),
        const Radius.circular(4),
      ),
      bluePaint,
    );

    // Person 2 (right)
    // Head
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.7),
      size.width * 0.06,
      cyanPaint,
    );
    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.78,
          size.height * 0.77,
          size.width * 0.08,
          size.height * 0.18,
        ),
        const Radius.circular(4),
      ),
      cyanPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
