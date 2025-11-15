import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../../core/constants/responsive_utils.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
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
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                HeroSection(key: homeKey),
                SkillsSection(key: skillsKey),
                ProjectsSection(key: projectsKey),
                ExperienceSection(key: experienceKey),
                ContactSection(key: contactKey),
              ],
            ),
          ),
          _NavBar(
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
  final VoidCallback onHomeTap;
  final VoidCallback onSkillsTap;
  final VoidCallback onProjectsTap;
  final VoidCallback onExperienceTap;
  final VoidCallback onContactTap;

  const _NavBar({
    required this.onHomeTap,
    required this.onSkillsTap,
    required this.onProjectsTap,
    required this.onExperienceTap,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    final isScrolled = useState(false);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isScrolled.value = true;
      });
      return null;
    }, []);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 64,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getPadding(context),
              ),
              decoration: BoxDecoration(
                color: AppColors.glassBackground.withOpacity(0.3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (ResponsiveUtils.isDesktop(context))
                    Row(
                      children: [
                        _NavItem(text: 'Home', onTap: onHomeTap),
                        _NavItem(text: 'Skills', onTap: onSkillsTap),
                        _NavItem(text: 'Projects', onTap: onProjectsTap),
                        _NavItem(text: 'Experience', onTap: onExperienceTap),
                        _NavItem(text: 'Contact', onTap: onContactTap),
                      ],
                    )
                  else
                    PopupMenuButton(
                      icon: const Icon(Icons.menu, color: AppColors.textPrimary),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: TextButton(
                            onPressed: onHomeTap,
                            child: const Text('Home'),
                          ),
                        ),
                        PopupMenuItem(
                          child: TextButton(
                            onPressed: onSkillsTap,
                            child: const Text('Skills'),
                          ),
                        ),
                        PopupMenuItem(
                          child: TextButton(
                            onPressed: onProjectsTap,
                            child: const Text('Projects'),
                          ),
                        ),
                        PopupMenuItem(
                          child: TextButton(
                            onPressed: onExperienceTap,
                            child: const Text('Experience'),
                          ),
                        ),
                        PopupMenuItem(
                          child: TextButton(
                            onPressed: onContactTap,
                            child: const Text('Contact'),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _NavItem({required this.text, required this.onTap});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppConstants.animationFast,
          padding: EdgeInsets.symmetric(horizontal: AppConstants.spacing24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.text,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: _isHovered
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ) ??
                    TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                      color: _isHovered
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: AppConstants.spacing4),
              AnimatedContainer(
                duration: AppConstants.animationFast,
                height: 2,
                width: _isHovered ? 30 : 0,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

