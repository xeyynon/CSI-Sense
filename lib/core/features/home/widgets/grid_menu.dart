import 'package:flutter/material.dart';
import 'grid_item_card.dart';
import 'grid_menu_item.dart'; //

class GridMenu extends StatelessWidget {
  final List<GridMenuItem> items;

  const GridMenu({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 250,
        child: GridView.builder(
          padding: const EdgeInsets.all(18),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 212,
            crossAxisSpacing: 1,
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
        ),
      ),
    );
  }
}
