import 'dart:math'; // ✅ IMPORTANT
import 'package:flutter/material.dart';
import '../../models/detection_point.dart';

class DetectionDotWidget extends StatefulWidget {
  final DetectionPoint point;
  final double size;

  const DetectionDotWidget({
    super.key,
    required this.point,
    required this.size,
  });

  @override
  State<DetectionDotWidget> createState() => _DetectionDotWidgetState();
}

class _DetectionDotWidgetState extends State<DetectionDotWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    /// ✅ LINEAR RADAR POSITION CALCULATION
    final radius = widget.size / 2 * widget.point.y;
    final angle = widget.point.x * pi;

    final center = Offset(widget.size / 2, widget.size);

    final dx = center.dx + radius * cos(angle + pi);
    final dy = center.dy + radius * sin(angle + pi);

    return Positioned(
      left: dx.clamp(0, widget.size - 10),
      top: dy.clamp(0, widget.size - 10),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Stack(
            alignment: Alignment.center,
            children: [
              /// 🔥 RIPPLE EFFECT
              Container(
                width: 20 + (_controller.value * 20),
                height: 20 + (_controller.value * 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(
                      alpha: 1 - _controller.value,
                    ),
                  ),
                ),
              ),

              /// 🔥 CORE DOT
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.white, // ✅ radar is white now
                  shape: BoxShape.circle,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
