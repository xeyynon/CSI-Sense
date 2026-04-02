import 'package:flutter/material.dart';

class SwipeBackWrapper extends StatelessWidget {
  final Widget child;

  const SwipeBackWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 300) {
          Navigator.pop(context);
        }
      },
      child: child,
    );
  }
}
