import 'dart:async';
import 'dart:math';

import 'package:csi_sense/core/features/home/live_detection/models/detection_mode.dart';

import '../features/home/live_detection/models/detection_result.dart';
import 'detection_service.dart';

class OnlineDetectionService implements DetectionService {
  final DetectionType type;

  OnlineDetectionService(this.type);
  final StreamController<DetectionResult> _controller =
      StreamController.broadcast();

  Timer? _timer;
  final Random _random = Random();

  @override
  Stream<DetectionResult> getDetectionStream() {
    _startMock();
    return _controller.stream;
  }

  void _startMock() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      final hasPresence = _random.nextInt(3) != 0;

      _controller.add(
        DetectionResult(
          presence: hasPresence ? (_random.nextInt(5) + 1) : 0,
          activity: hasPresence ? 1 : 0,
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
