import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/live_detection/controllers/detection_controller.dart';

class HistoryListScreen extends StatelessWidget {
  const HistoryListScreen({super.key});

  String getActivityText(int activity) {
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
    final controller = Provider.of<DetectionController>(context);
    final history = controller.history.reversed.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Detection Logs")),

      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (_, i) {
          final item = history[i];

          return ListTile(
            leading: Icon(
              item.hasPresence ? Icons.person : Icons.person_off,
              color: item.hasPresence ? Colors.greenAccent : Colors.grey,
            ),
            title: Text(
              item.hasPresence
                  ? "Presence at ${item.distance.toStringAsFixed(1)}m"
                  : "No Presence",
            ),
            subtitle: Text(getActivityText(item.activity)),
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
