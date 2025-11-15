import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';
import '../constants/responsive_utils.dart';

class GlassContainer extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final bool enableHover;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.enableHover = true,
  });

  @override
  State<GlassContainer> createState() => _GlassContainerState();
}

class _GlassContainerState extends State<GlassContainer>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _blurController;
  late Animation<double> _blurAnimation;
  late Animation<double> _borderAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _blurController = AnimationController(
      duration: AppConstants.animationNormal,
      vsync: this,
    );
    _blurAnimation = Tween<double>(begin: 10.0, end: 15.0).animate(
      CurvedAnimation(
        parent: _blurController,
        curve: Curves.easeOutCubic,
      ),
    );
    _borderAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _blurController,
        curve: Curves.easeOutCubic,
      ),
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _blurController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _blurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? AppConstants.radiusLarge;

    Widget container = Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      child: AnimatedBuilder(
        animation: _blurController,
        builder: (context, child) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: _blurAnimation.value,
                sigmaY: _blurAnimation.value,
              ),
              child: Container(
                padding: widget.padding,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.glassBackground,
                      AppColors.glassBackground.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(
                    color: AppColors.glassBorder.withValues(
                      alpha: 0.5 + (0.5 * _glowAnimation.value),
                    ),
                    width: _borderAnimation.value,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1 + (0.05 * _glowAnimation.value)),
                      blurRadius: 24 + (8 * _glowAnimation.value),
                      offset: Offset(0, 12 + (4 * _glowAnimation.value)),
                      spreadRadius: -4,
                    ),
                    if (_isHovered) ...[
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.05 * _glowAnimation.value),
                        blurRadius: 15 * _glowAnimation.value,
                        spreadRadius: 0,
                        offset: Offset(0, 6 * _glowAnimation.value),
                      ),
                    ],
                  ],
                ),
                child: widget.child,
              ),
            ),
          );
        },
      ),
    );

    if (widget.enableHover && ResponsiveUtils.supportsHover(context)) {
      return MouseRegion(
        onEnter: (_) {
          setState(() => _isHovered = true);
          _blurController.forward();
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _blurController.reverse();
        },
        child: container,
      );
    }

    return container;
  }
}

