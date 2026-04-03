import 'package:flutter/material.dart';

import '../detection/detection_dots.dart';
import '../../models/detection_point.dart';

import 'radar_background.dart';
import 'radar_sweep.dart';
import '../../../../../animations/radar_distortion.dart';

class RadarView extends StatelessWidget {
  final List<DetectionPoint> points;

  const RadarView({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final radarSize = screenWidth * 1.3;

    return Center(
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
                  const RadarSweep(),

                  /// ✅ PURE VISUAL
                  DetectionDots(points: points, size: radarSize),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
