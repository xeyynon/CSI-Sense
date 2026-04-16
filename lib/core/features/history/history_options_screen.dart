import 'package:flutter/material.dart';
import 'history_detail_screen.dart';

class HistoryOptionsScreen extends StatelessWidget {
  final String title;
  final String type;

  const HistoryOptionsScreen({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),

      body: Center(
        child: SizedBox(
          width: 260,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCard(context, "Radar Replay", Icons.radar, true),

              const SizedBox(height: 20),

              _buildCard(context, "Detection Logs", Icons.list, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String text,
    IconData icon,
    bool isReplay,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HistoryDetailScreen(
              title: text,
              type: type,
              isReplay: isReplay,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Icon(icon, size: 40),
              const SizedBox(height: 10),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
