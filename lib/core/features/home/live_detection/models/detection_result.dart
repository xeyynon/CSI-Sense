class DetectionResult {
  final int presence;
  final int activity;
  final double distance;
  final double confidence;
  final DateTime timestamp;
  final String label; // ✅ NEW

  DetectionResult({
    required this.presence,
    required this.activity,
    required this.distance,
    required this.confidence,
    required this.timestamp,
    required this.label,
  });

  bool get hasPresence => presence == 1;
  bool get hasActivity => activity != 0;
}
