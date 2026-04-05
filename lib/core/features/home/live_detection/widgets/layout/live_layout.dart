import 'package:csi_sense/core/animations/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/detection_controller.dart';
import '../radar/radar_view.dart';
import '../detection/detection_status_text.dart';
import '../scale/confidence_scale.dart';
import '../../models/detection_mode.dart';

class LiveLayout extends StatelessWidget {
  final DetectionType type;

  const LiveLayout({super.key, required this.type});

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

            const SizedBox(height: 10),

            /// 🔥 SUBTITLE
            const Text(
              "Scanning Environment...",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            /// 🔥 RADAR (CONNECTED TO CONTROLLER)
            Expanded(
              flex: 5,
              child: Center(
                child: RadarView(
                  points: controller.points, // ✅ IMPORTANT
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// 🔥 STATUS TEXT (UPDATED)
            DetectionStatusText(
              hasDetection: controller.hasDetection,
              distance: controller.currentResult?.distance,
              activity: controller.currentResult?.activity,
            ),

            const SizedBox(height: 10),

            /// 🔥 DIVIDER
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              color: Colors.white.withValues(alpha: 0.1),
            ),

            const SizedBox(height: 10),

            /// 🔥 CONFIDENCE SCALE
            ConfidenceScale(value: controller.confidence),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
