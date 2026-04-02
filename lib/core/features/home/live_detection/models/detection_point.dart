import 'package:flutter/material.dart';

class DetectionPoint {
  final double x; // 0 → 1
  final double y; // 0 → 1

  DetectionPoint({required this.x, required this.y});

  Offset toOffset(double size) {
    return Offset(x * size, y * size);
  }
}