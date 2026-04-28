import 'package:flutter/material.dart';

import '../home/widgets/grid_menu.dart';
import '../home/widgets/grid_menu_item.dart';
import '../home/live_detection/models/detection_mode.dart'; // ✅ IMPORTANT
import 'presence_history_screen.dart';
import 'activity_history_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      GridMenuItem(
        title: "Presence History",
        icon: Icons.person_outline,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PresenceHistoryScreen(
                type: DetectionType.presence, // ✅ FIX
              ),
            ),
          );
        },
      ),
      GridMenuItem(
        title: "Activity History",
        icon: Icons.directions_run,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ActivityHistoryScreen(
                type: DetectionType.activity, // ✅ FIX
              ),
            ),
          );
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("History"), centerTitle: true),
      body: GridMenu(items: items),
    );
  }
}