import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/live_detection/controllers/detection_controller.dart';
import '../home/live_detection/models/detection_mode.dart';
import 'history_list_screen.dart';
import 'history_radar_screen.dart';

class ActivityHistoryScreen extends StatelessWidget {
  const ActivityHistoryScreen({super.key});

  String getActivityText(int activity) {
    switch (activity) {
      case 1:
        return "Walking";
      case 2:
        return "Walking + Arm Movement";
      case 3:
        return "Running / High Activity";
      default:
        return "No Activity";
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DetectionController>();
    final data = controller.activityHistory.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity History"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              controller.clearHistory(); // ✅ unified clear
            },
          ),
        ],
      ),

      body: data.isEmpty
          ? const Center(
              child: Text(
                "No activity data available",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : Column(
              children: [
                /// 🔥 OPTIONS (Replay + Logs)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.radar),
                        label: const Text("Replay"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HistoryRadarScreen(
                                type: DetectionType.activity,
                              ),
                            ),
                          );
                        },
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.list),
                        label: const Text("Logs"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HistoryListScreen(
                                type: DetectionType.presence,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                /// 🔥 LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (_, i) {
                      final item = data[i];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.directions_run,
                            color: Colors.orangeAccent,
                          ),

                          /// 🔥 TITLE
                          title: Text(getActivityText(item.activity)),

                          /// 🔥 SUBTITLE
                          subtitle: Text(
                            "Confidence: ${item.confidence.toStringAsFixed(1)}%",
                          ),

                          /// 🔥 TIME
                          trailing: Text(
                            item.timestamp.toLocal().toString().split('.')[0],
                            style: const TextStyle(fontSize: 12),
                          ),
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
