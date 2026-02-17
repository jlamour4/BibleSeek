import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:bible_seek/src/design/app_colors.dart';
import 'package:bible_seek/src/design/radius.dart';
import 'package:bible_seek/src/design/spacing.dart';
import 'package:bible_seek/src/design/text_styles.dart';
import 'package:bible_seek/src/topic_verses_screen.dart';
import 'package:bible_seek/src/verse.dart';

/// Detail screen for a single verse within a topic.
/// Fetches fullText via GET /api/topics/{topicId}/verses/{itemId}.
/// Shows full verse text with expand/collapse, actions, and comments placeholder.
/// Falls back to previewText when the request fails.
/// TODO: Wire real comments API.
/// TODO: Wire vote actions to backend.
class VerseDetailScreen extends HookConsumerWidget {
  const VerseDetailScreen({
    super.key,
    required this.topicId,
    required this.topicName,
    required this.verse,
  });

  final String topicId;
  final String topicName;
  final Verse verse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = verse;
    final isExpanded = useState(false);
    final isFavorited = useState(false);

    final fullTextAsync = ref.watch(verseDetailProvider((
      topicId: topicId,
      itemId: v.id,
    )));

    final (verseText, isLoading) = switch (fullTextAsync) {
      AsyncData(:final value) => (
          value.isNotEmpty ? value : v.previewText,
          false,
        ),
      AsyncLoading() => (v.previewText, true),
      AsyncError() => (v.previewText, false),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(topicName),
        actions: [
          IconButton(
            icon: Icon(
              isFavorited.value ? Icons.favorite : Icons.favorite_border,
              color: isFavorited.value ? AppColors.likeRed : null,
            ),
            onPressed: () => isFavorited.value = !isFavorited.value,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) => debugPrint('[VerseDetail] menu: $value'),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'share',
                child: Text('Share'),
              ),
              const PopupMenuItem(
                value: 'report',
                child: Text('Report'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card: displayRef + verse text (fullText when loaded, previewText fallback)
            _VerseHeaderSection(
              displayRef: v.displayRef,
              verseText: verseText,
              isLoading: isLoading,
              isExpanded: isExpanded.value,
              onToggleExpand: () => isExpanded.value = !isExpanded.value,
            ),
            const SizedBox(height: AppSpacing.space16),
            // Actions row
            _VerseActionsRow(
              voteCount: v.voteCount,
              commentCount: 0,
              isFavorited: isFavorited.value,
              onUpvote: () => debugPrint('[VerseDetail] upvote id=${v.id}'),
              onDownvote: () => debugPrint('[VerseDetail] downvote id=${v.id}'),
              onComment: () => debugPrint('[VerseDetail] comment id=${v.id}'),
              onFavorite: () => isFavorited.value = !isFavorited.value,
            ),
            const Divider(height: AppSpacing.space32),
            // Comments section placeholder
            _CommentsPlaceholder(),
          ],
        ),
      ),
    );
  }
}

class _VerseHeaderSection extends StatelessWidget {
  const _VerseHeaderSection({
    required this.displayRef,
    required this.verseText,
    required this.isLoading,
    required this.isExpanded,
    required this.onToggleExpand,
  });

  final String displayRef;
  final String verseText;
  final bool isLoading;
  final bool isExpanded;
  final VoidCallback onToggleExpand;

  static const int _collapsedMaxLines = 6;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.space16),
      child: Card(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.r14),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayRef,
                style: AppTextStyles.verseRef(context).copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.space12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final needsExpand = _needsExpandButton(verseText, context);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        verseText,
                        maxLines: isExpanded ? null : _collapsedMaxLines,
                        overflow: isExpanded ? null : TextOverflow.ellipsis,
                        style: AppTextStyles.bodyText(context).copyWith(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      if (isLoading)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.space12),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.space8),
                              Text(
                                'Loading full text…',
                                style: AppTextStyles.metaText(context).copyWith(
                                  fontSize: 13,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (needsExpand && !isLoading)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.space8),
                          child: TextButton.icon(
                            onPressed: onToggleExpand,
                            icon: Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 20,
                              color: colorScheme.primary,
                            ),
                            label: Text(
                              isExpanded ? 'Less' : 'More',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _needsExpandButton(String text, BuildContext context) {
    // Heuristic: ~50 chars per line × 6 lines = ~300 chars triggers expand
    const threshold = 300;
    return text.length > threshold;
  }
}

class _VerseActionsRow extends StatelessWidget {
  const _VerseActionsRow({
    required this.voteCount,
    required this.commentCount,
    required this.isFavorited,
    required this.onUpvote,
    required this.onDownvote,
    required this.onComment,
    required this.onFavorite,
  });

  final int voteCount;
  final int commentCount;
  final bool isFavorited;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  final VoidCallback onComment;
  final VoidCallback onFavorite;

  String _formatCount(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space16),
      child: Row(
        children: [
          _ActionChip(
            icon: Icons.thumb_up_alt_outlined,
            label: _formatCount(voteCount),
            onTap: onUpvote,
          ),
          const SizedBox(width: AppSpacing.space8),
          _ActionChip(
            icon: Icons.thumb_down_alt_outlined,
            label: '',
            onTap: onDownvote,
          ),
          const SizedBox(width: AppSpacing.space12),
          _ActionChip(
            icon: Icons.chat_bubble_outline,
            label: commentCount > 0 ? _formatCount(commentCount) : '',
            onTap: onComment,
          ),
          const Spacer(),
          IconButton(
            onPressed: onFavorite,
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              color: isFavorited ? AppColors.likeRed : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.r24,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space12,
          vertical: AppSpacing.space8,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: AppRadius.r24,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            if (label.isNotEmpty) ...[
              const SizedBox(width: AppSpacing.space6),
              Text(
                label,
                style: AppTextStyles.metaText(context).copyWith(fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CommentsPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comments',
            style: AppTextStyles.sectionTitle(context),
          ),
          const SizedBox(height: AppSpacing.space16),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.space24),
              child: Text(
                'No comments yet.\nBe the first to share your thoughts.',
                textAlign: TextAlign.center,
                style: AppTextStyles.metaText(context).copyWith(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
          // TODO: Add pinned input at bottom when comments API is wired
        ],
      ),
    );
  }
}
