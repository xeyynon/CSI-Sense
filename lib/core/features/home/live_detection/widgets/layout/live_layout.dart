import 'package:csi_sense/core/animations/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/detection_controller.dart';
import '../radar/radar_view.dart';
import '../radar/radar_sweep.dart'; // ✅ ADD THIS
import '../detection/detection_status_text.dart';
import '../scale/confidence_scale.dart';
import '../../models/detection_mode.dart';
import 'package:csi_sense/core/config/app_settings.dart';

class LiveLayout extends StatelessWidget {
  final DetectionType type;

  const LiveLayout({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DetectionController>();
    final settings = context.watch<AppSettings>();

    /// 🔊 SOUND TRIGGER (basic hook)
    if (settings.soundEnabled && controller.hasDetection) {
      // TODO: integrate audio player here
      // (we will plug real sound next step)
    }

    final isOnline = settings.mode.name == "online";

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

            /// 🔥 MODE + STATUS
            Column(
              children: [
                Text(
                  isOnline ? "🌐 ONLINE MODE" : "📴 OFFLINE MODE",
                  style: TextStyle(
                    fontSize: 13,
                    color: isOnline ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(height: 4),

                if (!controller.apiConnected && isOnline)
                  Text(
                    "Switching to offline in ${controller.remainingSeconds}s",
                    style: const TextStyle(color: Colors.redAccent),
                  )
                else
                  const Text(
                    "Scanning Environment...",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔥 RADAR + SWEEP
            Expanded(
              flex: 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /// ✅ RADAR ALWAYS VISIBLE
                  RadarView(points: controller.points),

                  /// 🔥 SWEEP (ONLY WHEN API DISCONNECTED)
                  if (!controller.apiConnected && isOnline) const RadarSweep(),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// 🔥 STATUS TEXT
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
              color: Colors.white.withOpacity(0.1),
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
