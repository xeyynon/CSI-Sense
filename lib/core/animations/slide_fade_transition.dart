import 'package:flutter/material.dart';

class SlideFadeRoute extends PageRouteBuilder {
  final Widget page;

  SlideFadeRoute({required this.page})
    : super(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          final fade = Tween(begin: 0.0, end: 1.0).animate(animation);

          final slide = Tween(
            begin: const Offset(0, 0.1),
            end: Offset.zero,
          ).animate(animation);

          final reverseSlide = Tween(
            begin: Offset.zero,
            end: const Offset(0, 0.1),
          ).animate(secondaryAnimation);

          return FadeTransition(
            opacity: fade,
            child: SlideTransition(
              position: animation.status == AnimationStatus.reverse
                  ? reverseSlide
                  : slide,
              child: child,
            ),
          );
        },
      );
}
