import 'package:bible_seek/src/api/authenticated_client.dart';
import 'package:bible_seek/src/config/config.dart';
import 'package:bible_seek/src/design/app_colors.dart';
import 'package:bible_seek/src/design/radius.dart';
import 'package:bible_seek/src/design/spacing.dart';
import 'package:bible_seek/src/design/text_styles.dart';
import 'package:bible_seek/src/providers/saved_provider.dart';
import 'package:bible_seek/src/verse.dart';
import 'package:bible_seek/widgets/expandable_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Fetches full text for a single verse. GET /api/topics/{topicId}/verses/{itemId}
final verseDetailProvider = FutureProvider.autoDispose
    .family<String, ({String topicId, int itemId})>((ref, params) async {
  final dio = AuthenticatedDio(Dio()).dio;
  final uri =
      '${AppConfig.currentHost}/api/topics/${params.topicId}/verses/${params.itemId}';

  final response = await dio.get(
    uri,
    options: Options(
      headers: <String, String>{'Content-Type': 'application/json'},
    ),
  );

  if (response.statusCode != 200) {
    throw Exception(
        'Failed to load verse: ${response.statusCode} ${response.statusMessage}');
  }

  final data = response.data;
  if (data is Map && data['fullText'] != null) {
    return data['fullText'] as String;
  }
  if (data is Map && data['previewText'] != null) {
    return data['previewText'] as String;
  }
  throw Exception('Invalid response: missing fullText');
});

/// Detail screen for a single verse within a topic.
/// Fetches fullText via GET /api/topics/{topicId}/verses/{itemId}.
/// Matches TopicVerseCard style: accent bar, reference, Kameron verse text, action row.
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

  static const double _accentBarWidth = 3;
  static const int _expandMaxLines = 6;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = verse;
    final isExpanded = useState(false);
    final overrides = ref.watch(favoriteOverridesProvider);
    final isFavorited = isVerseFavorited(v, overrides);

    Future<void> handleFavorite() async {
      final next = !isFavorited;
      ref.read(favoriteOverridesProvider.notifier).updateMap((m) {
        m[v.id] = next;
        return m;
      });
      try {
        await toggleFavoriteVerse(v.id);
        ref.invalidate(savedPassagesProvider);
      } catch (_) {
        if (context.mounted) {
          ref.read(favoriteOverridesProvider.notifier).remove(v.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update favorite')),
          );
        }
      }
    }

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
              isFavorited ? Icons.favorite : Icons.favorite_border,
              color: isFavorited ? AppColors.likeRed : null,
            ),
            onPressed: handleFavorite,
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + AppSpacing.space24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _VerseDetailCard(
                displayRef: v.displayRef,
                verseText: verseText,
                isLoading: isLoading,
                isExpanded: isExpanded.value,
                onExpandChanged: (expanded) => isExpanded.value = expanded,
                voteCount: v.voteCount,
                commentCount: 0,
                isFavorited: isFavorited,
                onUpvote: () => debugPrint('[VerseDetail] upvote id=${v.id}'),
                onDownvote: () => debugPrint('[VerseDetail] downvote id=${v.id}'),
                onComment: () => debugPrint('[VerseDetail] comment id=${v.id}'),
                onFavorite: handleFavorite,
              ),
              const Divider(height: AppSpacing.space32),
              _CommentsPlaceholder(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Verse card matching TopicVerseCard: accent bar, reference, ExpandableText, action row, floating Collapse chip.
class _VerseDetailCard extends StatelessWidget {
  const _VerseDetailCard({
    required this.displayRef,
    required this.verseText,
    required this.isLoading,
    required this.isExpanded,
    required this.onExpandChanged,
    required this.voteCount,
    required this.commentCount,
    required this.isFavorited,
    required this.onUpvote,
    required this.onDownvote,
    required this.onComment,
    required this.onFavorite,
  });

  final String displayRef;
  final String verseText;
  final bool isLoading;
  final bool isExpanded;
  final ValueChanged<bool> onExpandChanged;
  final int voteCount;
  final int commentCount;
  final bool isFavorited;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  final VoidCallback onComment;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space12,
        AppSpacing.space12,
        AppSpacing.space12,
        AppSpacing.space12,
      ),
      child: Card(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.r14),
        child: ClipRRect(
          borderRadius: AppRadius.r14,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.space12 + VerseDetailScreen._accentBarWidth + AppSpacing.space12,
                  AppSpacing.space10,
                  AppSpacing.space14,
                  AppSpacing.space16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      displayRef,
                      style: AppTextStyles.metaText(context).copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space8),
                    ExpandableText(
                      text: verseText,
                      style: GoogleFonts.kameron(
                        fontSize: 16,
                        height: 1.5,
                        fontWeight: FontWeight.normal,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: VerseDetailScreen._expandMaxLines,
                      isExpanded: isExpanded,
                      onExpandChanged: onExpandChanged,
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
                    const SizedBox(height: AppSpacing.space12),
                    _VerseActionsRow(
                      voteCount: voteCount,
                      commentCount: commentCount,
                      isFavorited: isFavorited,
                      onUpvote: onUpvote,
                      onDownvote: onDownvote,
                      onComment: onComment,
                      onFavorite: onFavorite,
                    ),
                  ],
                ),
              ),
              Positioned(
                left: AppSpacing.space12,
                top: AppSpacing.space12,
                bottom: AppSpacing.space12,
                child: Container(
                  width: VerseDetailScreen._accentBarWidth,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.35),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(2),
                      bottom: Radius.circular(2),
                    ),
                  ),
                ),
              ),
              ],
            ),
          ),
        ),
      );
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
    final colorScheme = Theme.of(context).colorScheme;
    final mutedColor = colorScheme.onSurfaceVariant;

    return Row(
      children: [
        _MiniAction(
          icon: Icons.thumb_up_alt_outlined,
          label: _formatCount(voteCount),
          onTap: onUpvote,
          iconColor: mutedColor,
          labelColor: mutedColor,
          fontSize: 11,
        ),
        const SizedBox(width: AppSpacing.space12),
        _MiniAction(
          icon: Icons.thumb_down_alt_outlined,
          label: '',
          onTap: onDownvote,
          iconColor: mutedColor,
        ),
        const SizedBox(width: AppSpacing.space12),
        _MiniAction(
          icon: Icons.chat_bubble_outline,
          label: commentCount > 0 ? _formatCount(commentCount) : '',
          onTap: onComment,
          iconColor: mutedColor,
          labelColor: mutedColor,
          fontSize: 11,
        ),
        const SizedBox(width: AppSpacing.space12),
        _MiniAction(
          icon: isFavorited ? Icons.favorite : Icons.favorite_border,
          label: '',
          onTap: onFavorite,
          iconColor: isFavorited ? AppColors.likeRed : mutedColor,
        ),
      ],
    );
  }
}

class _MiniAction extends StatelessWidget {
  const _MiniAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
    this.fontSize,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveLabelColor = labelColor ?? colorScheme.onSurfaceVariant;

    return InkWell(
      borderRadius: AppRadius.r24,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space6,
          vertical: AppSpacing.space4,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: iconColor ?? colorScheme.onSurfaceVariant,
            ),
            if (label.isNotEmpty) ...[
              const SizedBox(width: AppSpacing.space5),
              Text(
                label,
                style: AppTextStyles.metaText(context).copyWith(
                  fontSize: fontSize ?? 12,
                  color: effectiveLabelColor,
                ),
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
