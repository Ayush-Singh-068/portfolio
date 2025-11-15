import 'package:flutter/material.dart';
import '../../../../core/widgets/animated_section.dart';
import '../../../../core/widgets/animated_text_reveal.dart';
import '../../../../core/widgets/scroll_reveal_animation.dart';
import '../../../../core/constants/responsive_utils.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/experience_data.dart';
import 'timeline_item.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

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
            id: 'experience',
            direction: RevealDirection.fade,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedTextReveal(
                  text: 'Experience',
                  type: TextRevealType.slideIn,
                  delay: const Duration(milliseconds: 200),
                  duration: AppConstants.animationNormal,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                ),
                SizedBox(height: AppConstants.spacing48),
                _Timeline(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Timeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < ExperienceData.experiences.length; i++) ...[
          StaggeredReveal(
            index: i,
            direction: RevealDirection.left,
            child: TimelineItem(
              experience: ExperienceData.experiences[i],
              isLast: i == ExperienceData.experiences.length - 1,
            ),
          ),
        ],
      ],
    );
  }
}

