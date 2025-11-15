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
                'Passionate Flutter developer with expertise in building cross-platform mobile applications. '
                'I specialize in creating beautiful, performant apps using Flutter, Dart, and native iOS development. '
                'Always learning and exploring new technologies to deliver exceptional user experiences.',
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

