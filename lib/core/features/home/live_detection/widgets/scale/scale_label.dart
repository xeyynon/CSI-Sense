import 'package:flutter/material.dart';

class ScaleLabel extends StatelessWidget {
  final double value;

  const ScaleLabel({super.key, required this.value});

  String getLabel(double value) {
    if (value < 40) return "Low";
    if (value < 70) return "Medium";
    return "High";
  }

  Color getColor(double value) {
    if (value < 40) return Colors.redAccent;
    if (value < 70) return Colors.orangeAccent;
    return Colors.greenAccent;
  }

  @override
  Widget build(BuildContext context) {
    final label = getLabel(value);
    final color = getColor(value);

    return Text(
      label,
      style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500),
    );
  }
}
