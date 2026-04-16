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

  void startReplay() {
    final controller = context.read<DetectionController>();
    final data = getData(controller);

    if (data.isEmpty) return;

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (currentIndex >= data.length) {
        timer.cancel();
        return;
      }

      final result = data[currentIndex];

      setState(() {
        currentPoints = _convertToPoints(result);
      });

      currentIndex++;
    });
  }

  List<DetectionPoint> _convertToPoints(result) {
    if (widget.type == DetectionType.presence) {
      if (!result.hasPresence) return [];

      final normalizedY = (result.distance / 16.6).clamp(0.0, 1.0);

      return [DetectionPoint(x: 0.5, y: normalizedY)];
    } else {
      /// 🔥 ACTIVITY MODE
      if (result.activity <= 0) return [];

      return List.generate(
        result.activity.clamp(1, 5),
        (_) => DetectionPoint(
          x: (0.2 + (0.6 * (DateTime.now().millisecond % 100) / 100)),
          y: (0.2 + (0.6 * (DateTime.now().millisecond % 100) / 100)),
        ),
      );
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
