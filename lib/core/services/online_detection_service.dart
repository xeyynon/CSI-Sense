import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../features/home/live_detection/models/detection_result.dart';
import 'detection_service.dart';
import 'package:csi_sense/core/features/home/live_detection/models/detection_mode.dart';
import 'package:csi_sense/core/config/app_settings.dart';

class OnlineDetectionService implements DetectionService {
  final DetectionType type;
  final AppSettings settings;

  final StreamController<DetectionResult> _controller =
      StreamController.broadcast();

  Timer? _timer;
  bool _isRunning = false;

  OnlineDetectionService(this.type, this.settings);

  @override
  Stream<DetectionResult> getDetectionStream() {
    _start();
    return _controller.stream;
  }

  // ============================================================
  // 📏 DISTANCE EXTRACTION
  // ============================================================

  double extractDistance(String label) {
    final regex = RegExp(r'(\d+(\.\d+)?)m');
    final match = regex.firstMatch(label);

    if (match != null) {
      return double.tryParse(match.group(1) ?? "") ?? 0;
    }
    return 0;
  }

  // ============================================================
  // ▶ START STREAM
  // ============================================================

  void _start() {
    if (_isRunning) return;
    _isRunning = true;

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      final baseUrl = settings.apiBaseUrl;

      if (baseUrl.isEmpty) {
        _controller.addError("No API URL");
        return;
      }

      final url = type == DetectionType.presence
          ? "$baseUrl/latest/presence"
          : "$baseUrl/latest/activity";

      try {
        final uri = Uri.tryParse(url);
        if (uri == null) {
          _controller.addError("Invalid URL");
          return;
        }

        final response = await http
            .get(uri, headers: const {"Content-Type": "application/json"})
            .timeout(const Duration(seconds: 3));

        if (response.statusCode != 200) {
          _controller.addError("HTTP ${response.statusCode}");
          return;
        }

        Map<String, dynamic> data;

        try {
          data = json.decode(response.body);
        } catch (_) {
          _controller.addError("Invalid JSON");
          return;
        }

        final label = (data['label'] ?? "").toString();

        final confidence = ((data['confidence'] ?? 0) as num).toDouble() * 100;

        final double distance = type == DetectionType.presence
            ? extractDistance(label)
            : 0.0;

        final int activityId = type == DetectionType.activity
            ? int.tryParse(data['class_id'].toString()) ?? 0
            : 0;

        final result = DetectionResult(
          presence: type == DetectionType.presence ? 1 : 0,
          activity: activityId,
          distance: distance,
          confidence: confidence.clamp(0, 100),
          timestamp: DateTime.fromMillisecondsSinceEpoch(
            ((data['timestamp'] ?? 0) as num).toDouble() * 1000 ~/ 1,
          ),
          label: label,
        );

        if (!_controller.isClosed) {
          _controller.add(result);
        }
      } catch (e) {
        if (!_controller.isClosed) {
          _controller.addError(e.toString());
        }
      }
    });
  }

  // ============================================================
  // 🧹 CLEANUP
  // ============================================================

  @override
  void dispose() {
    _timer?.cancel();
    _isRunning = false;

    if (!_controller.isClosed) {
      _controller.close();
    }
  }
}
