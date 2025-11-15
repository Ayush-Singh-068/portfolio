import 'package:flutter/material.dart';
import '../../../../core/widgets/animated_section.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/constants/responsive_utils.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/skills_data.dart';
import '../../../../models/skill_model.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getPadding(context),
            vertical: ResponsiveUtils.getSectionPadding(context),
          ),
          child: AnimatedSection(
            id: 'skills',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Skills',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(height: AppConstants.spacing48),
                _SkillsGrid(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SkillsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.getCrossAxisCount(context),
        crossAxisSpacing: ResponsiveUtils.getGridSpacing(context),
        mainAxisSpacing: ResponsiveUtils.getGridSpacing(context),
        childAspectRatio: ResponsiveUtils.isDesktop(context)
            ? 1.1
            : ResponsiveUtils.isTablet(context)
                ? 1.0
                : 1.3,  // More compact on mobile
      ),
      itemCount: SkillsData.skills.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween<double>(begin: 0, end: 1),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: _SkillCard(skill: SkillsData.skills[index]),
              ),
            );
          },
        );
      },
    );
  }
}

class _SkillCard extends StatefulWidget {
  final SkillModel skill;

  const _SkillCard({required this.skill});

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (ResponsiveUtils.supportsHover(context)) {
          setState(() => _isHovered = true);
        }
      },
      onExit: (_) {
        if (ResponsiveUtils.supportsHover(context)) {
          setState(() => _isHovered = false);
        }
      },
      child: AnimatedContainer(
        duration: AppConstants.animationNormal,
        curve: Curves.easeInOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
        child: GlassContainer(
          padding: EdgeInsets.all(ResponsiveUtils.getCardPadding(context)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                duration: AppConstants.animationNormal,
                tween: Tween(begin: 1.0, end: _isHovered ? 1.2 : 1.0),
                curve: Curves.easeInOutCubic,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Icon(
                      widget.skill.icon,
                      size: ResponsiveUtils.isDesktop(context) ? 48 : 40,
                      color: AppColors.primary,
                    ),
                  );
                },
              ),
              SizedBox(height: AppConstants.spacing16),
              Text(
                widget.skill.name,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppConstants.spacing8),
              Text(
                widget.skill.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

