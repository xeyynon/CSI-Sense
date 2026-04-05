import 'package:flutter/material.dart';
import 'app_mode.dart';

enum DetectionSensitivity { low, medium, high }

class AppSettings extends ChangeNotifier {
  bool isDarkMode = true;
  AppMode mode = AppMode.offline;
  DetectionSensitivity sensitivity = DetectionSensitivity.medium;

  int historyDuration = 10;
  double replaySpeed = 1.0;
  bool soundEnabled = false;

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
