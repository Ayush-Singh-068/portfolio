import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';

enum TextRevealType {
  wordByWord,
  characterByCharacter,
  fadeIn,
  slideIn,
}

class AnimatedTextReveal extends HookWidget {
  final String text;
  final TextStyle? style;
  final TextRevealType type;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final TextAlign textAlign;

  const AnimatedTextReveal({
    super.key,
    required this.text,
    this.style,
    this.type = TextRevealType.fadeIn,
    this.delay = Duration.zero,
    this.duration = AppConstants.animationNormal,
    this.curve = Curves.easeOutCubic,
    this.textAlign = TextAlign.left,
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

    switch (type) {
      case TextRevealType.fadeIn:
        return _FadeInText(
          text: text,
          style: style,
          animationController: animationController,
          curve: curve,
          textAlign: textAlign,
        );
      case TextRevealType.slideIn:
        return _SlideInText(
          text: text,
          style: style,
          animationController: animationController,
          curve: curve,
          textAlign: textAlign,
        );
      case TextRevealType.wordByWord:
        return _WordByWordText(
          text: text,
          style: style,
          animationController: animationController,
          curve: curve,
          textAlign: textAlign,
        );
      case TextRevealType.characterByCharacter:
        return _CharacterByCharacterText(
          text: text,
          style: style,
          animationController: animationController,
          curve: curve,
          textAlign: textAlign,
        );
    }
  }
}

class _FadeInText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final AnimationController animationController;
  final Curve curve;
  final TextAlign textAlign;

  const _FadeInText({
    required this.text,
    this.style,
    required this.animationController,
    required this.curve,
    required this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: curve),
    );

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Opacity(
          opacity: opacityAnimation.value,
          child: Text(
            text,
            style: style,
            textAlign: textAlign,
          ),
        );
      },
    );
  }
}

class _SlideInText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final AnimationController animationController;
  final Curve curve;
  final TextAlign textAlign;

  const _SlideInText({
    required this.text,
    this.style,
    required this.animationController,
    required this.curve,
    required this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: curve),
    );

    final translateAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(parent: animationController, curve: curve),
    );

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Opacity(
          opacity: opacityAnimation.value,
          child: Transform.translate(
            offset: Offset(0, translateAnimation.value),
            child: Text(
              text,
              style: style,
              textAlign: textAlign,
            ),
          ),
        );
      },
    );
  }
}

class _WordByWordText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final AnimationController animationController;
  final Curve curve;
  final TextAlign textAlign;

  const _WordByWordText({
    required this.text,
    this.style,
    required this.animationController,
    required this.curve,
    required this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final words = text.split(' ');
    final wordCount = words.length;

    return Wrap(
      alignment: textAlign == TextAlign.center
          ? WrapAlignment.center
          : textAlign == TextAlign.right
              ? WrapAlignment.end
              : WrapAlignment.start,
      children: words.asMap().entries.map((entry) {
        final index = entry.key;
        final word = entry.value;

        final wordDelay = index / wordCount;
        final wordAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(
              wordDelay.clamp(0.0, 1.0),
              ((index + 1) / wordCount).clamp(0.0, 1.0),
              curve: curve,
            ),
          ),
        );

        return AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Opacity(
              opacity: wordAnimation.value,
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Text(
                  '$word ',
                  style: style,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class _CharacterByCharacterText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final AnimationController animationController;
  final Curve curve;
  final TextAlign textAlign;

  const _CharacterByCharacterText({
    required this.text,
    this.style,
    required this.animationController,
    required this.curve,
    required this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final characters = text.split('');
    final charCount = characters.length;

    return Wrap(
      alignment: textAlign == TextAlign.center
          ? WrapAlignment.center
          : textAlign == TextAlign.right
              ? WrapAlignment.end
              : WrapAlignment.start,
      children: characters.asMap().entries.map((entry) {
        final index = entry.key;
        final char = entry.value;

        final charDelay = index / charCount;
        final charAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(
              charDelay.clamp(0.0, 1.0),
              ((index + 1) / charCount).clamp(0.0, 1.0),
              curve: curve,
            ),
          ),
        );

        return AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Opacity(
              opacity: charAnimation.value,
              child: Text(
                char,
                style: style,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

// Animated gradient text widget
class AnimatedGradientText extends HookWidget {
  final String text;
  final TextStyle? style;
  final List<Color> colors;
  final Duration duration;
  final TextAlign textAlign;

  const AnimatedGradientText({
    super.key,
    required this.text,
    this.style,
    this.colors = const [AppColors.primary, AppColors.secondary],
    this.duration = const Duration(seconds: 3),
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(duration: duration)
      ..repeat();

    final colorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                colorAnimation.value,
                (colorAnimation.value + 0.5) % 1.0,
              ],
            ).createShader(bounds);
          },
          child: Text(
            text,
            style: (style ?? const TextStyle()).copyWith(
              color: Colors.white,
            ),
            textAlign: textAlign,
          ),
        );
      },
    );
  }
}

