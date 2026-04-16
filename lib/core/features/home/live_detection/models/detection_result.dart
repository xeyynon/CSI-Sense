class DetectionResult {
  final int presence;
  final int activity;
  final double distance; // ✅ REAL DISTANCE
  final double confidence;
  final DateTime timestamp;

  DetectionResult({
    required this.presence,
    required this.activity,
    required this.distance, // ✅ REQUIRED
    required this.confidence,
    required this.timestamp,
  });

  bool get hasPresence => presence != 0;
}
