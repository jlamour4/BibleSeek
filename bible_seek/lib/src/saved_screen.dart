import 'package:bible_seek/src/design/spacing.dart';
import 'package:bible_seek/src/design/text_styles.dart';
import 'package:bible_seek/src/providers/saved_provider.dart';
import 'package:bible_seek/src/topic_verses_screen.dart';
import 'package:bible_seek/src/verse_detail_screen.dart';
import 'package:bible_seek/widgets/verse_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Saved screen with two tabs: Passages and Topics.
/// Endpoint: GET /api/me/favorites for passages, GET /api/me/saved-topics for topics.
class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Saved'),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Passages'),
              Tab(text: 'Topics'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.invalidate(savedTopicsProvider);
                ref.invalidate(savedPassagesProvider);
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            SavedPassagesTab(),
            SavedTopicsTab(),
          ],
        ),
      ),
    );
  }
}

/// Passages tab: saved verses from GET /api/me/favorites.
/// Uses VerseCard with optional topic chip. Bottom padding for Android nav bar.
class SavedPassagesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(savedPassagesProvider);
    final locallyUnsaved = ref.watch(locallyUnsavedVerseIdsProvider);
    final bottomPadding = MediaQuery.of(context).padding.bottom + 16;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(savedPassagesProvider);
        await ref.read(savedPassagesProvider.future);
      },
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Padding(
          padding: const EdgeInsets.all(AppSpacing.space24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Failed to load saved passages',
                style: AppTextStyles.bodyText(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.space16),
              ElevatedButton(
                onPressed: () => ref.invalidate(savedPassagesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (passages) {
          if (passages.isEmpty) {
            return ListView(
              padding: EdgeInsets.only(bottom: bottomPadding, top: 8),
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.space24),
                  child: Text(
                    'No saved passages yet',
                    style: AppTextStyles.metaText(context).copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            );
          }
          return ListView.builder(
            padding: EdgeInsets.only(bottom: bottomPadding, top: 8),
            itemCount: passages.length,
            itemBuilder: (context, index) {
              final p = passages[index];
              return _SavedPassageCard(
                passage: p,
                isFavorited: !locallyUnsaved.contains(p.verse.id),
                onUnsave: () => _handleUnsave(context, ref, p.verse.id),
                onResave: () => _handleResave(ref, p.verse.id),
              );
            },
          );
        },
      ),
    );
  }

  void _handleUnsave(BuildContext context, WidgetRef ref, int verseId) {
    ref.read(locallyUnsavedVerseIdsProvider.notifier).add(verseId);
    ref.read(favoriteOverridesProvider.notifier).set(verseId, false);
    toggleFavoriteVerse(verseId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removed from saved. Reload to update.')),
    );
  }

  void _handleResave(WidgetRef ref, int verseId) {
    ref.read(locallyUnsavedVerseIdsProvider.notifier).remove(verseId);
    ref.read(favoriteOverridesProvider.notifier).set(verseId, true);
    toggleFavoriteVerse(verseId);
  }
}

/// Topics tab: saved topics from GET /api/me/saved-topics.
class SavedTopicsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(savedTopicsProvider);
    final bottomPadding = MediaQuery.of(context).padding.bottom + 16;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(savedTopicsProvider);
        await ref.read(savedTopicsProvider.future);
      },
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Padding(
          padding: const EdgeInsets.all(AppSpacing.space24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Failed to load saved topics',
                style: AppTextStyles.bodyText(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.space16),
              ElevatedButton(
                onPressed: () => ref.invalidate(savedTopicsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (topics) {
          final validTopics = topics.where((t) => t.id.isNotEmpty).toList();
          if (validTopics.isEmpty) {
            return ListView(
              padding: EdgeInsets.only(bottom: bottomPadding, top: 8),
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.space24),
                  child: Text(
                    'No saved topics yet',
                    style: AppTextStyles.metaText(context).copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            );
          }
          return ListView.builder(
            padding: EdgeInsets.only(bottom: bottomPadding, top: 8),
            itemCount: validTopics.length,
            itemBuilder: (context, index) {
              final t = validTopics[index];
              return ListTile(
                leading: const Icon(Icons.folder_outlined),
                title: Text(t.name, style: AppTextStyles.bodyText(context)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => TopicVersesScreen(
                        topicId: t.id,
                        topicName: t.name,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _SavedPassageCard extends StatelessWidget {
  const _SavedPassageCard({
    required this.passage,
    required this.isFavorited,
    required this.onUnsave,
    required this.onResave,
  });

  final SavedPassage passage;
  final bool isFavorited;
  final VoidCallback onUnsave;
  final VoidCallback onResave;

  @override
  Widget build(BuildContext context) {
    final v = passage.verse;
    return VerseCard(
      displayRef: v.displayRef,
      previewText: v.previewText,
      voteCount: v.voteCount,
      commentCount: 0,
      isFavorited: isFavorited,
      topicLabel: passage.topicName.isNotEmpty ? passage.topicName : null,
      onUpvote: () {},
      onDownvote: () {},
      onFavorite: isFavorited ? onUnsave : onResave,
      onComment: () {},
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => VerseDetailScreen(
              topicId: passage.topicId,
              topicName: passage.topicName,
              verse: v,
            ),
          ),
        );
      },
    );
  }
}
