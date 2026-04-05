import 'package:csi_sense/core/features/history/history_screen.dart';
import 'package:csi_sense/core/features/settings/settings_screen.dart';
import 'package:flutter/material.dart';

import '../../animations/fade_animation.dart';
import 'live_detection/screen/live_home_screen.dart'; // ✅ IMPORTANT
import '../home/widgets/grid_menu.dart';
import 'widgets/grid_menu_item.dart';
import 'package:csi_sense/core/features/system_status/system_status_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      /// 🔴 LIVE
      GridMenuItem(
        title: "Live Detection",
        icon: Icons.radar,
        onTap: () {
          Navigator.push(
            context,
            _createRoute(const LiveHomeScreen()), // ✅ FIXED
          );
        },
      ),

      /// 📜 HISTORY
      GridMenuItem(
        title: "History",
        icon: Icons.history,
        onTap: () {
          Navigator.push(context, _createRoute(const HistoryScreen()));
        },
      ),

      /// ⚙️ SYSTEM STATUS
      GridMenuItem(
        title: "System Status",
        icon: Icons.memory,
        onTap: () {
          Navigator.push(context, _createRoute(const SystemStatusScreen()));
        },
      ),

      /// ⚙️ SETTINGS
      GridMenuItem(
        title: "Settings",
        icon: Icons.settings,
        onTap: () {
          Navigator.push(context, _createRoute(const SettingsScreen()));
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Human Detection System"),
        centerTitle: true,
      ),
      body: FadeAnimation(child: GridMenu(items: items)),
    );
  }
}
