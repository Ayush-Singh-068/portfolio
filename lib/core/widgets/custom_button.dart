import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';
import '../constants/responsive_utils.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.isOutlined = false,
    this.isLoading = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late AnimationController _hoverController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: AppConstants.animationNormal,
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _hoverController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final height = isDesktop ? 50.0 : 46.0;

    return MouseRegion(
      onEnter: (_) {
        if (ResponsiveUtils.supportsHover(context) && widget.onPressed != null) {
          setState(() => _isHovered = true);
          _hoverController.forward();
        }
      },
      onExit: (_) {
        if (ResponsiveUtils.supportsHover(context)) {
          setState(() => _isHovered = false);
          _hoverController.reverse();
        }
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed?.call();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            return Transform.scale(
              scale: _isPressed ? 0.96 : 1.0,
              child: Container(
                height: height,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.spacing24),
                decoration: BoxDecoration(
                  gradient: widget.isOutlined
                      ? null
                      : LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  color: widget.isOutlined ? Colors.transparent : null,
                  borderRadius: BorderRadius.circular(height / 2), // Pill shape
                  border: widget.isOutlined
                      ? Border.all(
                          color: AppColors.primary,
                          width: 2,
                        )
                      : null,
                  boxShadow: [
                    if (!widget.isOutlined) ...[
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4 + (0.2 * _glowAnimation.value)),
                        blurRadius: 15 + (10 * _glowAnimation.value),
                        spreadRadius: 0,
                        offset: Offset(0, 6 + (4 * _glowAnimation.value)),
                      ),
                      BoxShadow(
                        color: AppColors.secondary.withOpacity(0.2 * _glowAnimation.value),
                        blurRadius: 10 * _glowAnimation.value,
                        spreadRadius: -2,
                        offset: Offset(0, 4 * _glowAnimation.value),
                      ),
                    ] else if (_isHovered) ...[
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3 * _glowAnimation.value),
                        blurRadius: 12 * _glowAnimation.value,
                        spreadRadius: 0,
                        offset: Offset(0, 4 * _glowAnimation.value),
                      ),
                    ],
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onPressed,
                    borderRadius: BorderRadius.circular(height / 2),
                    splashColor: widget.isOutlined
                        ? AppColors.primary.withOpacity(0.1)
                        : Colors.white.withOpacity(0.2),
                    highlightColor: widget.isOutlined
                        ? AppColors.primary.withOpacity(0.05)
                        : Colors.white.withOpacity(0.1),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.spacing24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.isLoading)
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation(
                                  widget.isOutlined ? AppColors.primary : Colors.white,
                                ),
                              ),
                            )
                          else if (widget.icon != null) ...[
                            AnimatedRotation(
                              turns: _isHovered ? 0.1 : 0.0,
                              duration: AppConstants.animationNormal,
                              curve: Curves.easeOutCubic,
                              child: Icon(
                                widget.icon,
                                size: 20,
                                color: widget.isOutlined ? AppColors.primary : Colors.white,
                              ),
                            ),
                            SizedBox(width: AppConstants.spacing12),
                          ],
                          Text(
                            widget.text,
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeMedium,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: widget.isOutlined ? AppColors.primary : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
