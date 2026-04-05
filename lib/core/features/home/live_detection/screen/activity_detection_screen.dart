import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/detection_controller.dart';
import '../models/detection_mode.dart';
import '../widgets/layout/live_layout.dart';

class ActivityDetectionScreen extends StatefulWidget {
  const ActivityDetectionScreen({super.key});

  @override
  State<ActivityDetectionScreen> createState() =>
      _ActivityDetectionScreenState();
}

class _ActivityDetectionScreenState extends State<ActivityDetectionScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final controller = context.read<DetectionController>();

      controller.setDetectionType(DetectionType.activity);
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
      appBar: AppBar(title: const Text("Activity Detection")),
      body: const LiveLayout(type: DetectionType.activity),
    );
  }
}
