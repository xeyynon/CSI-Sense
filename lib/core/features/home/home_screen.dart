import 'package:flutter/material.dart';
import '../../animations/fade_animation.dart';
import '../home/live_detection/live_detection_screen.dart';
import '../home/widgets/grid_menu.dart';
import 'widgets/grid_menu_item.dart';
import '../../animations/slide_fade_transition.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      GridMenuItem(
        title: "Live Detection",
        icon: Icons.radar,
        onTap: () {
          Navigator.push(
            context,
            SlideFadeRoute(page: const LiveDetectionScreen()),
          );
        },
      ),
      GridMenuItem(title: "History", icon: Icons.history, onTap: () {}),
      GridMenuItem(title: "System Status", icon: Icons.memory, onTap: () {}),
      GridMenuItem(title: "Settings", icon: Icons.settings, onTap: () {}),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Human Detection System")),
      body: FadeAnimation(child: GridMenu(items: items)),
    );
  }
}
