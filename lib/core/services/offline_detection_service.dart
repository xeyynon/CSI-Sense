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

  @override
  Stream<DetectionResult> getDetectionStream() {
    _start();
    return _controller.stream;
  }

  void _start() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      final hasPresence = _random.nextBool();

      _controller.add(
        DetectionResult(
          presence: hasPresence ? (_random.nextInt(5) + 1) : 0,
          activity: _random.nextInt(3),
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
