import 'package:csi_sense/core/animations/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/detection_controller.dart';
import '../radar/radar_view.dart';
import '../radar/radar_sweep.dart';
import '../detection/detection_status_text.dart';
import '../scale/confidence_scale.dart';
import '../../models/detection_mode.dart';
import 'package:csi_sense/core/config/app_settings.dart';

class LiveLayout extends StatefulWidget {
  final DetectionType type;

  const LiveLayout({super.key, required this.type});

  @override
  State<LiveLayout> createState() => _LiveLayoutState();
}

class _LiveLayoutState extends State<LiveLayout> {
  late DetectionController controller;

  @override
  @override
  void initState() {
    super.initState();

    controller = context.read<DetectionController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = context.read<AppSettings>();

      controller.setDetectionType(widget.type, settings); // ✅ SAFE NOW
      controller.isLiveActive = true;
      controller.startDetection();
    });
  }

  @override
  void dispose() {
    // ✅ DO NOT use context here
    controller.isLiveActive = false; // 🔥 stop storing history

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DetectionController>();
    final settings = context.watch<AppSettings>();

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
                  RadarView(points: controller.points),

                  if (!controller.apiConnected && isOnline) const RadarSweep(),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// 🔥 STATUS TEXT
            DetectionStatusText(
              hasDetection: widget.type == DetectionType.presence
                  ? controller.hasDetection
                  : (controller.currentResult?.activity ?? 0) != 0,
              result: controller.currentResult,
              type: widget.type,
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
