import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/features/home/home_screen.dart';

class HumanDetectionApp extends StatelessWidget {
  const HumanDetectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Human Detection System',
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
