import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/detection_point.dart';
import '../models/detection_result.dart';

class DetectionController extends ChangeNotifier {
  final Random _random = Random();

  /// 📡 Live radar points
  List<DetectionPoint> points = [];

  /// 📊 Confidence value
  double confidence = 0;

  /// 📍 Current detection
  DetectionResult? currentResult;

  /// 📜 History
  final List<DetectionResult> _history = [];
  List<DetectionResult> get history => _history;

  /// ⏱️ Timer
  Timer? _timer;

  /// 💾 Hive storage
  late final Box _box;

  /// 🔧 Constructor
  DetectionController() {
    _box = Hive.box('history');
  }

  // ============================================================
  // 🔥 CORE METHOD (USED BY BOTH SIMULATION + REAL ML)
  // ============================================================

  void addDetection(DetectionResult result) {
    currentResult = result;

    /// 📜 Add to memory history
    _history.add(result);
    if (_history.length > 200) {
      _history.removeAt(0);
    }

    /// 💾 Save to Hive
    _box.add({
      'presence': result.presence,
      'activity': result.activity,
      'timestamp': result.timestamp.toIso8601String(),
    });

    if (_box.length > 200) {
      _box.deleteAt(0);
    }

    /// 📡 Convert to radar
    if (result.hasPresence) {
      final normalizedY = result.distance / 16.6;

      points = [
        DetectionPoint(
          x: 0.4 + _random.nextDouble() * 0.2, // slight spread
          y: normalizedY,
        ),
      ];

      /// 📊 Confidence (distance-based + smooth)
      final baseConfidence = 100 - (normalizedY * 50);
      confidence = (confidence * 0.7) + (baseConfidence * 0.3);
    } else {
      points = [];

      /// Smooth drop
      confidence = (confidence * 0.7);
    }

    notifyListeners();
  }

  // ============================================================
  // 🔁 SIMULATION (REPLACE WITH REAL ML LATER)
  // ============================================================

  void startSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      final result = DetectionResult(
        presence: _random.nextInt(6),
        activity: _random.nextInt(3),
        timestamp: DateTime.now(),
      );

      addDetection(result); // ✅ single pipeline
    });
  }

  // ============================================================
  // 📡 HISTORY → RADAR
  // ============================================================

  List<DetectionPoint> historyToPoints() {
    return _history
        .where((e) => e.hasPresence)
        .map(
          (e) => DetectionPoint(
            x: 0.4 + _random.nextDouble() * 0.2,
            y: e.distance / 16.6,
          ),
        )
        .toList();
  }

  // ============================================================
  // 💾 LOAD FROM HIVE
  // ============================================================

  void loadHistoryFromStorage() {
    final data = _box.values.toList()
      ..sort(
        (a, b) => DateTime.parse(
          a['timestamp'],
        ).compareTo(DateTime.parse(b['timestamp'])),
      );

    _history.clear();

    for (var item in data) {
      _history.add(
        DetectionResult(
          presence: item['presence'],
          activity: item['activity'],
          timestamp: DateTime.parse(item['timestamp']),
        ),
      );
    }

    notifyListeners();
  }

  // ============================================================
  // ⚙️ HELPERS
  // ============================================================

  bool get hasDetection => points.isNotEmpty;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
