import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/live_detection/controllers/detection_controller.dart';
import '../../config/app_settings.dart';
import '../../config/app_mode.dart';

class SystemStatusScreen extends StatelessWidget {
  const SystemStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DetectionController>();
    final settings = context.watch<AppSettings>();

    final TextEditingController apiController = TextEditingController(
      text: settings.apiBaseUrl,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("System Status"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            /// 🔥 API CONNECTION (MAIN)
            _buildCard(
              title: "API Connection",
              child: Column(
                children: [
                  TextField(
                    controller: apiController,
                    decoration: const InputDecoration(
                      labelText: "API Base URL",
                      hintText: "http://192.168.x.x:5000",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.save),
                          label: const Text("Save"),
                          onPressed: () {
                            settings.updateApiUrl(apiController.text.trim());

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("API URL Saved")),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text("Reconnect"),
                          onPressed: () {
                            controller.updateMode(settings.mode, settings);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Reconnecting...")),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// 🔥 STATUS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Connection Status"),
                      _statusChip(
                        controller.apiConnected ? "Connected" : "Disconnected",
                        controller.apiConnected ? Colors.green : Colors.red,
                      ),
                    ],
                  ),

                  /// 🔥 COUNTDOWN
                  if (!controller.apiConnected &&
                      settings.mode == AppMode.online)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "Switching to offline in ${controller.remainingSeconds}s",
                        style: const TextStyle(color: Colors.redAccent),
                      ),
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
                  Text(settings.mode.name.toUpperCase()),
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
                    "Presence Records",
                    controller.presenceHistory.length.toString(),
                  ),
                  _infoRow(
                    "Activity Records",
                    controller.activityHistory.length.toString(),
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
        color: color.withOpacity(0.1),
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
