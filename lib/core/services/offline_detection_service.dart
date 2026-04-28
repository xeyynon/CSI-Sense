import 'dart:async';
import 'dart:math';

import 'package:csi_sense/core/features/home/live_detection/models/detection_mode.dart';
import '../features/home/live_detection/models/detection_result.dart';
import 'detection_service.dart';

class OfflineDetectionService implements DetectionService {
  final DetectionType type;

  OfflineDetectionService(this.type);

  final Random _random = Random();

  final StreamController<DetectionResult> _controller =
      StreamController.broadcast();

  Timer? _timer;
  bool _isRunning = false;

  // ============================================================
  // 🎯 ACTIVITY LABELS (MATCH ONLINE API)
  // ============================================================

  static const Map<int, String> activityLabels = {
    1: "Squats",
    2: "Walking",
    3: "Standing",
  };

  @override
  Stream<DetectionResult> getDetectionStream() {
    _start();
    return _controller.stream;
  }

  void _start() {
    if (_isRunning) return;
    _isRunning = true;

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      final now = DateTime.now();

      // 🔥 Presence probability (demo-friendly)
      final hasPresence = _random.nextInt(10) > 2; // ~80%

      // 🔥 Activity selection (1–3)
      final activityId = _random.nextInt(3) + 1;

      // 🔥 Confidence behavior
      final confidence = hasPresence
          ? 75 +
                _random.nextDouble() *
                    25 // 75–100
          : _random.nextDouble() * 30; // 0–30

      // 🔥 Distance behavior
      final distance = hasPresence
          ? 1 +
                _random.nextDouble() *
                    9 // 1m–10m realistic
          : 0.0;

      String label;

      if (type == DetectionType.presence) {
        label = hasPresence
            ? "Presence at ${distance.toStringAsFixed(1)}m"
            : "No Presence";
      } else {
        label = hasPresence
            ? activityLabels[activityId] ?? "Unknown"
            : "No Activity";
      }

      final result = DetectionResult(
        presence: hasPresence ? 1 : 0,
        activity: type == DetectionType.activity ? activityId : 0,
        distance: type == DetectionType.presence ? distance : 0,
        confidence: confidence,
        timestamp: now,
        label: label, // ✅ IMPORTANT (matches online)
      );

      if (!_controller.isClosed) {
        _controller.add(result);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _isRunning = false;

    if (!_controller.isClosed) {
      _controller.close();
    }
  }
}
