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

    remainingSeconds = settings.offlineSwitchDelay;

    countdownTimer?.cancel();
    countdownTimer = null;

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainingSeconds = (remainingSeconds - 1).clamp(0, 9999);

      onTick();

      if (remainingSeconds <= 0) {
        timer.cancel();
        countdownTimer = null;
        isCountingDown = false;

        settings.setMode(AppMode.offline);
        onSwitchToOffline();
      }
    });
  }

  void stop() {
    countdownTimer?.cancel();
    countdownTimer = null;
    isCountingDown = false;
    remainingSeconds = 0;
  }
}
