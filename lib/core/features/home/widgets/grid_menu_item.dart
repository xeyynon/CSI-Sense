import 'package:flutter/material.dart';

class GridMenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  GridMenuItem({required this.title, required this.icon, required this.onTap});
}
