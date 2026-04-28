import 'package:flutter/material.dart';
import 'scale_bar.dart';
import 'scale_label.dart';

class ConfidenceScale extends StatelessWidget {
  final double value;

  const ConfidenceScale({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final formattedValue = value.clamp(0, 100).toStringAsFixed(0);

    return Column(
      children: [
        /// 🔥 TITLE + VALUE
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Detection Confidence",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              "$formattedValue%",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        /// 🔥 BAR
        ScaleBar(value: value),

        const SizedBox(height: 6),

        /// 🔥 LABEL (Low / Medium / High)
        ScaleLabel(value: value),
      ],
    );
  }
}
