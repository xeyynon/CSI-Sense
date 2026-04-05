import 'dart:math';
import 'package:flutter/material.dart';

class RadarPainter extends CustomPainter {
  final bool isDark;

  RadarPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final radarColor = isDark ? Colors.greenAccent : Colors.black;

    final paint = Paint()
      ..color = radarColor.withValues(
        alpha: (isDark ? 0.6 : 0.8), // 🔥 stronger in light mode
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = isDark ? 2 : 3; // 🔥 thicker in light mode

    final center = Offset(size.width / 2, size.height);
    final maxRadius = size.width / 2;

    /// 📡 Draw WiFi-style arcs
    for (int i = 1; i <= 4; i++) {
      final radius = maxRadius * (i / 4);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        pi, // 🔥 accurate
        pi,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant RadarPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}
