import 'package:flutter/material.dart';
import '../../../../core/widgets/animated_section.dart';
import '../../../../core/widgets/animated_text_reveal.dart';
import '../../../../core/widgets/scroll_reveal_animation.dart';
import '../../../../core/constants/responsive_utils.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/projects_data.dart';
import 'project_card.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

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
            id: 'projects',
            direction: RevealDirection.fade,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedTextReveal(
                  text: 'Projects',
                  type: TextRevealType.slideIn,
                  delay: const Duration(milliseconds: 200),
                  duration: AppConstants.animationNormal,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                ),
                SizedBox(height: AppConstants.spacing48),
                _ProjectsList(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProjectsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.getCrossAxisCount(context),
        crossAxisSpacing: ResponsiveUtils.getGridSpacing(context),
        mainAxisSpacing: ResponsiveUtils.getGridSpacing(context),
        childAspectRatio: ResponsiveUtils.getCardAspectRatio(context),
      ),
      itemCount: ProjectsData.projects.length,
      itemBuilder: (context, index) {
        return StaggeredReveal(
          index: index,
          direction: RevealDirection.up,
          child: ProjectCard(project: ProjectsData.projects[index]),
        );
      },
    );
  }
}

