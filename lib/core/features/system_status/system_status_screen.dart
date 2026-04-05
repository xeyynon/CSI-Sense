import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home/live_detection/controllers/detection_controller.dart';

class SystemStatusScreen extends StatelessWidget {
  const SystemStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DetectionController>();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("System Status"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            /// 📡 CONNECTION STATUS
            _buildCard(
              title: "Connection",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("API Status"),
                  _statusChip(
                    controller.isConnected ? "Connected" : "Disconnected",
                    controller.isConnected ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ),

            /// ⚙️ MODE
            _buildCard(
              title: "Mode",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Detection Mode"),
                  Text(
                    controller.runtimeType.toString().contains("Offline")
                        ? "Offline"
                        : "Online",
                  ),
                ],
              ),
            ),

            /// 🔴 LIVE STATUS
            _buildCard(
              title: "Live Detection",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Status"),
                  _statusChip(
                    controller.isLiveActive ? "Running" : "Stopped",
                    controller.isLiveActive ? Colors.green : Colors.grey,
                  ),
                ],
              ),
            ),

            /// 📊 DATA
            _buildCard(
              title: "Data",
              child: Column(
                children: [
                  _infoRow(
                    "Total Detections",
                    controller.history.length.toString(),
                  ),
                  _infoRow(
                    "Confidence",
                    "${controller.confidence.toStringAsFixed(1)}%",
                  ),
                  _infoRow(
                    "Last Detection",
                    controller.currentResult?.timestamp
                            .toString()
                            .split(".")
                            .first ??
                        "N/A",
                  ),
                ],
              ),
            ),

            /// 💾 STORAGE
            _buildCard(
              title: "Storage",
              child: _infoRow(
                "Saved Records",
                controller.history.length.toString(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 CARD
  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  /// 🔥 STATUS CHIP
  Widget _statusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(color: color)),
    );
  }

  /// 🔥 INFO ROW
  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
