import '../features/home/live_detection/models/detection_result.dart';

abstract class DetectionService {
  Stream<DetectionResult> getDetectionStream();

  /// 🔥 ADD THIS (VERY IMPORTANT)
  void dispose() {}
}
