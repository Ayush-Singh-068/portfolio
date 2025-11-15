import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../constants/app_constants.dart';
import 'scroll_reveal_animation.dart';
import 'animated_entrance.dart';

class AnimatedSection extends HookWidget {
  final Widget child;
  final String id;
  final double padding;
  final ScrollController? scrollController;
  final RevealDirection direction;

  const AnimatedSection({
    super.key,
    required this.child,
    required this.id,
    this.padding = 0,
    this.scrollController,
    this.direction = RevealDirection.up,
  });

  @override
  Widget build(BuildContext context) {
    // Use scroll reveal for better performance and scroll-triggered animations
    // For fade direction, use a simpler immediate animation
    if (direction == RevealDirection.fade) {
      return AnimatedEntrance(
        type: EntranceType.fadeIn,
        delay: const Duration(milliseconds: 100),
        duration: AppConstants.animationNormal,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: child,
        ),
      );
    }
    return ScrollRevealAnimation(
      direction: direction,
      duration: AppConstants.animationNormal,
      curve: Curves.easeOutCubic,
      threshold: 0.1, // More lenient threshold
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }
}

