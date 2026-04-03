import 'package:csi_sense/core/features/home/live_detection/controllers/detection_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('history'); // 🔥 storage box
  runApp(
    ChangeNotifierProvider(
      create: (_) {
        final controller = DetectionController();
        controller.loadHistoryFromStorage(); //Load Old Data
        controller.startSimulation(); // 🔥 start once globally
        return controller;
      },
      child: const HumanDetectionApp(),
    ),
  );
}
