import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/live_detection/controllers/detection_controller.dart';
import '../home/live_detection/models/detection_mode.dart';
import 'history_list_screen.dart';
import 'history_radar_screen.dart';

class ActivityHistoryScreen extends StatelessWidget {
  final DetectionType type;
  const ActivityHistoryScreen({super.key, required this.type});

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
              controller.clearHistory();
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
                                type: DetectionType.activity, // ✅ FIXED
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

                          /// ✅ USE API LABEL (FIXED)
                          title: Text(item.label),

                          /// 🔥 CONFIDENCE
                          subtitle: Text(
                            "Confidence: ${item.confidence.toStringAsFixed(1)}%",
                          ),

                          /// ✅ CLEAN TIME FORMAT (FIXED)
                          trailing: Text(
                            TimeOfDay.fromDateTime(
                              item.timestamp,
                            ).format(context),
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
