import 'package:hive/hive.dart';

import '../../models/detection_result.dart';
import '../../models/detection_mode.dart';

class DetectionHistoryManager {
  // ============================================================
  // 📊 DATA STORAGE
  // ============================================================

  final List<DetectionResult> _history = [];
  final List<DetectionResult> presenceHistory = [];
  final List<DetectionResult> activityHistory = [];

  List<DetectionResult> get history => _history;

  late final Box _box;

  // ============================================================
  // 🔧 INIT
  // ============================================================

  DetectionHistoryManager() {
    _box = Hive.box('history');
  }

  // ============================================================
  // ➕ ADD DATA
  // ============================================================

  void add(
    DetectionResult result,
    DetectionType type,
    Duration historyDuration,
  ) {
    /// 🔥 GLOBAL HISTORY
    _history.add(result);

    /// 🔥 TYPE-SPECIFIC
    if (type == DetectionType.presence) {
      presenceHistory.add(result);
    } else {
      activityHistory.add(result);
    }

    /// ⏱ TIME FILTER
    final cutoff = DateTime.now().subtract(historyDuration);

    _history.removeWhere((e) => e.timestamp.isBefore(cutoff));
    presenceHistory.removeWhere((e) => e.timestamp.isBefore(cutoff));
    activityHistory.removeWhere((e) => e.timestamp.isBefore(cutoff));

    /// 🔥 LIMIT SIZE (avoid memory overflow)
    const maxItems = 300;

    if (_history.length > maxItems) _history.removeAt(0);
    if (presenceHistory.length > maxItems) presenceHistory.removeAt(0);
    if (activityHistory.length > maxItems) activityHistory.removeAt(0);

    /// 💾 SAVE TO HIVE
    _box.add({
      'presence': result.presence,
      'activity': result.activity,
      'distance': result.distance,
      'confidence': result.confidence,
      'timestamp': result.timestamp.toIso8601String(),
      'type': type.name,
    });

    /// 🔥 CLEAN OLD HIVE DATA
    final keysToDelete = _box.keys.where((key) {
      final item = _box.get(key);

      if (item == null || item['timestamp'] == null) return false;

      final time = DateTime.parse(item['timestamp']);
      return time.isBefore(cutoff);
      return time.isBefore(cutoff);
    }).toList();

    _box.deleteAll(keysToDelete);
  }

  // ============================================================
  // 📥 LOAD FROM HIVE
  // ============================================================

  void loadFromStorage() {
    final data = _box.values.toList()
      ..sort(
        (a, b) => DateTime.parse(
          a['timestamp'],
        ).compareTo(DateTime.parse(b['timestamp'])),
      );

    _history.clear();
    presenceHistory.clear();
    activityHistory.clear();
    for (var item in data) {
      try {
        final result = DetectionResult(
          presence: item['presence'] ?? 0,
          activity: item['activity'] ?? 0,
          distance: (item['distance'] ?? 0).toDouble(),
          confidence: (item['confidence'] ?? 0).toDouble(),
          timestamp: DateTime.parse(item['timestamp']),
        );

        _history.add(result);

        if (item['type'] == 'presence') {
          presenceHistory.add(result);
        } else {
          activityHistory.add(result);
        }
      } catch (_) {
        // skip bad data
      }
    }
  }

  // ============================================================
  // 🧹 CLEAR
  // ============================================================

  Future<void> clearAll() async {
    _history.clear();
    presenceHistory.clear();
    activityHistory.clear();

    await _box.clear();
  }

  void clearPresence() {
    presenceHistory.clear();
  }

  void clearActivity() {
    activityHistory.clear();
  }
}
