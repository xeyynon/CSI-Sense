import 'dart:math';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final dotColor = isDark ? Colors.greenAccent : Colors.black;

    /// 📡 POSITION CALCULATION
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
              /// 🔥 RIPPLE
              Container(
                width: 20 + (_controller.value * 20),
                height: 20 + (_controller.value * 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: dotColor.withValues(
                      alpha: isDark
                          ? (1 - _controller.value) * 0.6
                          : (1 - _controller.value) * 0.8,
                    ),
                    width: isDark ? 1.5 : 2,
                  ),
                ),
              ),

              /// 🔥 CORE DOT
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
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
