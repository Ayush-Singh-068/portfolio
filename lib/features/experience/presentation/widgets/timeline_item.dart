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

class _TimelineItemState extends State<TimelineItem>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _hoverController;
  late Animation<double> _elevationAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: AppConstants.animationNormal,
      vsync: this,
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
                return Padding(
                  padding: EdgeInsets.only(bottom: AppConstants.spacing24),
                  child: Transform.translate(
                    offset: Offset(0, -8.0 * _elevationAnimation.value),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.05 * _glowAnimation.value),
                            blurRadius: 16 * _glowAnimation.value,
                            spreadRadius: 0,
                            offset: Offset(0, 6 * _elevationAnimation.value),
                          ),
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.12 * _glowAnimation.value),
                            blurRadius: 12 * _glowAnimation.value,
                            spreadRadius: -2,
                            offset: Offset(0, 4 * _elevationAnimation.value),
                          ),
                        ],
                      ),
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
                );
              },
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
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([_pulseAnimation, _glowAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: widget.isHovered ? 1.4 : _pulseAnimation.value,
              child: Container(
                width: 18,
                height: 18,
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
                        widget.isHovered ? 0.8 : _glowAnimation.value,
                      ),
                      blurRadius: widget.isHovered ? 16 : 12,
                      spreadRadius: widget.isHovered ? 4 : 2,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        if (!widget.isLast)
          AnimatedContainer(
            duration: AppConstants.animationNormal,
            curve: Curves.easeInOutCubic,
            width: widget.isHovered ? 3 : 2,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withOpacity(widget.isHovered ? 0.8 : 0.4),
                  AppColors.primary.withOpacity(widget.isHovered ? 0.6 : 0.2),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
