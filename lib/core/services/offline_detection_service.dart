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
      // 🔥 Make presence frequent (demo-friendly)
      final hasPresence = _random.nextInt(10) > 2; // 80% TRUE

      final activity = _random.nextInt(3);

      final confidence = hasPresence
          ? 75 + _random.nextDouble() * 25
          : _random.nextDouble() * 20;

      final distance = hasPresence ? (1 + _random.nextDouble() * 15) : 0.0;

      final result = DetectionResult(
        presence: hasPresence ? 1 : 0,
        activity: type == DetectionType.activity ? activity : 0,
        distance: distance,
        confidence: confidence,
        timestamp: DateTime.now(),
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
