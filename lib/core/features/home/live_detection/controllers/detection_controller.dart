import 'dart:async';
import 'dart:math';
import 'package:csi_sense/core/config/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/detection_point.dart';
import '../models/detection_result.dart';

import '../../../../../core/services/detection_service.dart';
import '../../../../../core/services/offline_detection_service.dart';
import '../../../../../core/services/online_detection_service.dart';
import '../../../../../core/config/app_mode.dart';

class DetectionController extends ChangeNotifier {
  final Random _random = Random();
  DetectionService? _service;
  AppMode? _currentMode;
  StreamSubscription? _subscription;

  /// 📡 Live radar points
  List<DetectionPoint> points = [];

  /// 📊 Confidence
  double confidence = 0;

  /// 📍 Current detection
  DetectionResult? currentResult;

  /// 📜 History
  final List<DetectionResult> _history = [];
  List<DetectionResult> get history => _history;

  /// 💾 Hive
  late final Box _box;

  /// ⚙️ Settings
  bool isLiveActive = false;
  Duration historyDuration = const Duration(minutes: 5);

  // ============================================================
  // 🔧 CONSTRUCTOR
  // ============================================================

  DetectionController() {
    _box = Hive.box('history');
  }

  // ============================================================
  // 🔁 STREAM CONTROL
  // ============================================================
  bool isConnected = false;
  void startDetection() {
    isConnected = false;
    _startStream();
  }

  void _startStream() {
    _subscription?.cancel();

    if (_service == null) return;

    _subscription = _service!.getDetectionStream().listen((result) {
      isConnected = true;
      notifyListeners();
      addDetection(result);
    });
  }

  void updateMode(AppMode mode) {
    if (_currentMode == mode) return;

    _currentMode = mode;

    /// 🔥 Dispose old service
    _service?.dispose();

    /// 🔥 Create new service
    _service = mode == AppMode.offline
        ? OfflineDetectionService()
        : OnlineDetectionService();

    /// 🔥 Restart stream
    _startStream();
  }

  DetectionSensitivity _sensitivity = DetectionSensitivity.medium;
  void updateSensitivity(DetectionSensitivity sensitivity) {
    _sensitivity = sensitivity;
  }

  // ============================================================
  // 🔥 CORE LOGIC
  // ============================================================

  void addDetection(DetectionResult result) {
    if (!isLiveActive) return;

    currentResult = result;

    /// 📜 Add to history
    _history.add(result);

    /// ⏱ Apply time filter
    final cutoff = DateTime.now().subtract(historyDuration);

    _history.removeWhere((e) => e.timestamp.isBefore(cutoff));

    /// 💾 Save to Hive
    _box.add({
      'presence': result.presence,
      'activity': result.activity,
      'timestamp': result.timestamp.toIso8601String(),
    });

    /// 🔥 ALSO CLEAN HIVE (IMPORTANT FIX)
    final keysToDelete = _box.keys.where((key) {
      final item = _box.get(key);
      final time = DateTime.parse(item['timestamp']);
      return time.isBefore(cutoff);
    }).toList();

    _box.deleteAll(keysToDelete);

    /// 📡 Radar logic
    if (result.hasPresence) {
      final normalizedY = result.distance / 16.6;

      points = [
        DetectionPoint(x: 0.4 + _random.nextDouble() * 0.2, y: normalizedY),
      ];

      final baseConfidence = 100 - (normalizedY * 50);
      confidence = (confidence * 0.7) + (baseConfidence * 0.3);
    } else {
      points = [];
      confidence = (confidence * 0.7);
    }

    notifyListeners();
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
  // 💾 LOAD HISTORY
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
  // 🧹 CLEAR HISTORY
  // ============================================================

  Future<void> clearHistory() async {
    _history.clear();
    await _box.clear();
    notifyListeners();
  }

  // ============================================================
  // ⚙️ HELPERS
  // ============================================================

  bool get hasDetection => points.isNotEmpty;

  // ============================================================
  // 🧹 DISPOSE
  // ============================================================

  @override
  void dispose() {
    _subscription?.cancel();
    _service?.dispose();
    super.dispose(); // 🔥 IMPORTANT FIX
  }
}
