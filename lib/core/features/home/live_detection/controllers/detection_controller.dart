import 'package:flutter/material.dart';

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

class DetectionController extends ChangeNotifier {
  final streamManager = DetectionStreamManager();
  final stateManager = DetectionStateManager();
  final historyManager = DetectionHistoryManager();
  final failureManager = DetectionFailureManager();

  DetectionType currentType = DetectionType.presence;

  bool isLiveActive = false;
  bool apiConnected = true;

  Duration historyDuration = const Duration(minutes: 5);

  AppMode _currentMode = AppMode.online;
  late AppSettings _settings;

  // ============================================================
  // 🚀 START
  // ============================================================

  void startDetection() {
    updateMode(_currentMode, _settings);
  }

  // ============================================================
  // 🔁 MODE
  // ============================================================

  void updateMode(AppMode mode, AppSettings settings) {
    _settings = settings;

    if (_currentMode == mode && streamManager.isRunning) return;

    _currentMode = mode;

    final service = mode == AppMode.offline
        ? OfflineDetectionService(currentType)
        : OnlineDetectionService(currentType, settings);

    streamManager.start(service: service, onData: _onData, onError: _onError);

    notifyListeners();
  }

  // ============================================================
  // 🔄 TYPE
  // ============================================================

  void setDetectionType(DetectionType type, AppSettings settings) {
    currentType = type;
    updateMode(_currentMode, settings);
  }

  // ============================================================
  // 📡 STREAM DATA
  // ============================================================

  void _onData(DetectionResult result) {
    if (!isLiveActive) return;

    /// ✅ ONLY ONLINE MODE CONTROLS CONNECTION
    if (_currentMode == AppMode.online) {
      if (result.confidence > 0) {
        apiConnected = true;
        failureManager.stop(); // 🔥 stop countdown
      }
    }

    stateManager.update(result, currentType);
    historyManager.add(result, currentType, historyDuration);

    notifyListeners();
  }

  void _onError(Object error) {
    if (_currentMode == AppMode.offline) return;

    apiConnected = false;

    /// 🔥 CLEAR RADAR
    stateManager.points = <DetectionPoint>[];
    stateManager.confidence = 0;
    stateManager.currentResult = null;

    /// 🔥 START COUNTDOWN (ONLY ONCE)
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
