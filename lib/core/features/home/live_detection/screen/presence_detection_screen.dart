import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:csi_sense/core/config/app_settings.dart';

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
  DetectionController? controller;
  bool initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!initialized) {
      controller = context.read<DetectionController>();
      final settings = context.read<AppSettings>();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller!.setDetectionType(
          DetectionType.presence,
          settings,
        );
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
      appBar: AppBar(title: const Text("Presence Detection")),
      body: const LiveLayout(type: DetectionType.presence),
    );
  }
}