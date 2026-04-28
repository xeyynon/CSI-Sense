import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/live_detection/controllers/detection_controller.dart';
import '../home/live_detection/models/detection_mode.dart';
import 'history_list_screen.dart';
import 'history_radar_screen.dart';

class PresenceHistoryScreen extends StatelessWidget {
  final DetectionType type;

  const PresenceHistoryScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DetectionController>();
    final data = controller.presenceHistory.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Presence History"),
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
                "No presence data available",
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
                              builder: (_) => HistoryRadarScreen(
                                type: DetectionType.presence,
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
                          leading: Icon(
                            item.hasPresence ? Icons.person : Icons.person_off,
                            color: item.hasPresence
                                ? Colors.greenAccent
                                : Colors.grey,
                          ),

                          title: Text(
                            item.hasPresence
                                ? "Presence detected"
                                : "No Presence",
                          ),

                          subtitle: Text(
                            "Distance: ${item.distance.toStringAsFixed(1)} m\n"
                            "Confidence: ${item.confidence.toStringAsFixed(1)}%",
                          ),

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
