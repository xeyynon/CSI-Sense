import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/live_detection/controllers/detection_controller.dart';
import '../home/live_detection/models/detection_mode.dart';

class HistoryListScreen extends StatelessWidget {
  final DetectionType type; // ✅ ADD

  const HistoryListScreen({
    super.key,
    required this.type, // ✅ ADD
  });

  String getActivityText(int activity) {
    switch (activity) {
      case 1:
        return "Walking";
      case 2:
        return "Walking + Arm Waving";
      case 3:
        return "Running";
      default:
        return "No Activity";
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DetectionController>();

    final data = type == DetectionType.presence
        ? controller.presenceHistory
        : controller.activityHistory;

    final history = data.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          type == DetectionType.presence ? "Presence Logs" : "Activity Logs",
        ),
      ),

      body: history.isEmpty
          ? const Center(child: Text("No data available"))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (_, i) {
                final item = history[i];

                return ListTile(
                  leading: Icon(
                    item.hasPresence ? Icons.person : Icons.person_off,
                    color: item.hasPresence ? Colors.greenAccent : Colors.grey,
                  ),

                  title: type == DetectionType.presence
                      ? Text(
                          item.hasPresence
                              ? "Presence at ${item.distance.toStringAsFixed(1)}m"
                              : "No Presence",
                        )
                      : Text(getActivityText(item.activity)),

                  subtitle: Text(
                    "Confidence: ${item.confidence.toStringAsFixed(1)}%",
                  ),

                  trailing: Text(
                    "${item.timestamp.hour.toString().padLeft(2, '0')}:"
                    "${item.timestamp.minute.toString().padLeft(2, '0')}:"
                    "${item.timestamp.second.toString().padLeft(2, '0')}",
                  ),
                );
              },
            ),
    );
  }
}
