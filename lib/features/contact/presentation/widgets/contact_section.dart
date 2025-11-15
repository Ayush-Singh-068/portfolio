import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/widgets/animated_section.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/constants/responsive_utils.dart';
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

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 80),
      child: AnimatedSection(
        id: 'contact',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 48),
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
                  const SizedBox(width: 48),
                  Expanded(
                    child: _SocialLinks(onLaunchUrl: _launchUrl),
                  ),
                ],
              ],
            ),
            if (ResponsiveUtils.isMobile(context)) ...[
              const SizedBox(height: 32),
              _SocialLinks(onLaunchUrl: _launchUrl),
            ],
          ],
        ),
      ),
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
    return GlassContainer(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: nameController,
            onChanged: onNameChanged,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.surfaceLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.surfaceLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: emailController,
            onChanged: onEmailChanged,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.surfaceLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.surfaceLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: messageController,
            onChanged: onMessageChanged,
            maxLines: 6,
            decoration: InputDecoration(
              labelText: 'Message',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.surfaceLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.surfaceLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
          if (contactState.error != null) ...[
            const SizedBox(height: 16),
            Text(
              contactState.error!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
            ),
          ],
          if (contactState.isSuccess) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.success),
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
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          CustomButton(
            text: contactState.isLoading ? 'Sending...' : 'Send Message',
            icon: Icons.send,
            onPressed: contactState.isLoading ? null : onSubmit,
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
    return GlassContainer(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          _ContactInfo(
            icon: Icons.email,
            label: 'Email',
            value: 'ayushrajavat2018@gmail.com',
            onTap: () => onLaunchUrl('mailto:ayushrajavat2018@gmail.com'),
          ),
          const SizedBox(height: 16),
          _ContactInfo(
            icon: Icons.phone,
            label: 'Phone',
            value: '+91 9795840010',
            onTap: () => onLaunchUrl('tel:+919795840010'),
          ),
          const SizedBox(height: 16),
          _ContactInfo(
            icon: Icons.location_on,
            label: 'Location',
            value: 'Kanpur, India',
            onTap: null,
          ),
          const SizedBox(height: 32),
          Text(
            'Connect with me',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          _SocialLink(
            icon: FontAwesomeIcons.linkedin,
            label: 'LinkedIn',
            url: 'https://www.linkedin.com/in/ayush-singh-3a0ab2165/',
            onTap: () => onLaunchUrl('https://www.linkedin.com/in/ayush-singh-3a0ab2165/'),
          ),
          const SizedBox(height: 16),
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

class _ContactInfo extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final widget = Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          if (onTap != null)
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: widget,
      );
    }
    return widget;
  }
}

class _SocialLink extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: 16),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

