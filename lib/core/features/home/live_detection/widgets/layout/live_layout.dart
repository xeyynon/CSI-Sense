import 'package:csi_sense/core/animations/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/detection_controller.dart';
import '../radar/radar_view.dart';
import '../detection/detection_status_text.dart';
import '../scale/confidence_scale.dart';

class LiveLayout extends StatelessWidget {
  const LiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<DetectionController>(context);

    return AnimatedBackground(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            /// 🔥 TITLE
            const Text(
              "Live Detection",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 RADAR (MAIN FOCUS)
            const Expanded(flex: 5, child: Center(child: RadarView())),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
