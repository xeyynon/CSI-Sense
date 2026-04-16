import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:csi_sense/app.dart';
import 'package:csi_sense/core/config/app_settings.dart';
import 'package:csi_sense/core/config/app_mode.dart';
import 'package:csi_sense/core/features/home/live_detection/controllers/detection_controller.dart';
import 'package:csi_sense/core/features/home/live_detection/models/detection_mode.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// 🔧 Helper to build app with providers
  Widget createTestApp() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final settings = AppSettings();
            settings.init();
            return settings;
          },
        ),
        ChangeNotifierProxyProvider<AppSettings, DetectionController>(
          create: (_) => DetectionController(),
          update: (_, settings, controller) {
            controller ??= DetectionController();

            controller.updateMode(settings.mode, settings);
            controller.updateSensitivity(settings.sensitivity);

            return controller;
          },
        ),
      ],
      child: const HumanDetectionApp(),
    );
  }

  /// ✅ TEST 1: App loads correctly
  testWidgets('App loads Home Screen', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();

    expect(find.text("Human Detection System"), findsOneWidget);
  });

  /// ✅ TEST 2: Toggle theme works
  testWidgets('Theme toggle updates UI', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());

    final context = tester.element(find.byType(MaterialApp));
    final settings = Provider.of<AppSettings>(context, listen: false);

    settings.toggleTheme(false);
    await tester.pump();

    expect(settings.isDarkMode, false);
  });

  /// ✅ TEST 3: Mode switching (Online ↔ Offline)
  testWidgets('Mode switching updates controller', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());

    final context = tester.element(find.byType(MaterialApp));
    final settings = Provider.of<AppSettings>(context, listen: false);
    final controller = Provider.of<DetectionController>(context, listen: false);

    /// Switch to offline
    settings.setMode(AppMode.offline);
    controller.updateMode(settings.mode, settings);

    expect(settings.mode, AppMode.offline);

    /// Switch back to online
    settings.setMode(AppMode.online);
    controller.updateMode(settings.mode, settings);

    expect(settings.mode, AppMode.online);
  });

  /// ✅ TEST 4: Detection type switching
  testWidgets('Detection type switching works', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());

    final context = tester.element(find.byType(MaterialApp));
    final settings = Provider.of<AppSettings>(context, listen: false);
    final controller = Provider.of<DetectionController>(context, listen: false);

    controller.setDetectionType(DetectionType.activity, settings);

    expect(controller.currentType, DetectionType.activity);

    controller.setDetectionType(DetectionType.presence, settings);

    expect(controller.currentType, DetectionType.presence);
  });

  /// ✅ TEST 5: API URL update (dynamic config)
  testWidgets('API URL updates correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());

    final context = tester.element(find.byType(MaterialApp));
    final settings = Provider.of<AppSettings>(context, listen: false);

    settings.updateApiUrl("http://192.168.1.5:5000");

    expect(settings.apiBaseUrl, "http://192.168.1.5:5000");
  });

  /// ✅ TEST 6: Replay speed setting
  testWidgets('Replay speed updates', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());

    final context = tester.element(find.byType(MaterialApp));
    final settings = Provider.of<AppSettings>(context, listen: false);

    settings.setReplaySpeed(2.0);

    expect(settings.replaySpeed, 2.0);
  });

  /// ✅ TEST 7: Sound toggle
  testWidgets('Sound toggle works', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());

    final context = tester.element(find.byType(MaterialApp));
    final settings = Provider.of<AppSettings>(context, listen: false);

    settings.toggleSound(true);

    expect(settings.soundEnabled, true);
  });
}
