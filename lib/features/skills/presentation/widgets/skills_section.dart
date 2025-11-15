import 'package:flutter/material.dart';
import '../../../../core/widgets/animated_section.dart';
import '../../../../core/widgets/animated_text_reveal.dart';
import '../../../../core/widgets/scroll_reveal_animation.dart';
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
            direction: RevealDirection.fade,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedTextReveal(
                  text: 'Skills',
                  type: TextRevealType.slideIn,
                  delay: const Duration(milliseconds: 200),
                  duration: AppConstants.animationNormal,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
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
        return StaggeredReveal(
          index: index,
          direction: RevealDirection.scale,
          child: _SkillCard(skill: SkillsData.skills[index]),
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

class _SkillCardState extends State<_SkillCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: AppConstants.animationNormal,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _hoverController,
        curve: Curves.easeOutCubic,
      ),
    );
    _elevationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
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
    return MouseRegion(
      onEnter: (_) {
        if (ResponsiveUtils.supportsHover(context)) {
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
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateX(_isHovered ? -0.05 : 0.0)
              ..rotateY(_isHovered ? 0.02 : 0.0)
              ..translate(0.0, -8.0 * _elevationAnimation.value),
            alignment: Alignment.center,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.06 * _elevationAnimation.value),
                      blurRadius: 18 * _elevationAnimation.value,
                      spreadRadius: 0,
                      offset: Offset(0, 8 * _elevationAnimation.value),
                    ),
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1 * _elevationAnimation.value),
                      blurRadius: 15 * _elevationAnimation.value,
                      spreadRadius: -3,
                      offset: Offset(0, 6 * _elevationAnimation.value),
                    ),
                  ],
                ),
                child: GlassContainer(
                  padding: EdgeInsets.all(ResponsiveUtils.getCardPadding(context)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TweenAnimationBuilder<double>(
                        duration: AppConstants.animationNormal,
                        tween: Tween(begin: 1.0, end: _isHovered ? 1.25 : 1.0),
                        curve: Curves.easeOutBack,
                        builder: (context, scale, child) {
                          return Transform.scale(
                            scale: scale,
                            child: Icon(
                              widget.skill.icon,
                              size: ResponsiveUtils.isDesktop(context) ? 52 : 44,
                              color: AppColors.primary,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: AppConstants.spacing16),
                      Text(
                        widget.skill.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
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
            ),
          );
        },
      ),
    );
  }
}

