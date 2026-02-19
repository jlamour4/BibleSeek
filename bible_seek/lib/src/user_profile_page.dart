import 'package:bible_seek/src/design/spacing.dart';
import 'package:bible_seek/src/design/text_styles.dart';
import 'package:bible_seek/src/models/app_user.dart';
import 'package:bible_seek/src/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// User profile page. Shows backend user data from currentUserProvider.
/// Supports editing name, bio, location via PATCH /api/me.
class UserProfilePage extends HookConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (userAsync.asData?.value != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _showEditProfileSheet(context, ref, userAsync.asData!.value!),
            ),
        ],
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.space24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                const SizedBox(height: AppSpacing.space16),
                Text(
                  'Failed to load profile',
                  style: AppTextStyles.screenTitle(context),
                ),
                const SizedBox(height: AppSpacing.space8),
                Text(
                  err.toString(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.metaText(context),
                ),
              ],
            ),
          ),
        ),
        data: (user) {
          if (user == null) {
            return Center(
              child: Text(
                'Not signed in',
                style: AppTextStyles.bodyText(context),
              ),
            );
          }
          return _ProfileContent(user: user);
        },
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context, WidgetRef ref, AppUser user) {
    final nameController = TextEditingController(text: user.name);
    final bioController = TextEditingController(text: user.bio ?? '');
    final locationController = TextEditingController(text: user.location ?? '');
    var isSaving = false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.space16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Edit profile',
                  style: AppTextStyles.sectionTitle(ctx),
                ),
                const SizedBox(height: AppSpacing.space16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.space12),
                TextField(
                  controller: bioController,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: AppSpacing.space12),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.space24),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          setModalState(() => isSaving = true);
                          try {
                            await updateProfile(
                              name: nameController.text.trim(),
                              bio: bioController.text.trim().isEmpty
                                  ? null
                                  : bioController.text.trim(),
                              location: locationController.text.trim().isEmpty
                                  ? null
                                  : locationController.text.trim(),
                            );
                            ref.invalidate(currentUserProvider);
                            if (ctx.mounted) Navigator.pop(ctx);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Profile updated')),
                              );
                            }
                          } catch (e) {
                            setModalState(() => isSaving = false);
                            if (ctx.mounted) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          }
                        },
                  child: isSaving ? const Text('Saving…') : const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: colorScheme.primaryContainer,
              backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                  ? NetworkImage(user.avatarUrl!)
                  : null,
              child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 48,
                      color: colorScheme.onPrimaryContainer,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: AppSpacing.space24),
          _ProfileField(
            label: 'Name',
            value: user.name.isNotEmpty ? user.name : '—',
            icon: Icons.badge_outlined,
          ),
          const SizedBox(height: AppSpacing.space16),
          _UsernameField(username: user.username),
          const SizedBox(height: AppSpacing.space16),
          _ProfileField(
            label: 'Email',
            value: user.email.isNotEmpty ? user.email : '—',
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: AppSpacing.space16),
          _ProfileField(
            label: 'Bio',
            value: user.bio?.isNotEmpty == true ? user.bio! : '—',
            icon: Icons.info_outline,
          ),
          const SizedBox(height: AppSpacing.space16),
          _ProfileField(
            label: 'Location',
            value: user.location?.isNotEmpty == true ? user.location! : '—',
            icon: Icons.location_on_outlined,
          ),
        ],
      ),
    );
  }
}

class _UsernameField extends StatelessWidget {
  const _UsernameField({this.username});

  final String? username;

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
          Icon(Icons.alternate_email, size: 22, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Username',
                  style: AppTextStyles.metaText(context).copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.space4),
                if (username != null && username!.isNotEmpty)
                  Text(
                    username!,
                    style: AppTextStyles.bodyText(context),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Navigate to choose username screen/modal
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Username selection coming soon')),
                      );
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Choose username'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),
        ],
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
