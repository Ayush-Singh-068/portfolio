import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../constants/app_constants.dart';

enum EntranceType {
  fadeIn,
  fadeInUp,
  fadeInDown,
  fadeInLeft,
  fadeInRight,
  scaleIn,
  slideInBottom,
}

class AnimatedEntrance extends HookWidget {
  final Widget child;
  final EntranceType type;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final double offset;

  const AnimatedEntrance({
    super.key,
    required this.child,
    this.type = EntranceType.fadeInUp,
    this.delay = Duration.zero,
    this.duration = AppConstants.animationNormal,
    this.curve = Curves.easeOutCubic,
    this.offset = AppConstants.revealOffset,
  });

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: duration,
    );
    final hasStarted = useState(false);

    useEffect(() {
      Future.delayed(delay, () {
        hasStarted.value = true;
        animationController.forward();
      });
      return null;
    }, []);

    // Determine animation values based on type
    double getTranslateX() {
      switch (type) {
        case EntranceType.fadeInLeft:
          return -offset;
        case EntranceType.fadeInRight:
          return offset;
        default:
          return 0.0;
      }
    }

    double getTranslateY() {
      switch (type) {
        case EntranceType.fadeIn:
          return 0.0;
        case EntranceType.fadeInUp:
        case EntranceType.slideInBottom:
          return offset;
        case EntranceType.fadeInDown:
          return -offset;
        default:
          return 0.0;
      }
    }

    double getScale() {
      return type == EntranceType.scaleIn ? 0.8 : 1.0;
    }

    final opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: curve),
    );

    final translateXAnimation = Tween<double>(
      begin: getTranslateX(),
      end: 0.0,
    ).animate(
      CurvedAnimation(parent: animationController, curve: curve),
    );

    final translateYAnimation = Tween<double>(
      begin: getTranslateY(),
      end: 0.0,
    ).animate(
      CurvedAnimation(parent: animationController, curve: curve),
    );

    final scaleAnimation = Tween<double>(
      begin: getScale(),
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: animationController, curve: curve),
    );

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Opacity(
          opacity: opacityAnimation.value,
          child: Transform.translate(
            offset: Offset(translateXAnimation.value, translateYAnimation.value),
            child: Transform.scale(
              scale: scaleAnimation.value,
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

