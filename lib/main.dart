import 'package:csi_sense/core/config/app_settings.dart';
import 'package:csi_sense/core/features/home/live_detection/controllers/detection_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('history');

  runApp(
    MultiProvider(
      providers: [
        /// 🔥 GLOBAL SETTINGS
        ChangeNotifierProvider(
          create: (_) => AppSettings(),
        ),

        /// 🔥 DETECTION CONTROLLER (depends on settings)
        ChangeNotifierProxyProvider<AppSettings, DetectionController>(
          create: (_) => DetectionController(),
          update: (_, settings, controller) {
            controller ??= DetectionController();

            /// 🔥 APPLY SETTINGS TO CONTROLLER
            controller.updateMode(settings.mode);
            controller.updateSensitivity(settings.sensitivity);

            return controller;
          },
        ),
      ],
      child: const HumanDetectionApp(),
    ),
  );
}