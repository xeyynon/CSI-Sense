import 'package:flutter/material.dart';
import 'package:csi_sense/core/features/home/live_detection/models/detection_mode.dart';
import '../../models/detection_result.dart';

class DetectionStatusText extends StatelessWidget {
  final bool hasDetection;
  final DetectionResult? result;
  final DetectionType type;

  const DetectionStatusText({
    super.key,
    required this.hasDetection,
    required this.type,
    this.result,
  });

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return const Text(
        "No Data",
        style: TextStyle(
          color: Colors.redAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    // 🟢 PRESENCE MODE
    if (type == DetectionType.presence) {
      if (result!.presence == 0) {
        return const Text(
          "No Presence Detected",
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        );
      }

      return Text(
        "Presence at ${result!.distance.toStringAsFixed(1)} m",
        style: const TextStyle(
          color: Colors.greenAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    // 🔵 ACTIVITY MODE
    if (type == DetectionType.activity) {
      if (result!.activity == 0) {
        return const Text(
          "No Activity Detected",
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        );
      }

      return Text(
        result!.label, // 🔥 Squats, Walking, Standing
        style: const TextStyle(
          color: Colors.greenAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return const SizedBox();
  }
}
