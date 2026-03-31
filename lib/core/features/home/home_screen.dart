import 'package:flutter/material.dart';
import '../../core/animations/fade_animation.dart';
import '../../core/theme/text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Human Detection System")),
      body: const FadeAnimation(
        child: Center(
          child: Text(
            "Home Screen (Grid coming next)",
            style: AppTextStyles.title,
          ),
        ),
      ),
    );
  }
}
