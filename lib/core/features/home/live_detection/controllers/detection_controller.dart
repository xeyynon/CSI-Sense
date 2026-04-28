import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../../../core/config/app_mode.dart';
import '../../../../../../core/config/app_settings.dart';
import '../../../../../../core/services/offline_detection_service.dart';
import '../../../../../../core/services/online_detection_service.dart';

import '../models/detection_mode.dart';
import '../models/detection_result.dart';
import '../models/detection_point.dart';

import 'managers/detection_stream_manager.dart';
import 'managers/detection_state_manager.dart';
import 'managers/detection_history_manager.dart';
import 'managers/detection_failure_manager.dart';

enum ConnectionStateStatus { connected, connecting, disconnected }

class DetectionController extends ChangeNotifier {
  final streamManager = DetectionStreamManager();
  final stateManager = DetectionStateManager();
  final historyManager = DetectionHistoryManager();
  final failureManager = DetectionFailureManager();

  ConnectionStateStatus connectionState = ConnectionStateStatus.disconnected;

  DetectionType currentType = DetectionType.presence;
  DetectionType? _lastStartedType; // 🔥 IMPORTANT FIX

  bool isLiveActive = false;
  bool apiConnected = true;
  bool get isPinging => stateManager.isPinging;

  Duration historyDuration = const Duration(minutes: 5);

  AppMode _currentMode = AppMode.online;
  late AppSettings _settings;

  // ============================================================
  // 🌐 CONNECTION CHECK
  // ============================================================

  void startConnecting(AppSettings settings) {
    connectionState = ConnectionStateStatus.connecting;
    notifyListeners();

    int maxSeconds = settings.offlineSwitchDelay;
    int elapsed = 0;

    Timer.periodic(const Duration(seconds: 1), (timer) async {
      elapsed++;

      try {
        final response = await http
            .get(Uri.parse("${settings.apiBaseUrl}/latest/presence"))
            .timeout(const Duration(seconds: 3));

        if (response.statusCode == 200) {
          connectionState = ConnectionStateStatus.connected;
          apiConnected = true;

          timer.cancel();

          settings.setMode(AppMode.online);
          updateMode(AppMode.online, settings);

          notifyListeners();
          return;
        }
      } catch (_) {}

      if (elapsed >= maxSeconds) {
        connectionState = ConnectionStateStatus.disconnected;
        apiConnected = false;

        timer.cancel();

        settings.setMode(AppMode.offline);
        updateMode(AppMode.offline, settings);

        notifyListeners();
      }
    });
  }

  void connect(AppSettings settings) {
    apiConnected = true;
    failureManager.stop();
    updateMode(AppMode.online, settings);
    notifyListeners();
  }

  void disconnect() {
    apiConnected = false;
    streamManager.stop();
    failureManager.stop();
    notifyListeners();
  }

  void retry(AppSettings settings) {
    disconnect();
    Future.delayed(const Duration(milliseconds: 500), () {
      connect(settings);
    });
  }

  // ============================================================
  // 🚀 START
  // ============================================================

  void startDetection() {
    updateMode(_currentMode, _settings);
  }

  // ============================================================
  // 🔁 MODE (🔥 FIXED)
  // ============================================================

  void updateMode(AppMode mode, AppSettings settings) {
    _settings = settings;

    // 🔥 Skip ONLY if BOTH mode AND type same
    if (_currentMode == mode &&
        streamManager.isRunning &&
        _lastStartedType == currentType) {
      return;
    }

    _currentMode = mode;

    // 🔥 ALWAYS stop old stream
    streamManager.stop();

    final service = mode == AppMode.offline
        ? OfflineDetectionService(currentType)
        : OnlineDetectionService(currentType, settings);

    // 🔥 track last type
    _lastStartedType = currentType;

    streamManager.start(service: service, onData: _onData, onError: _onError);

    notifyListeners();
  }

  // ============================================================
  // 🔄 TYPE (🔥 FIXED)
  // ============================================================

  void setDetectionType(DetectionType type, AppSettings settings) {
    if (currentType == type) return;

    currentType = type;

    // 🔥 Force restart via updateMode
    updateMode(_currentMode, settings);
  }

  // ============================================================
  // 📡 STREAM DATA
  // ============================================================

  void _onData(DetectionResult result) {
    if (!isLiveActive) return;

    if (_currentMode == AppMode.online) {
      apiConnected = true;
      failureManager.stop();
    }

    stateManager.update(result, currentType);

    historyManager.add(result, currentType, historyDuration);

    notifyListeners();
  }

  void _onError(Object error) {
    if (_currentMode == AppMode.offline) return;

    apiConnected = false;

    stateManager.points = <DetectionPoint>[];
    stateManager.confidence = 0;
    stateManager.currentResult = null;

    if (!failureManager.isCountingDown) {
      failureManager.start(
        settings: _settings,
        onTick: notifyListeners,
        onSwitchToOffline: () {
          updateMode(AppMode.offline, _settings);
        },
      );
    }

    notifyListeners();
  }

  // ============================================================
  // 📜 HISTORY
  // ============================================================

  List<DetectionResult> get presenceHistory => historyManager.presenceHistory;
  List<DetectionResult> get activityHistory => historyManager.activityHistory;

  void clearHistory() {
    historyManager.clearAll();
    notifyListeners();
  }

  // ============================================================
  // ⚙️ SETTINGS
  // ============================================================

  DetectionSensitivity _sensitivity = DetectionSensitivity.medium;

  void updateSensitivity(DetectionSensitivity sensitivity) {
    _sensitivity = sensitivity;
    notifyListeners();
  }

  // ============================================================
  // 📡 UI HELPERS
  // ============================================================

  List<DetectionPoint> get points => stateManager.points;
  double get confidence => stateManager.confidence;
  DetectionResult? get currentResult => stateManager.currentResult;

  bool get hasDetection => stateManager.points.isNotEmpty;

  int get remainingSeconds => failureManager.remainingSeconds;

  bool get isOfflineMode => _currentMode == AppMode.offline;

  // ============================================================
  // 🧹 DISPOSE
  // ============================================================

  @override
  void dispose() {
    streamManager.dispose();
    super.dispose();
  }
}
