import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/detection_controller.dart';
import '../models/detection_mode.dart';
import '../widgets/layout/live_layout.dart';
import 'package:csi_sense/core/config/app_settings.dart';

class ActivityDetectionScreen extends StatefulWidget {
  const ActivityDetectionScreen({super.key});

  @override
  State<ActivityDetectionScreen> createState() =>
      _ActivityDetectionScreenState();
}

class _ActivityDetectionScreenState extends State<ActivityDetectionScreen> {
  DetectionController? controller;
  bool initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!initialized) {
      controller = context.read<DetectionController>();
      final settings = context.read<AppSettings>();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller!.setDetectionType(DetectionType.activity, settings);
        controller!.isLiveActive = true;
      });

      initialized = true;
    }
  }

  @override
  void dispose() {
    controller?.isLiveActive = false;
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
