import 'package:flutter/material.dart';

class HistoryDetailScreen extends StatelessWidget {
  final String title;
  final String type;
  final bool isReplay;
  const HistoryDetailScreen({
    super.key,
    required this.title,
    required this.type,
    required this.isReplay,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),

      body: Column(
        children: [
          /// 🔥 RADAR REPLAY (placeholder)
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                "Radar Replay ($type)",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),

          /// 🔥 LOG LIST
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: 10, // temporary
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.circle),
                  title: Text("$type event #$index"),
                  subtitle: const Text("Timestamp"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
