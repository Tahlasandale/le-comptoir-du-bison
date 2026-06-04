import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MugWidget extends StatelessWidget {
  final double fillPercent;

  const MugWidget({super.key, required this.fillPercent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 90,
      child: CustomPaint(
        painter: MugPainter(fillPercent: fillPercent),
      ),
    );
  }
}

class MugPainter extends CustomPainter {
  final double fillPercent;

  MugPainter({required this.fillPercent});

  @override
  void paint(Canvas canvas, Size size) {
    final paintBody = Paint()
      ..color = AppTheme.cream
      ..style = PaintingStyle.fill;

    final paintStroke = Paint()
      ..color = AppTheme.brownMid
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final paintBeer = Paint()
      ..color = AppTheme.amber.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final paintFoam = Paint()
      ..color = AppTheme.foam.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    // Handle
    final handlePath = Path()
      ..moveTo(60, 28)
      ..quadraticBezierTo(78, 28, 78, 45)
      ..quadraticBezierTo(78, 62, 60, 62);
    canvas.drawPath(handlePath, paintStroke);

    // Mug Path
    final mugPath = Path()
      ..moveTo(10, 15)
      ..lineTo(10, 75)
      ..quadraticBezierTo(10, 80, 15, 80)
      ..lineTo(55, 80)
      ..quadraticBezierTo(60, 80, 60, 75)
      ..lineTo(60, 15)
      ..close();

    canvas.drawPath(mugPath, paintBody);

    // Beer Fill
    double fillH = 60 * fillPercent.clamp(0, 1);
    if (fillH > 0) {
      canvas.save();
      canvas.clipPath(mugPath);
      
      final beerRect = Rect.fromLTWH(10, 75 - fillH, 50, fillH);
      canvas.drawRect(beerRect, paintBeer);

      double foamH = fillH > 0 ? (fillH * 0.15 + 3).clamp(0, 8) : 0;
      final foamRect = Rect.fromLTWH(10, 75 - fillH - foamH, 50, foamH);
      canvas.drawRect(foamRect, paintFoam);
      
      canvas.restore();
    }

    // Outline
    canvas.drawPath(mugPath, paintStroke);
    
    // Rim
    canvas.drawLine(const Offset(8, 15), const Offset(62, 15), paintStroke);
  }

  @override
  bool shouldRepaint(covariant MugPainter oldDelegate) => oldDelegate.fillPercent != fillPercent;
}
