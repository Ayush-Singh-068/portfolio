import 'package:flutter/material.dart';
import '../../../../core/widgets/animated_section.dart';
import '../../../../core/constants/responsive_utils.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = ResponsiveUtils.getPadding(context);
        final profileSize = ResponsiveUtils.isDesktop(context)
            ? 200.0
            : ResponsiveUtils.isTablet(context)
                ? 180.0
                : 160.0;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            padding,
            120,
            padding,
            ResponsiveUtils.getSectionPadding(context),
          ),
          child: AnimatedSection(
            id: 'hero',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            _ProfileImage(size: profileSize),
            SizedBox(height: AppConstants.spacing32),
            _GradientText(
              'Ayush Singh',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ) ??
                  TextStyle(
                    fontSize: ResponsiveUtils.isDesktop(context)
                        ? 48
                        : ResponsiveUtils.isTablet(context)
                            ? 40
                            : 32,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
            ),
            SizedBox(height: AppConstants.spacing16),
            Text(
              AppConstants.tagline,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ) ??
                  TextStyle(
                    fontSize: ResponsiveUtils.isDesktop(context) ? 24 : 20,
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppConstants.spacing24),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.isMobile(context)
                    ? 0
                    : ResponsiveUtils.isTablet(context)
                        ? 100
                        : 200,
              ),
              child: Text(
                'With over 4+ years of experience as a Flutter Developer, I have a proven track record of delivering exceptional mobile applications. '
                'My expertise lies in cross-platform development, object-oriented programming, and debugging. '
                'My passion for creating high-quality products has honed my problem-solving abilities and attention to detail. '
                'I am a skilled communicator and thrive in both independent and team settings.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.7,
                      color: AppColors.textSecondary,
                    ) ??
                    TextStyle(
                      fontSize: ResponsiveUtils.isDesktop(context) ? 18 : 16,
                      height: 1.7,
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
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

class _ProfileImage extends StatefulWidget {
  final double size;

  const _ProfileImage({required this.size});

  @override
  State<_ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<_ProfileImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulseAnimation,
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
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 60,
              spreadRadius: 0,
              offset: const Offset(0, 20),
            ),
          ],
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
                  size: widget.size * 0.5,
                  color: AppColors.textSecondary,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const _GradientText(this.text, {required this.style});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [AppColors.primary, AppColors.secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        text,
        style: style.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
