import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'app_mode.dart';

enum DetectionSensitivity { low, medium, high }

class AppSettings extends ChangeNotifier {
  bool isDarkMode = true;
  AppMode mode = AppMode.online;
  DetectionSensitivity sensitivity = DetectionSensitivity.medium;

  int historyDuration = 10;
  double replaySpeed = 1.0;
  bool soundEnabled = false;

  /// 🔥 NEW: Dynamic offline switch delay (10–30 sec)
  int offlineSwitchDelay = 15;

  /// 🔥 API URL
  String apiBaseUrl = "http://192.168.0.1:5000";

  late Box settingsBox;

  /// ============================================================
  /// 🔧 INIT (LOAD FROM HIVE)
  /// ============================================================
  Future<void> init() async {
    settingsBox = Hive.box('settings');

    apiBaseUrl = settingsBox.get(
      'apiUrl',
      defaultValue: "http://192.168.0.1:5000",
    );

    /// ✅ LOAD OFFLINE DELAY
    offlineSwitchDelay = settingsBox.get('offlineDelay', defaultValue: 15);
  }

  /// ============================================================
  /// 🔥 UPDATE OFFLINE DELAY
  /// ============================================================
  void setOfflineSwitchDelay(int value) {
    offlineSwitchDelay = value.clamp(10, 30); // ✅ safety
    settingsBox.put('offlineDelay', offlineSwitchDelay);
    notifyListeners();
  }

  /// ============================================================
  /// 🔥 API URL
  /// ============================================================
  void updateApiUrl(String url) {
    url = url.trim();

    if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }

    apiBaseUrl = url;
    settingsBox.put('apiUrl', url);

    notifyListeners();
  }

  /// ============================================================
  /// 🎨 UI SETTINGS
  /// ============================================================
  void toggleTheme(bool value) {
    isDarkMode = value;
    notifyListeners();
  }

  void setMode(AppMode newMode) {
    mode = newMode;
    notifyListeners();
  }

  void setSensitivity(DetectionSensitivity value) {
    sensitivity = value;
    notifyListeners();
  }

  void setHistoryDuration(int value) {
    historyDuration = value;
    notifyListeners();
  }

  void setReplaySpeed(double value) {
    replaySpeed = value;
    notifyListeners();
  }

  void toggleSound(bool value) {
    soundEnabled = value;
    notifyListeners();
  }
}
