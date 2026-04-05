import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:csi_sense/core/features/home/live_detection/controllers/detection_controller.dart';

class RadarSweep extends StatefulWidget {
  const RadarSweep({super.key});

  @override
  State<RadarSweep> createState() => _RadarSweepState();
}

class _RadarSweepState extends State<RadarSweep>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final controller = context.watch<DetectionController>();

    if (controller.isConnected) {
      _controller.stop(); // 🛑 stop animation
    } else {
      if (!_controller.isAnimating) {
        _controller.repeat(); // 🔄 start animation
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DetectionController>();

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: controller.isConnected ? 0 : 1,

      child: IgnorePointer(
        ignoring: controller.isConnected,

        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            final isDark = Theme.of(context).brightness == Brightness.dark;

            return Transform.rotate(
              angle: _controller.value * 2 * Math.pi,

              child: SizedBox.expand(
                child: CustomPaint(
                  painter: _SweepPainter(_controller.value, isDark), // ✅ FIX
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _SweepPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _SweepPainter(this.progress, this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final maxRadius = size.width / 2;

    final angle = Math.pi * progress;

    /// 🔥 STRONG COLOR (VISIBLE IN LIGHT MODE)
    final sweepColor = isDark
        ? Colors.greenAccent.withOpacity(0.7)
        : Colors.black.withOpacity(0.85);

    final rect = Rect.fromCircle(center: center, radius: maxRadius);

    final paint = Paint()
      ..shader = LinearGradient(
        colors: [sweepColor.withOpacity(0.0), sweepColor],
      ).createShader(rect)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final endX = center.dx + maxRadius * Math.cos(angle + Math.pi);
    final endY = center.dy + maxRadius * Math.sin(angle + Math.pi);

    canvas.drawLine(center, Offset(endX, endY), paint);
  }

  @override
  bool shouldRepaint(covariant _SweepPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}
