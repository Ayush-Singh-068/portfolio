import 'package:flutter/material.dart';
import '../../../../core/widgets/animated_section.dart';
import '../../../../core/constants/responsive_utils.dart';
import '../../../../data/experience_data.dart';
import 'timeline_item.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.getPadding(context);
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 80),
      child: AnimatedSection(
        id: 'experience',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Experience',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 48),
            _Timeline(),
          ],
        ),
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < ExperienceData.experiences.length; i++) ...[
          TimelineItem(
            experience: ExperienceData.experiences[i],
            isLast: i == ExperienceData.experiences.length - 1,
          ),
        ],
      ],
    );
  }
}

