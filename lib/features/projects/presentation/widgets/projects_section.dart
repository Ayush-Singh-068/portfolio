import 'package:flutter/material.dart';
import '../../../../core/widgets/animated_section.dart';
import '../../../../core/constants/responsive_utils.dart';
import '../../../../data/projects_data.dart';
import 'project_card.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.getPadding(context);
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 80),
      child: AnimatedSection(
        id: 'projects',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Projects',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 48),
            _ProjectsList(),
          ],
        ),
      ),
    );
  }
}

class _ProjectsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final crossAxisCount = ResponsiveUtils.getCrossAxisCount(context);
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: ResponsiveUtils.isMobile(context) ? 0.85 : 0.75,
      ),
      itemCount: ProjectsData.projects.length,
      itemBuilder: (context, index) {
        return ProjectCard(project: ProjectsData.projects[index]);
      },
    );
  }
}

