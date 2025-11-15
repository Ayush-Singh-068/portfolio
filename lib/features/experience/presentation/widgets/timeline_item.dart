import 'package:flutter/material.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/responsive_utils.dart';
import '../../models/experience_model.dart';

class TimelineItem extends StatefulWidget {
  final ExperienceModel experience;
  final bool isLast;

  const TimelineItem({
    super.key,
    required this.experience,
    required this.isLast,
  });

  @override
  State<TimelineItem> createState() => _TimelineItemState();
}

class _TimelineItemState extends State<TimelineItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TimelineIndicator(
          isLast: widget.isLast,
          isHovered: _isHovered,
        ),
        SizedBox(width: AppConstants.spacing24),
        Expanded(
          child: MouseRegion(
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
            child: Padding(
              padding: EdgeInsets.only(bottom: AppConstants.spacing24),
              child: AnimatedContainer(
                duration: AppConstants.animationFast,
                curve: Curves.easeInOutCubic,
                transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
                child: GlassContainer(
                  padding: EdgeInsets.all(ResponsiveUtils.getCardPadding(context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.experience.role,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                SizedBox(height: AppConstants.spacing4),
                                Text(
                                  widget.experience.company,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: AppColors.primary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${widget.experience.startDate} - ${widget.experience.endDate}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppConstants.spacing16),
                      ...widget.experience.achievements.map((achievement) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: AppConstants.spacing12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  top: 8,
                                  right: AppConstants.spacing12,
                                ),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  achievement,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        height: 1.6,
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineIndicator extends StatefulWidget {
  final bool isLast;
  final bool isHovered;

  const _TimelineIndicator({
    required this.isLast,
    required this.isHovered,
  });

  @override
  State<_TimelineIndicator> createState() => _TimelineIndicatorState();
}

class _TimelineIndicatorState extends State<_TimelineIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: AppConstants.animationFast,
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: widget.isHovered ? AppColors.primary : AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(
                  widget.isHovered ? 0.6 : 0.3),
                blurRadius: 8,
                spreadRadius: widget.isHovered ? 3 : 2,
              ),
            ],
          ),
          transform: Matrix4.identity()
            ..scale(widget.isHovered ? 1.3 : 1.0),
        ),
        if (!widget.isLast)
          AnimatedContainer(
            duration: AppConstants.animationFast,
            width: widget.isHovered ? 3 : 2,
            height: 200,
            color: AppColors.primary.withOpacity(
              widget.isHovered ? 0.6 : 0.3,
            ),
          ),
      ],
    );
  }
}
