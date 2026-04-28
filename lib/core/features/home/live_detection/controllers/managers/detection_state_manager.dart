import 'dart:math';
import '../../models/detection_point.dart';
import '../../models/detection_result.dart';
import '../../models/detection_mode.dart';

class DetectionStateManager {
  final Random _random = Random();

  List<DetectionPoint> points = [];
  double confidence = 0;
  DetectionResult? currentResult;
  bool isPinging = false;

  void update(DetectionResult result, DetectionType type) {
    isPinging = true;
    currentResult = result;

    if (type == DetectionType.presence) {
      if (result.hasPresence) {
        final normalizedY = (result.distance / 16.6).clamp(0.0, 1.0).toDouble();

        points = [
          DetectionPoint(x: 0.4 + _random.nextDouble() * 0.2, y: normalizedY),
        ];

        confidence = result.confidence;
      } else {
        points = <DetectionPoint>[];
        confidence = (confidence * 0.7).clamp(0, 100);
      }
    } else {
      if (result.activity > 0) {
        final count = result.activity.clamp(1, 5);

        points = List<DetectionPoint>.generate(count, (index) {
          final angle = (index / count) * 2 * pi;
          final radius = 0.2 + _random.nextDouble() * 0.6;

          return DetectionPoint(
            x: 0.5 + radius * cos(angle),
            y: 0.5 + radius * sin(angle),
          );
        });

        confidence = result.confidence;
      } else {
        points = <DetectionPoint>[];
        confidence = (confidence * 0.7).clamp(0, 100);
      }
    }

    Future.delayed(const Duration(milliseconds: 800), () {
      isPinging = false;
    });
  }
}
