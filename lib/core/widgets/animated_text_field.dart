import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';

class AnimatedTextField extends HookWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const AnimatedTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType,
    this.maxLines,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    final isFocused = useState(false);
    final hasText = useState(false);
    final glowController = useAnimationController(
      duration: AppConstants.animationNormal,
    );
    final glowAnimation = useAnimation(
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: glowController,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    useEffect(() {
      void onFocusChange() {
        isFocused.value = focusNode.hasFocus;
        if (focusNode.hasFocus) {
          glowController.forward();
        } else {
          glowController.reverse();
        }
      }

      void onTextChange() {
        hasText.value = controller.text.isNotEmpty;
      }

      focusNode.addListener(onFocusChange);
      controller.addListener(onTextChange);
      hasText.value = controller.text.isNotEmpty;

      return () {
        focusNode.removeListener(onFocusChange);
        controller.removeListener(onTextChange);
      };
    }, [focusNode, controller]);

    return AnimatedBuilder(
      animation: glowController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            boxShadow: isFocused.value
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2 * glowAnimation),
                      blurRadius: 12 * glowAnimation,
                      spreadRadius: 0,
                      offset: Offset(0, 4 * glowAnimation),
                    ),
                  ]
                : null,
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            maxLines: maxLines,
            onChanged: onChanged,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppConstants.fontSizeBase,
            ),
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(
                color: isFocused.value
                    ? AppColors.primary
                    : AppColors.textSecondary,
                fontSize: AppConstants.fontSizeMedium,
              ),
              floatingLabelStyle: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                borderSide: BorderSide(
                  color: AppColors.surfaceLight,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                borderSide: BorderSide(
                  color: AppColors.surfaceLight,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 2.5,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppConstants.spacing16,
                vertical: maxLines != null && maxLines! > 1
                    ? AppConstants.spacing16
                    : AppConstants.spacing12,
              ),
            ),
          ),
        );
      },
    );
  }
}

