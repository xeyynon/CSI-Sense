import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/live_detection/controllers/detection_controller.dart';
import '../home/live_detection/widgets/radar/radar_view.dart';

class HistoryRadarScreen extends StatelessWidget {
  const HistoryRadarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<DetectionController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Radar Replay")),

      body: Center(
        child: RadarView(
          points: controller.historyToPoints(),
        ),
      ),
    );
  }
}