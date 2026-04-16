import 'package:flutter/material.dart';
import '../../../theme/colors.dart';

class GridItemCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const GridItemCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap, required bool isHistory,
  });

  @override
  State<GridItemCard> createState() => _GridItemCardState();
}

class _GridItemCardState extends State<GridItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.94,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _onTapDown(_) => _controller.forward();

  void _onTapUp(_) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Hero(
        tag: widget.title, // 🔥 must match destination
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),

                /// 🔥 FLOAT EFFECT
                transform: Matrix4.translationValues(
                  0,
                  _controller.isAnimating ? 2 : -6,
                  0,
                ),

                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),

                  /// 🔥 DYNAMIC GLOW
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.glowBlue.withOpacity(
                        0.2 + (_controller.value * 0.4),
                      ),
                      blurRadius: 20 + (_controller.value * 20),
                      spreadRadius: 1,
                    ),
                  ],
                ),

                padding: const EdgeInsets.all(16),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(widget.icon, size: 40, color: AppColors.primary),
                    const SizedBox(height: 12),
                    Text(
                      widget.title,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
