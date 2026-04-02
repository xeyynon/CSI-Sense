import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/detection_controller.dart';
import '../detection/detection_dots.dart';
import '../detection/detection_status_text.dart';
import '../scale/confidence_scale.dart';

import 'radar_background.dart';
import 'radar_animation.dart';

import 'radar_sweep.dart';

import '../../../../../animations/glow_animation.dart';
import '../../../../../animations/radar_distortion.dart';

class RadarView extends StatelessWidget {
  const RadarView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<DetectionController>(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final radarSize = screenWidth * 1.3; //

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// RADAR AREA
        Center(
          child: Hero(
            tag: "Live Detection",
            child: SizedBox(
              width: radarSize,
              height: radarSize / 1.2,
              child: RadarDistortion(
                child: ClipOval(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const RadarBackground(),
                      const RadarAnimation(),
                      const RadarSweep(),
                      DetectionDots(points: controller.points, size: radarSize),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        /// STATUS TEXT
        DetectionStatusText(detected: controller.hasDetection),

        const SizedBox(height: 20),

        /// CONFIDENCE SCALE
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConfidenceScale(value: controller.confidence),
        ),
      ],
    );
  }
}
