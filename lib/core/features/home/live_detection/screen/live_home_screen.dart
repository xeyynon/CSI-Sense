import 'package:flutter/material.dart';

import '../../widgets/grid_menu.dart';
import '../../widgets/grid_menu_item.dart';
import 'presence_detection_screen.dart';
import 'activity_detection_screen.dart';

class LiveHomeScreen extends StatelessWidget {
  const LiveHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      GridMenuItem(
        title: "Presence Detection",
        icon: Icons.person,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PresenceDetectionScreen()),
          );
        },
      ),
      GridMenuItem(
        title: "Activity Detection",
        icon: Icons.directions_run,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ActivityDetectionScreen()),
          );
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Live Detection"), centerTitle: true),
      body: GridMenu(items: items), // ✅ reused grid
    );
  }
}
