import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/detection_controller.dart';
import '../models/detection_mode.dart';
import '../widgets/layout/live_layout.dart';

class PresenceDetectionScreen extends StatefulWidget {
  const PresenceDetectionScreen({super.key});

  @override
  State<PresenceDetectionScreen> createState() =>
      _PresenceDetectionScreenState();
}

class _PresenceDetectionScreenState extends State<PresenceDetectionScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final controller = context.read<DetectionController>();

      controller.setDetectionType(DetectionType.presence);
      controller.isLiveActive = true;
    });
  }

  @override
  void dispose() {
    context.read<DetectionController>().isLiveActive = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Presence Detection")),
      body: const LiveLayout(type: DetectionType.presence),
    );
  }
}
