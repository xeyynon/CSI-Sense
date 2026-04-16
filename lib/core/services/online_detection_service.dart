import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../features/home/live_detection/models/detection_result.dart';
import 'detection_service.dart';
import 'package:csi_sense/core/features/home/live_detection/models/detection_mode.dart';
import 'package:csi_sense/core/config/app_settings.dart';

class OnlineDetectionService implements DetectionService {
  final DetectionType type;
  final AppSettings settings; // ✅ NEW

  final StreamController<DetectionResult> _controller =
      StreamController.broadcast();

  Timer? _timer;

  OnlineDetectionService(this.type, this.settings);

  @override
  Stream<DetectionResult> getDetectionStream() {
    _start();
    return _controller.stream;
  }

  double extractDistance(String label) {
    final regex = RegExp(r'(\d+(\.\d+)?)m');
    final match = regex.firstMatch(label);

    if (match != null) {
      return double.parse(match.group(1)!);
    }

    return 0;
  }

  bool _isRunning = false;
  void _start() {
    if (_isRunning) return;
    _isRunning = true;

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(milliseconds: 1000), (_) async {
      if (settings.apiBaseUrl.isEmpty) {
        _controller.addError("No API URL");
        return;
      }

      final baseUrl = settings.apiBaseUrl;

      final url = type == DetectionType.presence
          ? "$baseUrl/latest/presence"
          : "$baseUrl/latest/activity";

      try {
        final response = await http
            .get(Uri.parse(url))
            .timeout(const Duration(seconds: 3));

        if (response.statusCode != 200) {
          _controller.addError("Bad response");
          return;
        }

        Map<String, dynamic>? data;

        try {
          data = json.decode(response.body);
        } catch (e) {
          _controller.addError("Invalid JSON");
          return;
        }

        if (data == null) return;

        final label = data['label'] ?? "";
        final distance = extractDistance(label);

        final result = DetectionResult(
          presence: type == DetectionType.presence ? 1 : 0,
          activity: type == DetectionType.activity
              ? (data['class_id'] ?? 0)
              : 0,
          distance: distance,
          confidence: (data['confidence'] ?? 0).toDouble() * 100,
          timestamp: DateTime.now(),
        );

        if (!_controller.isClosed) {
          _controller.add(result);
        }
      } catch (e) {
        print("API ERROR: $e");

        if (!_controller.isClosed) {
          _controller.addError(e); // 🔥 KEY FIX
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // ✅ stop timer FIRST
    _isRunning = false;
    if (!_controller.isClosed) {
      _controller.close(); // ✅ then close safely
    }
  }
}
