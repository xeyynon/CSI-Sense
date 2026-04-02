import 'dart:math';
import 'package:flutter/material.dart';

class RadarDistortion extends StatefulWidget {
  final Widget child;

  const RadarDistortion({super.key, required this.child});

  @override
  State<RadarDistortion> createState() => _RadarDistortionState();
}

class _RadarDistortionState extends State<RadarDistortion>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Transform.scale(
          scale: 1 + (sin(_controller.value * 2 * pi) * 0.02),
          child: widget.child,
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
