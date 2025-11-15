import 'package:flutter/material.dart';
import '../../../../core/widgets/animated_section.dart';
import '../../../../core/constants/responsive_utils.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.getPadding(context);
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        padding,
        120,
        padding,
        80,
      ),
      child: AnimatedSection(
        id: 'hero',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ProfileImage(),
            const SizedBox(height: 32),
            Text(
              'Ayush Singh',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              AppConstants.tagline,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.isMobile(context) ? 0 : 100,
              ),
              child: Text(
                'With over 4+ years of experience as a Flutter Developer, I have a proven track record of delivering exceptional mobile applications. '
                'My expertise lies in cross-platform development, object-oriented programming, and debugging. '
                'My passion for creating high-quality products has honed my problem-solving abilities and attention to detail. '
                'I am a skilled communicator and thrive in both independent and team settings.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/profile.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.surface,
              child: const Icon(
                Icons.person,
                size: 100,
                color: AppColors.textSecondary,
              ),
            );
          },
        ),
      ),
    );
  }
}

