import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/live_detection/controllers/detection_controller.dart';
import '../../config/app_settings.dart';

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
            /// 🔥 API CONNECTION
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

                  /// 🔥 ACTION BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.save),
                          label: const Text("Save & Connect"),
                          onPressed: () {
                            final url = apiController.text.trim();

                            settings.updateApiUrl(url);

                            /// 🔥 START CONNECTION FLOW
                            controller.startConnecting(settings);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Connecting to API..."),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text("Retry"),
                          onPressed: () {
                            controller.startConnecting(settings);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Retrying connection..."),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// 🔥 CONNECTION STATUS CHIP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Connection Status"),
                      _statusChip(controller),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// 🔥 LIVE PING INDICATOR
                  Row(
                    children: [
                      const Text("Live Ping: "),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: controller.isPinging
                              ? Colors.greenAccent
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(controller.isPinging ? "Receiving data..." : "Idle"),
                    ],
                  ),

                  /// 🔥 COUNTDOWN (ONLY DURING CONNECTING)
                  if (controller.connectionState ==
                      ConnectionStateStatus.connecting)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Retrying... ${controller.remainingSeconds}s left",
                        style: const TextStyle(color: Colors.orange),
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
                  _simpleChip(
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

  /// 🔥 STATUS CHIP WITH STATES
  Widget _statusChip(DetectionController controller) {
    String text;
    Color color;

    switch (controller.connectionState) {
      case ConnectionStateStatus.connected:
        text = "Connected";
        color = Colors.green;
        break;

      case ConnectionStateStatus.connecting:
        text = "Connecting";
        color = Colors.orange;
        break;

      case ConnectionStateStatus.disconnected:
        text = "Disconnected";
        color = Colors.red;
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          /// 🔥 BLINKING DOT
          AnimatedOpacity(
            opacity:
                controller.connectionState == ConnectionStateStatus.connecting
                ? 1
                : 0.6,
            duration: const Duration(milliseconds: 500),
            child: Icon(Icons.circle, color: color, size: 10),
          ),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  /// 🔥 SIMPLE CHIP
  Widget _simpleChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(color: color)),
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
