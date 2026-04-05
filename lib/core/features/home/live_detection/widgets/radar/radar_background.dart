import 'package:flutter/material.dart';
import 'radar_painter.dart';

class RadarBackground extends StatelessWidget {
  const RadarBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color.fromARGB(255, 209, 33, 33).withValues(alpha: 0.01),
            Colors.transparent,
          ],
          stops: const [0.1, 1.0],
        ),
      ),

      /// 🔥 CUSTOM PAINT HERE
      child: CustomPaint(
        painter: RadarPainter(isDark: isDark),
        child: const SizedBox.expand(), // fills space
      ),
    );
  }
}
