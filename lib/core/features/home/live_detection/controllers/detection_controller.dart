import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/detection_point.dart';

class DetectionController extends ChangeNotifier {
  final Random _random = Random();

  List<DetectionPoint> points = [];
  double confidence = 0;

  Timer? _timer; // ✅ ADD THIS

  void startSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      final detected = _random.nextBool();

      if (detected) {
        points = List.generate(
          _random.nextInt(4) + 1,
          (_) =>
              DetectionPoint(x: _random.nextDouble(), y: _random.nextDouble()),
        );

        confidence = 50 + _random.nextDouble() * 50;
      } else {
        points = [];
        confidence = _random.nextDouble() * 30;
      }

      notifyListeners();
    });
  }

  bool get hasDetection => points.isNotEmpty;

  @override
  void dispose() {
    _timer?.cancel(); // ✅ CRITICAL FIX
    super.dispose();
  }
}
