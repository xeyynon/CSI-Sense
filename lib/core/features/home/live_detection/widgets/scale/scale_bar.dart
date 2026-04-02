import 'package:flutter/material.dart';

class ScaleBar extends StatelessWidget {
  final double value;

  const ScaleBar({super.key, required this.value});

  Color getColor() {
    if (value < 30) return Colors.red;
    if (value < 70) return Colors.yellow;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: const Duration(milliseconds: 500),
      builder: (_, val, __) {
        return LinearProgressIndicator(
          value: val / 100,
          color: getColor(),
          backgroundColor: Colors.white12,
        );
      },
    );
  }
}
