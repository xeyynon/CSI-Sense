import 'dart:async';

import '../../models/detection_result.dart';
import '../../../../../../core/services/detection_service.dart';

class DetectionStreamManager {
  DetectionService? _service;
  StreamSubscription<DetectionResult>? _subscription;

  bool isRunning = false;

  /// 🔥 START STREAM
  void start({
    required DetectionService service,
    required Function(DetectionResult) onData,
    required Function(Object error) onError,
  }) {
    stop(); // prevent duplicate streams

    _service = service;
    isRunning = true;

    if (_service == null) return;

    _subscription = _service!.getDetectionStream().listen(
      (result) {
        onData(result); // ✅ ONLY DATA
      },
      onError: (error) {
        onError(error);
      },
      onDone: () {
        onError(Exception("Stream closed"));
      },
      cancelOnError: false,
    );
  }

  /// 🔥 STOP STREAM
  void stop() {
    if (!isRunning) return;

    isRunning = false;

    _subscription?.cancel();
    _subscription = null;

    _service?.dispose();
    _service = null;
  }

  /// 🔁 RESTART
  void restart({
    required DetectionService service,
    required Function(DetectionResult) onData,
    required Function(Object error) onError,
  }) {
    stop();
    start(service: service, onData: onData, onError: onError);
  }

  /// 🧹 DISPOSE
  void dispose() {
    stop();
  }
}
