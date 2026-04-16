import 'package:csi_sense/core/navigation/main_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:csi_sense/core/config/app_settings.dart';


class HumanDetectionApp extends StatelessWidget {
  const HumanDetectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      /// 🌞 LIGHT THEME (soft blue, not white)
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFEAF3FF),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFDCEBFF),
          foregroundColor: Colors.black,
        ),

        colorScheme: const ColorScheme.light(
          primary: Color(0xFF007AFF),
          secondary: Color(0xFF4DA3FF),
        ),
      ),

      /// 🌌 DARK THEME (your original radar style)
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0F1C),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121A2A),
          foregroundColor: Colors.white,
        ),

        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FF9C), // radar green
          secondary: Color(0xFF00CC88),
        ),
      ),

      /// 🔥 THEME SWITCH
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      home: const MainNavigationScreen(),
    );
  }
}
