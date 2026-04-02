import 'package:flutter/material.dart';
import 'scale_bar.dart';
import 'scale_label.dart';

class ConfidenceScale extends StatelessWidget {
  final double value;

  const ConfidenceScale({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Detection Confidence"),
        const SizedBox(height: 8),
        ScaleBar(value: value),
        const SizedBox(height: 8),
        ScaleLabel(value: value),
      ],
    );
  }
}