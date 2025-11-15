import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/responsive_utils.dart';
import '../../models/project_model.dart';

class ProjectCard extends StatefulWidget {
  final ProjectModel project;

  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isHovered = false;
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: AppConstants.animationNormal,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
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
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
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

  Future<void> _launchUrl(String? url) async {
    if (url == null) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  bool get _shouldShowReadMore {
    return widget.project.description.length > 250;
  }

  String get _displayDescription {
    if (!_shouldShowReadMore || _isExpanded) {
      return widget.project.description;
    }
    return '${widget.project.description.substring(0, 200)}...';
  }

  @override
  Widget build(BuildContext context) {
    final cardPadding = ResponsiveUtils.getCardPadding(context);

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
              ..rotateX(_isHovered ? -0.03 : 0.0)
              ..rotateY(_isHovered ? 0.02 : 0.0)
              ..translate(0.0, -12.0 * _elevationAnimation.value),
            alignment: Alignment.center,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.08 * _glowAnimation.value),
                      blurRadius: 25 * _glowAnimation.value,
                      spreadRadius: 0,
                      offset: Offset(0, 12 * _elevationAnimation.value),
                    ),
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.15 * _glowAnimation.value),
                      blurRadius: 20 * _glowAnimation.value,
                      spreadRadius: -5,
                      offset: Offset(0, 8 * _elevationAnimation.value),
                    ),
                  ],
                ),
                child: GlassContainer(
                  padding: EdgeInsets.all(cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Project Title
                Text(
                  widget.project.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
                SizedBox(height: AppConstants.spacing12),
                // Description
                Flexible(
                  child: AnimatedSize(
                    duration: AppConstants.animationNormal,
                    curve: Curves.easeInOutCubic,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _displayDescription,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                height: 1.6,
                                color: AppColors.textSecondary,
                              ),
                        ),
                        if (_shouldShowReadMore) ...[
                          SizedBox(height: AppConstants.spacing8),
                          GestureDetector(
                            onTap: () {
                              setState(() => _isExpanded = !_isExpanded);
                            },
                            child: Text(
                              _isExpanded ? 'Show Less' : 'Read More',
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeMedium,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppConstants.spacing16),
                // Tech Stack Badges
                Wrap(
                  spacing: AppConstants.spacing8,
                  runSpacing: AppConstants.spacing8,
                  children: widget.project.techStack.map((tech) {
                    return _TechBadge(tech: tech);
                  }).toList(),
                ),
                // Action Buttons
                if (widget.project.codeUrl != null || widget.project.demoUrl != null)
                  Row(
                    children: [
                      if (widget.project.codeUrl != null) ...[
                        Expanded(
                          child: CustomButton(
                            text: 'View Code',
                            icon: Icons.code,
                            onPressed: () => _launchUrl(widget.project.codeUrl),
                          ),
                        ),
                        if (widget.project.demoUrl != null)
                          SizedBox(width: AppConstants.spacing12),
                      ],
                      if (widget.project.demoUrl != null)
                        Expanded(
                          child: CustomButton(
                            text: 'Visit Website',
                            icon: Icons.open_in_new,
                            isOutlined: widget.project.codeUrl != null,
                            onPressed: () => _launchUrl(widget.project.demoUrl),
                          ),
                        ),
                    ],
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

class _TechBadge extends StatefulWidget {
  final String tech;

  const _TechBadge({required this.tech});

  @override
  State<_TechBadge> createState() => _TechBadgeState();
}

class _TechBadgeState extends State<_TechBadge> {
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
        duration: AppConstants.animationFast,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(_isHovered ? 0.18 : 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.25),
            width: 1,
          ),
        ),
        transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
        child: Text(
          widget.tech,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
                fontSize: AppConstants.fontSizeSmall,
              ),
        ),
      ),
    );
  }
}
