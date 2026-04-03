import 'package:flutter/material.dart';

class DetectionStatusText extends StatelessWidget {
  final bool hasDetection;
  final double? distance;
  final int? activity;

  const DetectionStatusText({
    super.key,
    required this.hasDetection,
    this.distance,
    this.activity,
  });

  String getActivityText(int? activity) {
    switch (activity) {
      case 1:
        return "Walking";
      case 2:
        return "Walking + Arm Waving";
      default:
        return "No Activity";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!hasDetection) {
      return const Text(
        "No Presence Detected",
        style: TextStyle(
          color: Colors.redAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Column(
      children: [
        Text(
          "Presence at ${distance?.toStringAsFixed(1)}m",
          style: const TextStyle(
            color: Colors.greenAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          getActivityText(activity),
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }
}
