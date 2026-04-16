import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:csi_sense/core/config/app_settings.dart';
import 'package:csi_sense/core/features/home/live_detection/controllers/detection_controller.dart';
import 'package:csi_sense/core/config/app_mode.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final controller = context.read<DetectionController>();

    final TextEditingController apiController = TextEditingController(
      text: settings.apiBaseUrl,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Settings"), centerTitle: true),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// 🌙 APPEARANCE
          _section("Appearance"),
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: settings.isDarkMode,
            onChanged: settings.toggleTheme,
          ),

          const SizedBox(height: 16),

          /// 📡 DETECTION
          _section("Detection"),

          /// 🔥 MODE
          ListTile(
            title: const Text("Mode"),
            trailing: DropdownButton<AppMode>(
              value: settings.mode,
              items: AppMode.values.map((mode) {
                return DropdownMenuItem(
                  value: mode,
                  child: Text(mode.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  settings.setMode(value);
                  controller.updateMode(value, settings); // ✅ important
                }
              },
            ),
          ),

          /// 🔥 SENSITIVITY
          ListTile(
            title: const Text("Sensitivity"),
            trailing: DropdownButton<DetectionSensitivity>(
              value: settings.sensitivity,
              items: DetectionSensitivity.values.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(level.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  settings.setSensitivity(value);
                  controller.updateSensitivity(value);
                }
              },
            ),
          ),

          const SizedBox(height: 16),

          /// 🌐 API CONNECTION
          _section("API Connection"),

          TextField(
            controller: apiController,
            decoration: const InputDecoration(
              labelText: "API Base URL",
              hintText: "http://192.168.x.x:5000",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 10),

          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text("Save API URL"),
            onPressed: () {
              settings.updateApiUrl(apiController.text.trim());
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("API URL saved")));
            },
          ),

          const SizedBox(height: 10),

          /// 🔥 API STATUS
          ListTile(
            title: const Text("API Status"),
            subtitle: Text(
              controller.apiConnected ? "Connected" : "Disconnected",
              style: TextStyle(
                color: controller.apiConnected ? Colors.green : Colors.red,
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// 🔥 OFFLINE SWITCH CONTROL (NEW)
          _section("Connection Control"),

          Text("Offline Switch Delay: ${settings.offlineSwitchDelay}s"),

          Slider(
            value: settings.offlineSwitchDelay.toDouble(),
            min: 10,
            max: 30,
            divisions: 20,
            label: "${settings.offlineSwitchDelay}s",
            onChanged: (value) {
              settings.setOfflineSwitchDelay(value.toInt());
            },
          ),

          const SizedBox(height: 8),

          const Text(
            "Auto switch to offline if API fails",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),

          const SizedBox(height: 16),

          /// 📊 HISTORY
          _section("History"),

          Text("Duration: ${settings.historyDuration} min"),
          Slider(
            value: settings.historyDuration.toDouble(),
            min: 1,
            max: 30,
            divisions: 29,
            label: "${settings.historyDuration}",
            onChanged: (value) {
              settings.setHistoryDuration(value.toInt());
            },
          ),

          ElevatedButton.icon(
            onPressed: () {
              controller.clearHistory();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("History cleared")));
            },
            icon: const Icon(Icons.delete),
            label: const Text("Reset History"),
          ),

          const SizedBox(height: 16),

          /// 🎬 REPLAY
          _section("Replay"),

          ListTile(
            title: const Text("Playback Speed"),
            trailing: DropdownButton<double>(
              value: settings.replaySpeed,
              items: const [
                DropdownMenuItem(value: 0.5, child: Text("0.5x")),
                DropdownMenuItem(value: 1.0, child: Text("1x")),
                DropdownMenuItem(value: 2.0, child: Text("2x")),
              ],
              onChanged: (value) {
                if (value != null) {
                  settings.setReplaySpeed(value);
                }
              },
            ),
          ),

          const SizedBox(height: 16),

          /// 🔔 SOUND
          _section("Notifications"),

          SwitchListTile(
            title: const Text("Detection Sound"),
            value: settings.soundEnabled,
            onChanged: settings.toggleSound,
          ),

          const SizedBox(height: 16),

          /// ⚙️ SYSTEM
          _section("System"),

          ListTile(
            title: const Text("Live Status"),
            subtitle: Text(controller.isLiveActive ? "ACTIVE" : "IDLE"),
          ),

          const ListTile(title: Text("Version"), subtitle: Text("1.0.0")),
        ],
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }
}
