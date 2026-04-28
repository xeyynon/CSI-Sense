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
    final now = DateTime.now();
    final cutoff = now.subtract(historyDuration);

    /// 🔥 GLOBAL HISTORY
    _history.add(result);

    /// 🔥 TYPE-SPECIFIC
    if (type == DetectionType.presence) {
      presenceHistory.add(result);
    } else {
      activityHistory.add(result);
    }

    /// ⏱ FILTER OLD DATA
    _history.removeWhere((e) => e.timestamp.isBefore(cutoff));
    presenceHistory.removeWhere((e) => e.timestamp.isBefore(cutoff));
    activityHistory.removeWhere((e) => e.timestamp.isBefore(cutoff));

    /// 🔥 LIMIT SIZE
    const maxItems = 300;
    _trimList(_history, maxItems);
    _trimList(presenceHistory, maxItems);
    _trimList(activityHistory, maxItems);

    /// 💾 SAVE TO HIVE
    _box.add({
      'presence': result.presence,
      'activity': result.activity,
      'distance': result.distance,
      'confidence': result.confidence,
      'timestamp': result.timestamp.toIso8601String(),
      'type': type.name,
      'label': result.label, // ✅ IMPORTANT
    });

    /// 🧹 CLEAN OLD HIVE DATA
    final keysToDelete = _box.keys.where((key) {
      final item = _box.get(key);

      if (item == null || item['timestamp'] == null) return false;

      try {
        final time = DateTime.parse(item['timestamp']);
        return time.isBefore(cutoff);
      } catch (_) {
        return true; // remove corrupted data
      }
    }).toList();

    if (keysToDelete.isNotEmpty) {
      _box.deleteAll(keysToDelete);
    }
  }

  // ============================================================
  // 📥 LOAD FROM HIVE
  // ============================================================

  void loadFromStorage() {
    final data = _box.values.toList()
      ..sort((a, b) {
        try {
          return DateTime.parse(
            a['timestamp'],
          ).compareTo(DateTime.parse(b['timestamp']));
        } catch (_) {
          return 0;
        }
      });

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
          label: item['label'] ?? "", // ✅ IMPORTANT
        );

        _history.add(result);

        if (item['type'] == DetectionType.presence.name) {
          presenceHistory.add(result);
        } else {
          activityHistory.add(result);
        }
      } catch (_) {
        // Skip corrupted entries
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

  // ============================================================
  // 🛠 HELPERS
  // ============================================================

  void _trimList(List<DetectionResult> list, int maxItems) {
    if (list.length > maxItems) {
      list.removeRange(0, list.length - maxItems);
    }
  }
}
