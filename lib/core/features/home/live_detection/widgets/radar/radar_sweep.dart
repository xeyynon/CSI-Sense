import 'dart:math';
import 'dart:math' as Math;
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Transform.rotate(
          angle: _controller.value * 2 * 3.1416,

          child: SizedBox.expand(
            child: CustomPaint(painter: _SweepPainter(_controller.value)),
          ),
        );
      },
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

  _SweepPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final maxRadius = size.width / 2;

    final angle = 3.14 * progress; // move across arc

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 3;

    final endX = center.dx + maxRadius * Math.cos(angle + 3.14);
    final endY = center.dy + maxRadius * Math.sin(angle + 3.14);

    canvas.drawLine(center, Offset(endX, endY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
