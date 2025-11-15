import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';

class AnimatedBackground extends HookWidget {
  const AnimatedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final gradientController = useAnimationController(
      duration: AppConstants.backgroundGradientDuration,
    )..repeat();

    final particleController = useAnimationController(
      duration: AppConstants.backgroundParticleDuration,
    )..repeat();

    return AnimatedBuilder(
      animation: Listenable.merge([gradientController, particleController]),
      builder: (context, child) {
        return Positioned.fill(
          child: RepaintBoundary(
            child: Stack(
              children: [
                // Animated gradient background
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.background,
                        AppColors.background,
                        AppColors.surface.withValues(alpha: 0.2),
                      ],
                      stops: [
                        0.0,
                        0.5 + (0.1 * gradientController.value),
                        1.0,
                      ],
                    ),
                  ),
                ),
                // Animated particles/shapes
                RepaintBoundary(
                  child: CustomPaint(
                    painter: _ParticlePainter(
                      animationValue: particleController.value,
                      gradientValue: gradientController.value,
                    ),
                    size: MediaQuery.of(context).size,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double animationValue;
  final double gradientValue;

  _ParticlePainter({
    required this.animationValue,
    required this.gradientValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.primary.withValues(alpha: 0.05);

    // Animated gradient orbs
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Orb 1 - top left
    final orb1X = centerX * 0.2 + (animationValue * 50);
    final orb1Y = centerY * 0.2 + (animationValue * 30);
    final orb1Radius = 150 + (gradientValue * 50);
    paint.shader = RadialGradient(
      colors: [
        AppColors.primary.withValues(alpha: 0.1),
        AppColors.primary.withValues(alpha: 0.0),
      ],
    ).createShader(
      Rect.fromCircle(
        center: Offset(orb1X, orb1Y),
        radius: orb1Radius,
      ),
    );
    canvas.drawCircle(Offset(orb1X, orb1Y), orb1Radius, paint..color = AppColors.primary.withValues(alpha: 0.03));

    // Orb 2 - bottom right
    final orb2X = centerX * 1.3 - (animationValue * 40);
    final orb2Y = centerY * 1.4 - (animationValue * 50);
    final orb2Radius = 180 + (gradientValue * 60);
    paint.shader = RadialGradient(
      colors: [
        AppColors.secondary.withValues(alpha: 0.08),
        AppColors.secondary.withValues(alpha: 0.0),
      ],
    ).createShader(
      Rect.fromCircle(
        center: Offset(orb2X, orb2Y),
        radius: orb2Radius,
      ),
    );
    canvas.drawCircle(Offset(orb2X, orb2Y), orb2Radius, paint..color = AppColors.secondary.withValues(alpha: 0.03));

    // Orb 3 - top right
    final orb3X = centerX * 1.1 + (animationValue * 30);
    final orb3Y = centerY * 0.15 + (animationValue * 20);
    final orb3Radius = 120 + (gradientValue * 40);
    paint.shader = RadialGradient(
      colors: [
        AppColors.accent.withValues(alpha: 0.06),
        AppColors.accent.withValues(alpha: 0.0),
      ],
    ).createShader(
      Rect.fromCircle(
        center: Offset(orb3X, orb3Y),
        radius: orb3Radius,
      ),
    );
    canvas.drawCircle(Offset(orb3X, orb3Y), orb3Radius, paint..color = AppColors.accent.withValues(alpha: 0.02));
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.gradientValue != gradientValue;
  }
}

