import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:csi_sense/app.dart';
import 'package:csi_sense/core/config/app_settings.dart';
import 'package:csi_sense/core/features/home/live_detection/controllers/detection_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App loads Home Screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppSettings()),

          ChangeNotifierProxyProvider<AppSettings, DetectionController>(
            create: (_) => DetectionController(),
            update: (_, settings, controller) {
              controller ??= DetectionController();

              controller.updateMode(settings.mode);
              controller.updateSensitivity(settings.sensitivity);

              return controller;
            },
          ),
        ],
        child: const HumanDetectionApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("Human Detection System"), findsOneWidget);
  });
}
