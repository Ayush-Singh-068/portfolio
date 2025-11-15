import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../constants/app_constants.dart';

enum RevealDirection {
  up,
  down,
  left,
  right,
  scale,
  fade,
}

class ScrollRevealAnimation extends HookWidget {
  final Widget child;
  final RevealDirection direction;
  final Duration delay;
  final Duration duration;
  final double offset;
  final Curve curve;
  final double threshold; // Viewport threshold (0.0 to 1.0)

  const ScrollRevealAnimation({
    super.key,
    required this.child,
    this.direction = RevealDirection.up,
    this.delay = Duration.zero,
    this.duration = AppConstants.animationNormal,
    this.offset = AppConstants.revealOffset,
    this.curve = Curves.easeOutCubic,
    this.threshold = 0.2, // Trigger when 20% visible
  });

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: duration,
    );
    final hasRevealed = useState(false);
    final key = useMemoized(() => GlobalKey());

    // Check if widget is in viewport
    void checkVisibility() {
      if (hasRevealed.value) return;

      final renderObject = key.currentContext?.findRenderObject();
      if (renderObject == null) return;

      final RenderBox? box = renderObject as RenderBox?;
      if (box == null) return;

      final position = box.localToGlobal(Offset.zero);
      final size = box.size;
      final screenHeight = MediaQuery.of(context).size.height;

      // Check if widget is in viewport - very lenient check for initial visibility
      // Consider visible if it's anywhere near the viewport
      final isVisible = position.dy < screenHeight * 1.5 &&
          position.dy + size.height > -screenHeight * 0.5;

      if (isVisible && !hasRevealed.value) {
        hasRevealed.value = true;
        Future.delayed(delay, () {
          if (animationController.status != AnimationStatus.completed &&
              animationController.status != AnimationStatus.forward) {
            animationController.forward();
          }
        });
      }
    }

    useEffect(() {
      // Initial check after first frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        checkVisibility();
        // Also check after a short delay to catch any layout changes
        Future.delayed(const Duration(milliseconds: 300), () {
          checkVisibility();
        });
      });

      // Periodic checks to catch scroll events
      final timer = Stream.periodic(const Duration(milliseconds: 200))
          .listen((_) => checkVisibility());

      return () => timer.cancel();
    }, []);

    // Create animations based on direction
    final opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: curve,
      ),
    );

    final translateX = direction == RevealDirection.left
        ? -offset
        : direction == RevealDirection.right
            ? offset
            : 0.0;

    final translateY = direction == RevealDirection.up
        ? offset
        : direction == RevealDirection.down
            ? -offset
            : 0.0;

    final translateAnimation = Tween<double>(
      begin: direction == RevealDirection.scale ? 0.0 : (translateX != 0 ? translateX : translateY),
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: curve,
      ),
    );

    final scaleAnimation = direction == RevealDirection.scale
        ? Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(
              parent: animationController,
              curve: curve,
            ),
          )
        : null;

    return RepaintBoundary(
      key: key,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Opacity(
            opacity: opacityAnimation.value,
            child: Transform.translate(
              offset: Offset(
                direction == RevealDirection.left || direction == RevealDirection.right
                    ? translateAnimation.value
                    : 0.0,
                direction == RevealDirection.up || direction == RevealDirection.down
                    ? translateAnimation.value
                    : 0.0,
              ),
              child: scaleAnimation != null
                  ? Transform.scale(
                      scale: scaleAnimation.value,
                      child: child,
                    )
                  : child,
            ),
          );
        },
        child: this.child,
      ),
    );
  }
}

// Helper widget for staggered grid animations
class StaggeredReveal extends StatelessWidget {
  final Widget child;
  final int index;
  final RevealDirection direction;
  final Duration baseDelay;

  const StaggeredReveal({
    super.key,
    required this.child,
    required this.index,
    this.direction = RevealDirection.up,
    this.baseDelay = AppConstants.staggerDelay,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollRevealAnimation(
      direction: direction,
      delay: baseDelay * index,
      child: child,
    );
  }
}

