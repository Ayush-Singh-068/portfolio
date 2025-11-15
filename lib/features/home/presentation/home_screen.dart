import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:ui';
import '../../../../core/constants/responsive_utils.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/animated_text_reveal.dart';
import '../../../../core/widgets/animated_background.dart';
import 'widgets/hero_section.dart';
import '../../skills/presentation/widgets/skills_section.dart';
import '../../projects/presentation/widgets/projects_section.dart';
import '../../experience/presentation/widgets/experience_section.dart';
import '../../contact/presentation/widgets/contact_section.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final homeKey = useMemoized(() => GlobalKey());
    final skillsKey = useMemoized(() => GlobalKey());
    final projectsKey = useMemoized(() => GlobalKey());
    final experienceKey = useMemoized(() => GlobalKey());
    final contactKey = useMemoized(() => GlobalKey());

    void scrollToSection(GlobalKey key) {
      final context = key.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: AppConstants.animationVerySlow,
          curve: Curves.easeInOutCubic,
        );
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          const AnimatedBackground(),
          // Content
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                HeroSection(key: homeKey, scrollController: scrollController),
                SkillsSection(key: skillsKey),
                ProjectsSection(key: projectsKey),
                ExperienceSection(key: experienceKey),
                ContactSection(key: contactKey),
              ],
            ),
          ),
          _NavBar(
            scrollController: scrollController,
            homeKey: homeKey,
            skillsKey: skillsKey,
            projectsKey: projectsKey,
            experienceKey: experienceKey,
            contactKey: contactKey,
            onHomeTap: () => scrollToSection(homeKey),
            onSkillsTap: () => scrollToSection(skillsKey),
            onProjectsTap: () => scrollToSection(projectsKey),
            onExperienceTap: () => scrollToSection(experienceKey),
            onContactTap: () => scrollToSection(contactKey),
          ),
        ],
      ),
    );
  }
}

class _NavBar extends HookWidget {
  final ScrollController scrollController;
  final GlobalKey homeKey;
  final GlobalKey skillsKey;
  final GlobalKey projectsKey;
  final GlobalKey experienceKey;
  final GlobalKey contactKey;
  final VoidCallback onHomeTap;
  final VoidCallback onSkillsTap;
  final VoidCallback onProjectsTap;
  final VoidCallback onExperienceTap;
  final VoidCallback onContactTap;

  const _NavBar({
    required this.scrollController,
    required this.homeKey,
    required this.skillsKey,
    required this.projectsKey,
    required this.experienceKey,
    required this.contactKey,
    required this.onHomeTap,
    required this.onSkillsTap,
    required this.onProjectsTap,
    required this.onExperienceTap,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    final scrollOffset = useState(0.0);
    final activeSection = useState<String>('Home');
    final screenHeight = MediaQuery.of(context).size.height;
    final lastScrollTime = useRef<DateTime>(DateTime.now());
    final lastActiveSectionCheck = useRef<DateTime>(DateTime.now());

    useEffect(() {
      void onScroll() {
        final now = DateTime.now();
        final timeSinceLastUpdate = now.difference(lastScrollTime.value).inMilliseconds;
        
        // Throttle scroll offset updates
        if (timeSinceLastUpdate >= AppConstants.scrollThrottleMs) {
          scrollOffset.value = scrollController.offset;
          lastScrollTime.value = now;
        }
        
        // Throttle active section detection (check less frequently)
        final timeSinceLastSectionCheck = now.difference(lastActiveSectionCheck.value).inMilliseconds;
        if (timeSinceLastSectionCheck >= AppConstants.scrollThrottleMs * 2) {
          // Determine active section based on scroll position
          final keys = [
            ('Home', homeKey),
            ('Skills', skillsKey),
            ('Projects', projectsKey),
            ('Experience', experienceKey),
            ('Contact', contactKey),
          ];
          
          // Cache screen height to avoid MediaQuery lookup
          final threshold = screenHeight * AppConstants.activeSectionThreshold;
          
          for (final entry in keys) {
            final key = entry.$2;
            final keyContext = key.currentContext;
            if (keyContext != null) {
              final renderObject = keyContext.findRenderObject();
              if (renderObject is RenderBox) {
                final position = renderObject.localToGlobal(Offset.zero);
                if (position.dy <= threshold && position.dy >= AppConstants.activeSectionTopOffset) {
                  if (activeSection.value != entry.$1) {
                    activeSection.value = entry.$1;
                  }
                  break;
                }
              }
            }
          }
          lastActiveSectionCheck.value = now;
        }
      }
      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController, screenHeight]);

    // Show navbar initially, hide only when at very top
    final shouldShowNavbar = scrollOffset.value >= 0;
    final scrollProgress = scrollOffset.value.clamp(0.0, AppConstants.scrollProgressMax) / AppConstants.scrollProgressMax;
    final blurIntensity = (AppConstants.navbarBlurMin + (scrollProgress * (AppConstants.navbarBlurMax - AppConstants.navbarBlurMin))).clamp(AppConstants.navbarBlurMin, AppConstants.navbarBlurMax);
    final borderOpacity = scrollProgress.clamp(0.0, 1.0);

    return AnimatedPositioned(
      duration: AppConstants.animationNormal,
      curve: Curves.easeOutCubic,
      top: shouldShowNavbar ? 0 : AppConstants.navbarHideOffset,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Column(
          children: [
            // Enhanced scroll progress indicator with gradient
            Builder(
              builder: (context) {
                final progress = _getScrollProgress(scrollController);
                return Container(
                  height: 3,
                  width: double.infinity,
                  color: AppColors.surface.withValues(alpha: 0.3),
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: AppConstants.animationFast,
                        width: MediaQuery.of(context).size.width * progress,
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.secondary,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.6),
                              blurRadius: 4,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blurIntensity, sigmaY: blurIntensity),
                child: Container(
                  height: AppConstants.navbarHeight,
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.getPadding(context),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.surface.withValues(alpha: 0.85),
                        AppColors.surface.withValues(alpha: 0.75),
                      ],
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.3 * borderOpacity),
                        width: 1.5,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 40,
                        offset: const Offset(0, 8),
                        spreadRadius: -5,
                      ),
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15 * borderOpacity),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Enhanced logo/brand
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: onHomeTap,
                          child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: AnimatedTextReveal(
                              text: AppConstants.appName,
                              type: TextRevealType.fadeIn,
                              delay: Duration.zero,
                              duration: AppConstants.animationNormal,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.8,
                                    fontSize: 22,
                                    color: Colors.white,
                                  ) ??
                                  TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.8,
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      if (ResponsiveUtils.isDesktop(context))
                        Row(
                          children: [
                            _NavItem(
                              text: 'Home',
                              isActive: activeSection.value == 'Home',
                              onTap: onHomeTap,
                            ),
                            _NavItem(
                              text: 'Skills',
                              isActive: activeSection.value == 'Skills',
                              onTap: onSkillsTap,
                            ),
                            _NavItem(
                              text: 'Projects',
                              isActive: activeSection.value == 'Projects',
                              onTap: onProjectsTap,
                            ),
                            _NavItem(
                              text: 'Experience',
                              isActive: activeSection.value == 'Experience',
                              onTap: onExperienceTap,
                            ),
                            _NavItem(
                              text: 'Contact',
                              isActive: activeSection.value == 'Contact',
                              onTap: onContactTap,
                            ),
                          ],
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: PopupMenuButton(
                            icon: Icon(
                              Icons.menu,
                              color: AppColors.textPrimary,
                              size: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: AppColors.surface,
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: _MobileNavItem(
                                  text: 'Home',
                                  isActive: activeSection.value == 'Home',
                                  onTap: () {
                                    Navigator.pop(context);
                                    onHomeTap();
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                child: _MobileNavItem(
                                  text: 'Skills',
                                  isActive: activeSection.value == 'Skills',
                                  onTap: () {
                                    Navigator.pop(context);
                                    onSkillsTap();
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                child: _MobileNavItem(
                                  text: 'Projects',
                                  isActive: activeSection.value == 'Projects',
                                  onTap: () {
                                    Navigator.pop(context);
                                    onProjectsTap();
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                child: _MobileNavItem(
                                  text: 'Experience',
                                  isActive: activeSection.value == 'Experience',
                                  onTap: () {
                                    Navigator.pop(context);
                                    onExperienceTap();
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                child: _MobileNavItem(
                                  text: 'Contact',
                                  isActive: activeSection.value == 'Contact',
                                  onTap: () {
                                    Navigator.pop(context);
                                    onContactTap();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getScrollProgress(ScrollController controller) {
    if (!controller.hasClients) return 0.0;
    try {
      final maxScroll = controller.position.maxScrollExtent;
      if (maxScroll == 0 || maxScroll.isNaN || maxScroll.isInfinite) return 0.0;
      final offset = controller.offset;
      if (offset.isNaN || offset.isInfinite) return 0.0;
      return (offset / maxScroll).clamp(0.0, 1.0);
    } catch (e) {
      return 0.0;
    }
  }
}

class _NavItem extends StatefulWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _underlineController;
  late Animation<double> _underlineAnimation;

  @override
  void initState() {
    super.initState();
    _underlineController = AnimationController(
      duration: AppConstants.animationNormal,
      vsync: this,
    );
    _underlineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _underlineController,
        curve: Curves.easeOutCubic,
      ),
    );
    if (widget.isActive) {
      _underlineController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _underlineController.forward();
      } else if (!_isHovered) {
        _underlineController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _underlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActiveOrHovered = widget.isActive || _isHovered;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _underlineController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        if (!widget.isActive) {
          _underlineController.reverse();
        }
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppConstants.animationFast,
          padding: EdgeInsets.symmetric(horizontal: AppConstants.spacing20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: AppConstants.animationFast,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: isActiveOrHovered
                          ? AppColors.primary
                          : AppColors.textPrimary.withValues(alpha: 0.7),
                      fontWeight: isActiveOrHovered ? FontWeight.w700 : FontWeight.w500,
                      fontSize: AppConstants.fontSizeBase,
                    ) ??
                    TextStyle(
                      fontSize: AppConstants.fontSizeBase,
                      color: isActiveOrHovered
                          ? AppColors.primary
                          : AppColors.textPrimary.withValues(alpha: 0.7),
                      fontWeight: isActiveOrHovered ? FontWeight.w700 : FontWeight.w500,
                    ),
                child: Text(widget.text),
              ),
              SizedBox(height: AppConstants.spacing4),
              AnimatedBuilder(
                animation: _underlineAnimation,
                builder: (context, child) {
                  return Container(
                    height: 3,
                    width: 50 * _underlineAnimation.value,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.6 * _underlineAnimation.value),
                          blurRadius: 6 * _underlineAnimation.value,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const _MobileNavItem({
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (isActive)
              Container(
                width: 4,
                height: 20,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isActive
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
