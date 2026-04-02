import 'package:flutter/material.dart';
import '../../models/detection_point.dart';
import 'detection_dot_widget.dart';

class DetectionDots extends StatelessWidget {
  final List<DetectionPoint> points;
  final double size;

  const DetectionDots({
    super.key,
    required this.points,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: points
          .map((p) => DetectionDotWidget(point: p, size: size))
          .toList(),
    );
  }
}