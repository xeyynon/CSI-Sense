class DetectionResult {
  final int presence;
  final int activity;
  final DateTime timestamp;

  DetectionResult({
    required this.presence,
    required this.activity,
    required this.timestamp,
  });

  double get distance {
    switch (presence) {
      case 1:
        return 1.8;
      case 2:
        return 5.4;
      case 3:
        return 9.4;
      case 4:
        return 13.0;
      case 5:
        return 16.6;
      default:
        return 0;
    }
  }

  bool get hasPresence => presence != 0;
}
