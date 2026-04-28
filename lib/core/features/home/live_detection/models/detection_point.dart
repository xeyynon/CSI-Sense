import 'package:flutter/material.dart';

class DetectionPoint {
  final double x; // 0 → 1
  final double y; // 0 → 1

  const DetectionPoint({required this.x, required this.y});

  Offset toOffset(double size) {
    final safeX = x.clamp(0.0, 1.0);
    final safeY = y.clamp(0.0, 1.0);
    return Offset(safeX * size, safeY * size);
  }

  DetectionPoint copyWith({double? x, double? y}) {
    return DetectionPoint(x: x ?? this.x, y: y ?? this.y);
  }
}
