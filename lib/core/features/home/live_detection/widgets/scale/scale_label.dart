import 'package:flutter/material.dart';

class ScaleLabel extends StatelessWidget {
  final double value;

  const ScaleLabel({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text("${value.toStringAsFixed(1)}%");
  }
}