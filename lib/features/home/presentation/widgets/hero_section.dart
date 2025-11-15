import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../../core/widgets/animated_section.dart';
import '../../../../core/widgets/animated_text_reveal.dart';
import '../../../../core/widgets/scroll_reveal_animation.dart';
import '../../../../core/constants/responsive_utils.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

class HeroSection extends HookWidget {
  final ScrollController? scrollController;
  
  const HeroSection({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    final scrollOffset = useState(0.0);

    useEffect(() {
      if (scrollController != null) {
        void onScroll() {
          scrollOffset.value = scrollController!.offset;
        }
        scrollController!.addListener(onScroll);
        return () => scrollController!.removeListener(onScroll);
      }
      return null;
    }, [scrollController]);

    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = ResponsiveUtils.getPadding(context);
        final profileSize = ResponsiveUtils.isDesktop(context)
            ? AppConstants.profileImageSizeDesktop
            : ResponsiveUtils.isTablet(context)
                ? AppConstants.profileImageSizeTablet
                : AppConstants.profileImageSizeMobile;

        // Parallax effect based on scroll
        final parallaxOffset = scrollOffset.value * AppConstants.profileImageParallaxFactor;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            padding,
            120,
            padding,
            ResponsiveUtils.getSectionPadding(context),
          ),
          child: Stack(
            children: [
              // Animated background shapes
              _AnimatedBackgroundShapes(parallaxOffset: parallaxOffset),
              // Main content
              AnimatedSection(
                id: 'hero',
                direction: RevealDirection.fade,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ProfileImage(
                      size: profileSize,
                      parallaxOffset: parallaxOffset,
                    ),
                    SizedBox(height: AppConstants.spacing40),
                    AnimatedTextReveal(
                      text: 'Ayush Singh',
                      type: TextRevealType.fadeIn,
                      delay: const Duration(milliseconds: 300),
                      duration: AppConstants.animationSlow,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ) ??
                          TextStyle(
                            fontSize: ResponsiveUtils.isDesktop(context)
                                ? 64
                                : ResponsiveUtils.isTablet(context)
                                    ? 52
                                    : 40,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                            letterSpacing: -1,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppConstants.spacing20),
                    AnimatedTextReveal(
                      text: AppConstants.tagline,
                      type: TextRevealType.slideIn,
                      delay: const Duration(milliseconds: 600),
                      duration: AppConstants.animationSlow,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ) ??
                          TextStyle(
                            fontSize: ResponsiveUtils.isDesktop(context) ? 26 : 22,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppConstants.spacing32),
                    AnimatedTextReveal(
                      text: 'With over 4+ years of experience as a Flutter Developer, I have a proven track record of delivering exceptional mobile applications. '
                          'My expertise lies in cross-platform development, object-oriented programming, and debugging. '
                          'My passion for creating high-quality products has honed my problem-solving abilities and attention to detail. '
                          'I am a skilled communicator and thrive in both independent and team settings.',
                      type: TextRevealType.fadeIn,
                      delay: const Duration(milliseconds: 900),
                      duration: AppConstants.animationVerySlow,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.8,
                            color: AppColors.textSecondary,
                          ) ??
                          TextStyle(
                            fontSize: ResponsiveUtils.isDesktop(context) ? 18 : 16,
                            height: 1.8,
                            color: AppColors.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AnimatedBackgroundShapes extends HookWidget {
  final double parallaxOffset;

  const _AnimatedBackgroundShapes({required this.parallaxOffset});

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(seconds: 20),
    )..repeat();

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: _BackgroundShapesPainter(
              animationValue: animationController.value,
              parallaxOffset: parallaxOffset,
            ),
          ),
        );
      },
    );
  }
}

class _BackgroundShapesPainter extends CustomPainter {
  final double animationValue;
  final double parallaxOffset;

  _BackgroundShapesPainter({
    required this.animationValue,
    required this.parallaxOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.primary.withValues(alpha: 0.05);

    // Animated gradient circles
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Circle 1 - top left
    canvas.drawCircle(
      Offset(
        centerX * 0.3 + parallaxOffset * 0.1,
        centerY * 0.3 + parallaxOffset * 0.15,
      ),
      100 + (animationValue * 30),
      paint..color = AppColors.primary.withValues(alpha: 0.03),
    );

    // Circle 2 - bottom right
    canvas.drawCircle(
      Offset(
        centerX * 1.4 - parallaxOffset * 0.1,
        centerY * 1.3 - parallaxOffset * 0.15,
      ),
      120 + (animationValue * 40),
      paint..color = AppColors.secondary.withValues(alpha: 0.03),
    );

    // Circle 3 - top right
    canvas.drawCircle(
      Offset(
        centerX * 1.2 + parallaxOffset * 0.05,
        centerY * 0.2 + parallaxOffset * 0.1,
      ),
      80 + (animationValue * 20),
      paint..color = AppColors.accent.withValues(alpha: 0.02),
    );
  }

  @override
  bool shouldRepaint(covariant _BackgroundShapesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.parallaxOffset != parallaxOffset;
  }
}

class _ProfileImage extends StatefulWidget {
  final double size;
  final double parallaxOffset;

  const _ProfileImage({
    required this.size,
    required this.parallaxOffset,
  });

  @override
  State<_ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<_ProfileImage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _floatController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: AppConstants.profilePulseDuration,
      vsync: this,
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      duration: AppConstants.profileRotateDuration,
      vsync: this,
    )..repeat();

    _floatController = AnimationController(
      duration: AppConstants.profileFloatDuration,
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14159).animate(
      CurvedAnimation(
        parent: _rotateController,
        curve: Curves.linear,
      ),
    );

    _floatAnimation = Tween<double>(begin: -AppConstants.profileImageFloatOffset, end: AppConstants.profileImageFloatOffset).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _pulseAnimation,
        _rotateAnimation,
        _floatAnimation,
      ]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value + widget.parallaxOffset * AppConstants.profileImageParallaxFactor * 0.6),
          child: Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.5),
                    blurRadius: 80,
                    spreadRadius: 0,
                    offset: const Offset(0, 30),
                  ),
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.3),
                    blurRadius: 60,
                    spreadRadius: -10,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Rotating border glow
                  Transform.rotate(
                    angle: _rotateAnimation.value,
                    child: Container(
                      width: widget.size + 20,
                      height: widget.size + 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.0),
                            AppColors.primary.withValues(alpha: 0.3),
                            AppColors.secondary.withValues(alpha: 0.3),
                            AppColors.primary.withValues(alpha: 0.0),
                          ],
                          stops: const [0.0, 0.3, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Profile image
                  Container(
                    width: widget.size - 8,
                    height: widget.size - 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.background,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/profile.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.surface,
                            child: Icon(
                              Icons.person,
                              size: widget.size * 0.4,
                              color: AppColors.textSecondary,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
