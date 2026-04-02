import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/detection_controller.dart';
import 'widgets/layout/live_layout.dart';
import '../../../animations/swipe_back_wrapper.dart';

class LiveDetectionScreen extends StatelessWidget {
  const LiveDetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetectionController()..startSimulation(),
      child: Scaffold(
        appBar: AppBar(title: const Text("")),

        /// 🔥 Swipe + Full Layout
        body: SwipeBackWrapper(child: const LiveLayout()),
      ),
    );
  }
}
