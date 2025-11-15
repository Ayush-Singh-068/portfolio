import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/project_model.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const ProjectCard({super.key, required this.project});

  Future<void> _launchUrl(String? url) async {
    if (url == null) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            project.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: project.techStack.map((tech) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  tech,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              );
            }).toList(),
          ),
          const Spacer(),
          const SizedBox(height: 16),
          if (project.codeUrl != null || project.demoUrl != null)
            Row(
              children: [
                if (project.codeUrl != null) ...[
                  Expanded(
                    child: CustomButton(
                      text: 'View Code',
                      icon: Icons.code,
                      onPressed: () => _launchUrl(project.codeUrl),
                    ),
                  ),
                  if (project.demoUrl != null) const SizedBox(width: 12),
                ],
                if (project.demoUrl != null)
                  Expanded(
                    child: CustomButton(
                      text: 'Visit Website',
                      icon: Icons.open_in_new,
                      isOutlined: project.codeUrl != null,
                      onPressed: () => _launchUrl(project.demoUrl),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

