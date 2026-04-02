import 'package:flutter/material.dart';
import 'grid_item_card.dart';
import 'grid_menu_item.dart'; // 

class GridMenu extends StatelessWidget {
  final List<GridMenuItem> items;

  const GridMenu({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return GridItemCard(
          title: item.title,
          icon: item.icon,
          onTap: item.onTap,
        );
      },
    );
  }
}
