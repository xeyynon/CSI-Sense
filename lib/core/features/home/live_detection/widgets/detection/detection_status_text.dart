import 'package:flutter/material.dart';

class DetectionStatusText extends StatelessWidget {
  final bool detected;

  const DetectionStatusText({super.key, required this.detected});

  @override
  Widget build(BuildContext context) {
    return Text(
      detected ? "Human Detected" : "No Human Detected",
      style: TextStyle(
        color: detected ? Colors.greenAccent : Colors.redAccent,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
