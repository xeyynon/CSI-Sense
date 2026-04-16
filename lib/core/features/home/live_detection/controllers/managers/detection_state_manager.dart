import 'dart:math';
import '../../models/detection_point.dart';
import '../../models/detection_result.dart';
import '../../models/detection_mode.dart';

class DetectionStateManager {
  final Random _random = Random();

  List<DetectionPoint> points = [];
  double confidence = 0;
  DetectionResult? currentResult;

  void update(DetectionResult result, DetectionType type) {
    currentResult = result;

    if (type == DetectionType.presence) {
      if (result.hasPresence) {
        final normalizedY = (result.distance / 16.6).clamp(0.0, 1.0).toDouble();

        points = [
          DetectionPoint(x: 0.4 + _random.nextDouble() * 0.2, y: normalizedY),
        ];

        final baseConfidence = 100 - (normalizedY * 50);
        confidence = ((confidence * 0.7) + (baseConfidence * 0.3)).clamp(
          0,
          100,
        );
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

        confidence = ((confidence * 0.6) + (result.activity * 10)).clamp(
          0,
          100,
        );
      } else {
        points = <DetectionPoint>[];
        confidence = (confidence * 0.7).clamp(0, 100);
      }
    }
  }
}
