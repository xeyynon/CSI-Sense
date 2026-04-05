import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/layout/live_layout.dart';
import '../../../animations/swipe_back_wrapper.dart';
import './controllers/detection_controller.dart';

class LiveDetectionScreen extends StatefulWidget {
  const LiveDetectionScreen({super.key});

  @override
  State<LiveDetectionScreen> createState() => _LiveDetectionScreenState();
}

class _LiveDetectionScreenState extends State<LiveDetectionScreen> {
  @override
  late DetectionController controller;
  void initState() {
    super.initState();
    controller = context.read<DetectionController>();
    controller.isLiveActive = true; // start live
    Future.microtask(() {
      Provider.of<DetectionController>(context, listen: false).isLiveActive =
          true;
    });
  }

  @override
  void dispose() {
    controller.isLiveActive = false; // 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("")),
      body: SwipeBackWrapper(child: const LiveLayout()),
    );
  }
}
