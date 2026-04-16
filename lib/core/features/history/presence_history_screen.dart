import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/live_detection/controllers/detection_controller.dart';

class PresenceHistoryScreen extends StatelessWidget {
  const PresenceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DetectionController>();
    final data = controller.presenceHistory;

    return Scaffold(
      appBar: AppBar(title: const Text("Presence History")),
      body: data.isEmpty
          ? const Center(child: Text("No data yet"))
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (_, i) {
                final item = data[i];

                return ListTile(
                  leading: const Icon(Icons.radar),
                  title: Text(
                    "Distance: ${item.distance.toStringAsFixed(2)} m",
                  ),
                  subtitle: Text(
                    "Confidence: ${item.confidence.toStringAsFixed(1)}%",
                  ),
                );
              },
            ),
    );
  }
}
