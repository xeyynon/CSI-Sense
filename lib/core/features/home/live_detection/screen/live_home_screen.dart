import 'package:flutter/material.dart';

import 'presence_detection_screen.dart';
import 'activity_detection_screen.dart';

class LiveHomeScreen extends StatelessWidget {
  const LiveHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Detection")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard(
              context,
              title: "Presence Detection",
              icon: Icons.person,
              screen: const PresenceDetectionScreen(),
            ),

            const SizedBox(height: 16),

            _buildCard(
              context,
              title: "Activity Detection",
              icon: Icons.directions_run,
              screen: const ActivityDetectionScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget screen,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Icon(icon, size: 40),
              const SizedBox(width: 16),
              Text(title, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
