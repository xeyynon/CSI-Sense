import 'package:flutter/material.dart';

class RadarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height);

    final maxRadius = size.width / 2;

    // Draw arcs (wifi style)
    for (int i = 1; i <= 4; i++) {
      final radius = maxRadius * (i / 4);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        3.14, // π (left)
        3.14, // half circle
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
