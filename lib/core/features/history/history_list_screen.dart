import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/live_detection/controllers/detection_controller.dart';
import '../home/live_detection/models/detection_mode.dart';

class HistoryListScreen extends StatelessWidget {
  final DetectionType type;

  const HistoryListScreen({super.key, required this.type});

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
                  /// 🔥 ICON FIX
                  leading: Icon(
                    type == DetectionType.presence
                        ? (item.hasPresence ? Icons.person : Icons.person_off)
                        : Icons.directions_run,
                    color: type == DetectionType.presence
                        ? (item.hasPresence ? Colors.greenAccent : Colors.grey)
                        : Colors.orangeAccent,
                  ),

                  /// 🔥 TITLE FIX
                  title: type == DetectionType.presence
                      ? Text(
                          item.hasPresence
                              ? "Presence at ${item.distance.toStringAsFixed(1)} m"
                              : "No Presence",
                        )
                      : Text(item.label), // ✅ USE API LABEL
                  /// 🔥 CONFIDENCE
                  subtitle: Text(
                    "Confidence: ${item.confidence.toStringAsFixed(1)}%",
                  ),

                  /// 🔥 TIME (CLEAN FORMAT)
                  trailing: Text(
                    TimeOfDay.fromDateTime(item.timestamp).format(context),
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
    );
  }
}
