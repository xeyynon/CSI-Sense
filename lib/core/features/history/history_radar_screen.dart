import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/live_detection/controllers/detection_controller.dart';
import '../home/live_detection/models/detection_point.dart';
import '../home/live_detection/models/detection_mode.dart';
import '../home/live_detection/widgets/radar/radar_view.dart';

class HistoryRadarScreen extends StatefulWidget {
  final DetectionType type; // ✅ ADD

  const HistoryRadarScreen({
    super.key,
    required this.type, // ✅ ADD
  });

  @override
  State<HistoryRadarScreen> createState() => _HistoryRadarScreenState();
}

class _HistoryRadarScreenState extends State<HistoryRadarScreen> {
  int currentIndex = 0;
  Timer? _timer;

  List<DetectionPoint> currentPoints = [];

  List getData(DetectionController controller) {
    return widget.type == DetectionType.presence
        ? controller.presenceHistory
        : controller.activityHistory;
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      startReplay();
    });
  }

  void startReplay() async {
    final controller = context.read<DetectionController>();
    final data = getData(controller);

    if (data.isEmpty) return;

    _timer?.cancel();

    currentIndex = 0;

    for (int i = 0; i < data.length - 1; i++) {
      if (!mounted) return;

      final current = data[i];
      final next = data[i + 1];

      setState(() {
        currentPoints = _convertToPoints(current);
        currentIndex = i;
      });

      final delay = next.timestamp.difference(current.timestamp);

      await Future.delayed(
        delay.inMilliseconds > 0 ? delay : const Duration(milliseconds: 500),
      );
    }
  }

  List<DetectionPoint> _convertToPoints(result) {
    if (widget.type == DetectionType.presence) {
      if (!result.hasPresence) return [];

      final normalizedY = (result.distance / 16.6).clamp(0.0, 1.0);

      return [DetectionPoint(x: 0.5, y: normalizedY)];
    } else {
      if (result.activity <= 0) return [];

      return List.generate(result.activity.clamp(1, 5), (index) {
        final angle = (index / result.activity) * 3.14 * 2;
        final radius = 0.3;

        return DetectionPoint(
          x: 0.5 + radius * (index.isEven ? 1 : -1),
          y: 0.5 + radius * (index % 2 == 0 ? 1 : -1),
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DetectionController>();
    final data = getData(controller);
    final total = data.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.type == DetectionType.presence
              ? "Presence Replay"
              : "Activity Replay",
        ),
      ),

      body: Column(
        children: [
          /// 🔥 RADAR
          Expanded(
            child: Center(child: RadarView(points: currentPoints)),
          ),

          /// 🔥 SLIDER
          if (total > 0)
            Slider(
              value: currentIndex.toDouble().clamp(0, total.toDouble()),
              min: 0,
              max: total.toDouble(),
              onChanged: (value) {
                setState(() {
                  currentIndex = value.toInt();

                  if (currentIndex < total) {
                    currentPoints = _convertToPoints(data[currentIndex]);
                  }
                });
              },
            ),

          /// 🔥 CONTROLS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: startReplay,
              ),
              IconButton(
                icon: const Icon(Icons.pause),
                onPressed: () {
                  _timer?.cancel();
                },
              ),
              IconButton(
                icon: const Icon(Icons.restart_alt),
                onPressed: () {
                  currentIndex = 0;
                  startReplay();
                },
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
