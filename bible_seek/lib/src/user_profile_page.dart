import 'package:bible_seek/src/design/spacing.dart';
import 'package:bible_seek/src/design/text_styles.dart';
import 'package:flutter/material.dart';

/// Placeholder user profile page. Shows Name, Email, Birthday, About, Links.
/// TODO: Wire to real user data from backend.
class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(
                  Icons.person,
                  size: 48,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.space24),
            _ProfileField(label: 'Name', value: '—', icon: Icons.badge_outlined),
            const SizedBox(height: AppSpacing.space16),
            _ProfileField(label: 'Email', value: '—', icon: Icons.email_outlined),
            const SizedBox(height: AppSpacing.space16),
            _ProfileField(label: 'Birthday', value: '—', icon: Icons.cake_outlined),
            const SizedBox(height: AppSpacing.space16),
            _ProfileField(label: 'About', value: '—', icon: Icons.info_outline),
            const SizedBox(height: AppSpacing.space16),
            _ProfileField(label: 'Links', value: '—', icon: Icons.link),
          ],
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.space16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.metaText(context).copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.space4),
                Text(
                  value,
                  style: AppTextStyles.bodyText(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
