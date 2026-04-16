import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../../core/config/app_mode.dart';
import '../../../../../../core/config/app_settings.dart';

class DetectionFailureManager {
  int remainingSeconds = 60;
  Timer? countdownTimer;
  bool isCountingDown = false;

  void start({
    required VoidCallback onTick,
    required VoidCallback onSwitchToOffline,
    required AppSettings settings,
  }) {
    if (isCountingDown) return;

    isCountingDown = true;

    /// ✅ USE DYNAMIC VALUE
    remainingSeconds = settings.offlineSwitchDelay;

    countdownTimer?.cancel();

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainingSeconds--;

      onTick();

      if (remainingSeconds <= 0) {
        timer.cancel();
        isCountingDown = false;

        settings.setMode(AppMode.offline);
        onSwitchToOffline();
      }
    });
  }

  void stop() {
    countdownTimer?.cancel();
    isCountingDown = false;
    remainingSeconds = 0;
  }
}
