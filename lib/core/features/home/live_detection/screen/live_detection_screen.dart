import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/layout/live_layout.dart';
import '../../../../animations/swipe_back_wrapper.dart';
import '../controllers/detection_controller.dart';
import '../models/detection_mode.dart';
import 'package:csi_sense/core/config/app_settings.dart';

class LiveDetectionScreen extends StatefulWidget {
  final DetectionType type;

  const LiveDetectionScreen({super.key, required this.type});

  @override
  State<LiveDetectionScreen> createState() => _LiveDetectionScreenState();
}

class _LiveDetectionScreenState extends State<LiveDetectionScreen> {
  DetectionController? controller; // ✅ nullable (safe)
  DetectionType currentType = DetectionType.presence;

  @override
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final c = context.read<DetectionController>();
      final settings = context.read<AppSettings>(); // ✅ ADD THIS

      c.setDetectionType(widget.type, settings); // ✅ FIX
      c.isLiveActive = true;

      controller = c;
    });
  }

  @override
  void dispose() {
    controller?.isLiveActive = false; // ✅ safe access
    super.dispose();
  }

  String get title {
    switch (widget.type) {
      case DetectionType.presence:
        return "Presence Detection";
      case DetectionType.activity:
        return "Activity Detection";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),

      body: SwipeBackWrapper(
        child: const LiveLayout(type: DetectionType.presence),
      ),
    );
  }
}
