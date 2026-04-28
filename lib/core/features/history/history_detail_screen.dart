import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/live_detection/controllers/detection_controller.dart';
import '../home/live_detection/models/detection_mode.dart';

class HistoryDetailScreen extends StatelessWidget {
  final String title;
  final DetectionType type; // ✅ ONLY THIS
  final bool isReplay;

  const HistoryDetailScreen({
    super.key,
    required this.title,
    required this.type,
    required this.isReplay,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DetectionController>();

    /// 🔥 SELECT CORRECT DATA
    final data = type == DetectionType.presence
        ? controller.presenceHistory.reversed.toList()
        : controller.activityHistory.reversed.toList();

    return Scaffold(
      appBar: AppBar(title: Text(title)),

      body: data.isEmpty
          ? const Center(
              child: Text(
                "No data available",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : Column(
              children: [
                /// 🔥 RADAR / REPLAY SECTION
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(
                      isReplay
                          ? "Replay Mode (${type.name})"
                          : "History (${type.name})",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                /// 🔥 LOG LIST
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];

                      return ListTile(
                        leading: Icon(
                          type == DetectionType.presence
                              ? Icons.person
                              : Icons.directions_run,
                          color: type == DetectionType.presence
                              ? Colors.greenAccent
                              : Colors.orangeAccent,
                        ),

                        /// ✅ LABEL
                        title: Text(item.label),

                        /// 🔥 CONFIDENCE
                        subtitle: Text(
                          "Confidence: ${item.confidence.toStringAsFixed(1)}%",
                        ),

                        /// ✅ TIME
                        trailing: Text(
                          TimeOfDay.fromDateTime(
                            item.timestamp,
                          ).format(context),
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
