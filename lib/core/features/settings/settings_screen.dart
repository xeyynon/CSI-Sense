import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:csi_sense/core/config/app_settings.dart';
import 'package:csi_sense/core/features/home/live_detection/controllers/detection_controller.dart';

import 'package:csi_sense/core/config/app_settings.dart';
import 'package:csi_sense/core/config/app_mode.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final controller = context.read<DetectionController>();

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
                if (value != null) settings.setMode(value);
              },
            ),
          ),

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
                if (value != null) settings.setSensitivity(value);
              },
            ),
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
            onPressed: () async {
              await controller.clearHistory();
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
                if (value != null) settings.setReplaySpeed(value);
              },
            ),
          ),

          const SizedBox(height: 16),

          /// 🔔 NOTIFICATIONS
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
            title: const Text("Status"),
            subtitle: Text(controller.isLiveActive ? "ACTIVE" : "IDLE"),
          ),

          const ListTile(title: Text("Version"), subtitle: Text("0.0.0")),
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
