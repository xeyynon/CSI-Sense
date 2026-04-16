import 'package:flutter/material.dart';
import 'grid_item_card.dart';
import 'grid_menu_item.dart';

class GridMenu extends StatelessWidget {
  final List<GridMenuItem> items;
  final bool isHistory;
  const GridMenu({super.key, required this.items, this.isHistory = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 260, // 🔥 slightly better width
        child: GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(), // 🔥 prevent scroll issue
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, // ✅ one per row
            mainAxisSpacing: 120, // ✅ FIXED spacing
            childAspectRatio: 1.3, // 🔥 controls card height
          ),
          itemBuilder: (context, index) {
            final item = items[index];

            return GridItemCard(
              title: item.title,
              icon: item.icon,
              onTap: item.onTap,
              isHistory: isHistory,
            );
          },
        ),
      ),
    );
  }
}
