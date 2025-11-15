import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/widgets/animated_section.dart';
import '../../../../core/widgets/animated_text_reveal.dart';
import '../../../../core/widgets/animated_entrance.dart';
import '../../../../core/widgets/scroll_reveal_animation.dart';
import '../../../../core/widgets/animated_text_field.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/constants/responsive_utils.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../viewmodels/contact_viewmodel.dart';

class ContactSection extends HookConsumerWidget {
  const ContactSection({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final padding = ResponsiveUtils.getPadding(context);
    final contactState = ref.watch(contactViewModelProvider);
    final contactViewModel = ref.read(contactViewModelProvider.notifier);
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final messageController = useTextEditingController();

    useEffect(() {
      if (contactState.isSuccess) {
        nameController.clear();
        emailController.clear();
        messageController.clear();
      }
      return null;
    }, [contactState.isSuccess]);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: padding,
            vertical: ResponsiveUtils.getSectionPadding(context),
          ),
          child: AnimatedSection(
            id: 'contact',
            direction: RevealDirection.fade,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedTextReveal(
                  text: 'Contact',
                  type: TextRevealType.slideIn,
                  delay: const Duration(milliseconds: 200),
                  duration: AppConstants.animationNormal,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                ),
                SizedBox(height: AppConstants.spacing48),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: ResponsiveUtils.isMobile(context) ? 1 : 2,
                  child: _ContactForm(
                    nameController: nameController,
                    emailController: emailController,
                    messageController: messageController,
                    contactState: contactState,
                    onSubmit: () => contactViewModel.submitForm(),
                    onNameChanged: (value) => contactViewModel.updateName(value),
                    onEmailChanged: (value) => contactViewModel.updateEmail(value),
                    onMessageChanged: (value) => contactViewModel.updateMessage(value),
                  ),
                ),
                if (!ResponsiveUtils.isMobile(context)) ...[
                  SizedBox(width: AppConstants.spacing48),
                  Expanded(
                    child: _SocialLinks(onLaunchUrl: _launchUrl),
                  ),
                ],
              ],
            ),
            if (ResponsiveUtils.isMobile(context)) ...[
              SizedBox(height: AppConstants.spacing32),
              _SocialLinks(onLaunchUrl: _launchUrl),
            ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ContactForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController messageController;
  final ContactState contactState;
  final VoidCallback onSubmit;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onMessageChanged;

  const _ContactForm({
    required this.nameController,
    required this.emailController,
    required this.messageController,
    required this.contactState,
    required this.onSubmit,
    required this.onNameChanged,
    required this.onEmailChanged,
    required this.onMessageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cardPadding = ResponsiveUtils.getCardPadding(context);
    
    return GlassContainer(
      padding: EdgeInsets.all(cardPadding * 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedTextField(
            controller: nameController,
            labelText: 'Name',
            onChanged: onNameChanged,
          ),
          SizedBox(height: AppConstants.spacing20),
          AnimatedTextField(
            controller: emailController,
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress,
            onChanged: onEmailChanged,
          ),
          SizedBox(height: AppConstants.spacing20),
          AnimatedTextField(
            controller: messageController,
            labelText: 'Message',
            maxLines: 6,
            onChanged: onMessageChanged,
          ),
          if (contactState.error != null) ...[
            const SizedBox(height: 16),
            AnimatedTextReveal(
              text: contactState.error!,
              type: TextRevealType.slideIn,
              delay: Duration.zero,
              duration: AppConstants.animationNormal,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
            ),
          ],
          if (contactState.isSuccess) ...[
            const SizedBox(height: 16),
            AnimatedEntrance(
              type: EntranceType.slideInBottom,
              delay: Duration.zero,
              duration: AppConstants.animationNormal,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  border: Border.all(color: AppColors.success, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.success),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Message sent successfully!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          SizedBox(height: AppConstants.spacing24),
          SizedBox(
            height: 56,
            child: CustomButton(
              text: contactState.isLoading ? 'Sending...' : 'Send Message',
              icon: contactState.isLoading ? null : Icons.send,
              isLoading: contactState.isLoading,
              onPressed: contactState.isLoading ? null : onSubmit,
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialLinks extends StatelessWidget {
  final Function(String) onLaunchUrl;

  const _SocialLinks({required this.onLaunchUrl});

  @override
  Widget build(BuildContext context) {
    final cardPadding = ResponsiveUtils.getCardPadding(context);
    
    return GlassContainer(
      padding: EdgeInsets.all(cardPadding * 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: AppConstants.spacing24),
          _ContactInfo(
            icon: Icons.email,
            label: 'Email',
            value: 'ayushrajavat2018@gmail.com',
            onTap: () => onLaunchUrl('mailto:ayushrajavat2018@gmail.com'),
          ),
          SizedBox(height: AppConstants.spacing16),
          _ContactInfo(
            icon: Icons.location_on,
            label: 'Location',
            value: 'Kanpur, India',
            onTap: null,
          ),
          SizedBox(height: AppConstants.spacing32),
          Text(
            'Connect with me',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: AppConstants.spacing24),
          _SocialLink(
            icon: FontAwesomeIcons.linkedin,
            label: 'LinkedIn',
            url: 'https://www.linkedin.com/in/ayush-singh-3a0ab2165/',
            onTap: () => onLaunchUrl('https://www.linkedin.com/in/ayush-singh-3a0ab2165/'),
          ),
          SizedBox(height: AppConstants.spacing12),
          _SocialLink(
            icon: FontAwesomeIcons.github,
            label: 'GitHub',
            url: 'https://github.com',
            onTap: () => onLaunchUrl('https://github.com'),
          ),
        ],
      ),
    );
  }
}

class _ContactInfo extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _ContactInfo({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  State<_ContactInfo> createState() => _ContactInfoState();
}

class _ContactInfoState extends State<_ContactInfo> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(widget.icon, color: AppColors.primary, size: 24),
          SizedBox(width: AppConstants.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                SizedBox(height: AppConstants.spacing4),
                Text(
                  widget.value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          if (widget.onTap != null)
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
        ],
      ),
    );

    if (widget.onTap != null) {
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
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: AppConstants.animationFast,
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppColors.primary.withOpacity(0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
            child: content,
          ),
        ),
      );
    }
    return content;
  }
}

class _SocialLink extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;
  final VoidCallback onTap;

  const _SocialLink({
    required this.icon,
    required this.label,
    required this.url,
    required this.onTap,
  });

  @override
  State<_SocialLink> createState() => _SocialLinkState();
}

class _SocialLinkState extends State<_SocialLink> {
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
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppConstants.animationFast,
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.primary.withOpacity(0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(widget.icon, color: AppColors.primary, size: 24),
                SizedBox(width: AppConstants.spacing16),
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

